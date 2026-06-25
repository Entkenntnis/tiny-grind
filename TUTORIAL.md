# Proof Generation Tutorial

This tutorial walks through implementing the remaining proof generation code
in `tiny-grind`. When complete, the system will output standalone Lean kernel
proofs instead of `(by grind)` stubs.

## Background

The pipeline works like this:

1.  A Lean theorem with `by grind` is parsed from `problems/phase00/`.
2.  Hypotheses (`h1`, `h2`, ...) and the negated goal are fed into an e-graph.
3.  The e-graph runs congruence closure. If `True` and `False` land in the
    same e-class, a contradiction is found.
4.  **Currently broken:** `egraph.find_proof(TrueTerm(), FalseTerm())` returns
    `ElabTactic("grind")` -- a stub that calls back to real Lean.
5.  **Goal:** `find_proof` should return a real proof term (a chain of
    `Eq.trans`, `Eq.symm`, `congrArg`, etc.) that Lean can verify without the
    `grind` tactic.

---

## Step 0 -- Verify the current state

Run the tests to confirm the e-graph engine works:

```bash
python -m pytest tests/test_egraph3.py -v
```

Run on the example problems to see the stub output:

```bash
python main.py && cat problems/__output.lean | head -30
```

You'll see every proof body contains `(by grind)` -- our target to replace.

---

## Step 1 -- Fix the string-literal bug in `entry.py`

**File:** `src/tinygrind/entry.py`, line 82

**Problem:** The code passes `Var("proof_name")` (the string `"proof_name"`)
instead of `Var(proof_name)` (the variable whose value is `"h1"`, `"h2"`, etc.).
Every hypothesis gets the same wrong proof name.

**Fix:**

```python
# Before (line 82):
_ = egraph.addTerm(eg_term, Var("proof_name"))

# After:
_ = egraph.addTerm(eg_term, Var(proof_name))
```

**Why this matters for proof generation:** The proofs stored in the e-graph
are Lean variable names. `Var("h1")` means "the Lean variable named h1".
If every hypothesis is stored as `Var("proof_name")`, the generated proof
will reference a variable `proof_name` that doesn't exist in the context.

---

## Step 2 -- Enable proof storage in `_union_nodes_without_rebuild`

**File:** `src/tinygrind/egraph.py`, lines 601--608

**Problem:** The `_nodes_to_proof` dictionary exists (line 230) but is never
populated because the storage code is commented out. Even if uncommented,
there's a bug: line 608 stores `left→right` again with `Eq.symm` instead of
`right→left`.

**Current commented-out code:**

```python
# if proof:  # DEBUG!!!
#     if not self._nodes_to_proof[left]:
#         self._nodes_to_proof[left] = {}
#     self._nodes_to_proof[left][right] = proof
#     if not self._nodes_to_proof[right]:
#         self._nodes_to_proof[right] = {}
#     self._nodes_to_proof[left][right] = syntax.App(syntax.Var("Eq.symm"), proof)
```

**Replace lines 601--608 with:**

```python
        # Store proofs in both directions so we can traverse the graph
        # bidirectionally later during proof reconstruction.
        # The `proof` parameter is a Lean term proving left = right.
        if proof:
            self._nodes_to_proof.setdefault(left, {})[right] = proof
            self._nodes_to_proof.setdefault(right, {})[left] = (
                syntax.App(syntax.Var("Eq.symm"), proof)
            )
```

**What this does:**
- Stores `proof` (which proves `left = right`) under `nodes_to_proof[left][right]`.
- Stores `Eq.symm proof` (which proves `right = left`) under
  `nodes_to_proof[right][left]`.
- Uses `setdefault` to avoid the explicit `if key not in dict: dict[key] = {}`
  boilerplate.

**Data structure after this step:**
`_nodes_to_proof` becomes a directed graph where:
- Each edge `(u, v)` holds a proof that `u = v`.
- Both directions are always stored, so BFS can go either way.

---

## Step 3 -- Add the internal `_find_proof_node` method

**File:** `src/tinygrind/egraph.py`

**What:** Add a private method that traverses the `_nodes_to_proof` graph to
find a chain of equalities connecting two e-graph nodes, then composes them
into a single `syntax.Term` proof.

**Add the following import** at the top of `egraph.py` (after the existing
`from enum import Enum` and before `from scaffolding import syntax`):

```python
from collections import deque
```

**Add three new methods** inside the `EGraph` class. Place them after the
`find_proof` stub (around line 614) and before `_find_index` (line 616):

### Method A: `_find_proof_node`

```python
    def _find_proof_node(self, nodeA: Node, nodeB: Node) -> syntax.Term:
        """BFS through _nodes_to_proof to find a chain of equality
        proofs from nodeA to nodeB.

        Returns a Lean term proving that nodeA = nodeB.

        Raises RuntimeError if no path exists (should not happen when
        called after isBottom() returns True).
        """
        if nodeA == nodeB:
            # Trivially equal -- return Eq.refl.
            # We need the Lean term for the value, but since we are
            # inside an e-graph we don't have it readily available.
            # In practice this branch is rarely hit; if it is,
            # fall back to a simple rfl.
            return syntax.App(syntax.Var("rfl"), syntax.Var("_"))

        # BFS from nodeA to nodeB
        queue: deque[Node] = deque([nodeA])
        visited: set[Node] = {nodeA}
        # parent[n] = (previous_node, proof_that_previous_equals_n)
        parent: dict[Node, tuple[Node, syntax.Term]] = {}

        while queue:
            current = queue.popleft()

            if current == nodeB:
                return self._compose_proof_path(parent, nodeA, nodeB)

            for neighbor, proof in self._nodes_to_proof.get(current, {}).items():
                if neighbor not in visited:
                    visited.add(neighbor)
                    parent[neighbor] = (current, proof)
                    queue.append(neighbor)

        raise RuntimeError(
            f"No proof path between nodes {nodeA} and {nodeB}"
        )
```

### Method B: `_compose_proof_path`

```python
    def _compose_proof_path(
        self,
        parent: dict[Node, tuple[Node, syntax.Term]],
        start: Node,
        end: Node,
    ) -> syntax.Term:
        """Given a parent map from BFS, reconstruct and compose the
        chain of equality proofs from start to end using Eq.trans.

        Each entry parent[n] = (prev, p) means there is a proof p
        that prev = n.

        Returns a single Lean term proving start = end.
        """
        # Walk backwards from end to start, collecting edges.
        edges: list[syntax.Term] = []
        current = end
        while current != start:
            prev, proof = parent[current]
            # proof proves: prev = current
            edges.append(proof)
            current = prev

        # edges is now in reverse order (from end back to start).
        # Reverse to get start-to-end order.
        edges.reverse()

        # Compose with Eq.trans:
        #   Eq.trans e1 e2  proves  start = edges[1]  (if e1: start=edges[0],
        #   e2: edges[0]=edges[1])
        #   Chain all of them together.
        acc = edges[0]
        for i in range(1, len(edges)):
            acc = syntax.App(
                syntax.App(syntax.Var("Eq.trans"), acc),
                edges[i],
            )
        return acc
```

### Method C: `_get_node_name` (helper)

```python
    def _get_node_name(self, node: Node) -> str:
        """Extract the user-facing Lean name from a function-symbol,
        predicate-symbol, or constant node."""
        node_term = self._node_terms[self._node_index(node)]
        if isinstance(node_term, _FunctionSymbolNode):
            return node_term.name
        if isinstance(node_term, _PredicateSymbolNode):
            return node_term.name
        if isinstance(node_term, _ConstantNode):
            return node_term.name
        raise TypeError(f"Cannot extract name from node term: {node_term!r}")
```

**Verify:** At this point you can write a quick mental trace: when
`addPredicateApplication` is called with `proof=Var("h1")`, it calls
`_union_nodes(prop_node, self._true_node, Var("h1"))` which (after step 2)
stores `nodes_to_proof[prop_node][true_node] = Var("h1")` and
`nodes_to_proof[true_node][prop_node] = Eq.symm h1`.

---

## Step 4 -- Replace the `find_proof` stub

**File:** `src/tinygrind/egraph.py`, lines 612--614

**Before:**

```python
    def find_proof(self, A: Term, B: Term) -> syntax.Term:
        # PG: use proofs to create an equality between two nodes
        return syntax.ElabTactic("grind")
```

**Replace with:**

```python
    def find_proof(self, A: Term, B: Term) -> syntax.Term:
        """Construct a Lean proof that A = B by looking up the
        corresponding e-graph nodes and traversing the stored proof
        graph via BFS.

        This is the main public API called from entry.py.  It maps
        the abstract Term arguments to concrete e-graph Node handles,
        then delegates to _find_proof_node for the actual path search.
        """
        nodeA = self._term_to_node[A]
        nodeB = self._term_to_node[B]
        return self._find_proof_node(nodeA, nodeB)
```

**Note:** `_term_to_node` is a `dict[Term, Node]` (populated by `_add_node`).
Both `TrueTerm()` and `FalseTerm()` are added during `__init__` (lines
232--235), so their nodes always exist. `_find_proof_node` was added in Step 3.

---

## Step 5 -- Generate proofs for congruence closure

**File:** `src/tinygrind/egraph.py`, in `_rebuild()`, around lines 661--668

**Current code:**

```python
                else:
                    # we found a congruence, union the congruent nodes
                    changed = (
                        self._union_nodes_without_rebuild(left=previous, right=node)
                        or changed
                    )
                    # PG: generate proof, get function/predicate symbol + all arguments,
                    # von nodes(zeigen auf symbol und arguments)
```

**Replace the `else` block (lines 661--668) with:**

```python
                else:
                    # We found a congruence -- generate a proof and union.
                    congr_proof = self._build_congruence_proof(previous, node)
                    changed = (
                        self._union_nodes_without_rebuild(
                            left=previous, right=node, proof=congr_proof
                        )
                        or changed
                    )
```

**Add the `_build_congruence_proof` method.** Place it inside the `EGraph`
class, after `_get_node_name` (or anywhere logical):

```python
    def _build_congruence_proof(self, prev_node: Node, node: Node) -> syntax.Term:
        """Build a Lean proof that prev_node = node when they share the
        same function/predicate symbol and their arguments are congruent.

        For a single-argument function f with arguments a and b:
            Returns:  congrArg f (proof_that_a_equals_b)

        For arity > 1 we currently fall back to a grind stub
        (see TUTORIAL.md for future work).
        """
        prev_term = self._node_terms[self._node_index(prev_node)]
        node_term = self._node_terms[self._node_index(node)]

        # Determine the function/predicate symbol node and argument lists
        if isinstance(prev_term, _FunctionApplicationNode):
            func_node = prev_term.function
            prev_args = prev_term.arguments
            node_args = node_term.arguments
            arity = len(prev_args)
        elif isinstance(prev_term, _PredicateApplicationNode):
            func_node = prev_term.predicate
            prev_args = prev_term.arguments
            node_args = node_term.arguments
            arity = len(prev_args)
        else:
            # _EqualsNode congruence -- not yet implemented.
            # Fall back to a stub.
            return syntax.ElabTactic("grind")

        func_name = self._get_node_name(func_node)

        if arity == 0:
            # # A nullary application -- trivially congruent.
            # # Use rfl / Eq.refl.
            return syntax.App(
                syntax.App(syntax.Var("congrArg"), syntax.Var(func_name)),
                syntax.App(syntax.Var("rfl"), syntax.Var(func_name)),
            )

        if arity == 1:
            # Single-argument: congrArg f (proof arg_prev = arg_node)
            arg_proof = self._find_proof_node(prev_args[0], node_args[0])
            return syntax.App(
                syntax.App(syntax.Var("congrArg"), syntax.Var(func_name)),
                arg_proof,
            )

        # arity > 1: not yet implemented (curried composition needed).
        # Fall back to a grind stub for now.
        return syntax.ElabTactic("grind")
```

**How this works:**
1.  Both `prev_node` and `node` have the same function/predicate symbol and
    their arguments are in the same equivalence classes (that's why
    `_congruence_key` matched them).
2.  For each argument pair, we call `_find_proof_node` (from step 3) to
    get a proof that those arguments are equal.
3.  For arity 1, we build `congrArg f <arg_proof>`.
4.  The resulting proof is stored in `_nodes_to_proof` via
    `_union_nodes_without_rebuild` (step 2).

---

## Step 6 -- Stub the remaining `_reflect_equalities_once` proofs

**File:** `src/tinygrind/egraph.py`, `_reflect_equalities_once()` method

Three `# PG: generate proof` comments remain at lines 695, 715, and 724.
These handle:
- `Equals(a, a)` being recognized as `True` (line 695).
- Symmetric equality propagation (lines 715, 724).

**For this tutorial we leave them as stubs** because the critical path
(hypotheses + congruence + BFS) is sufficient for the current test suite.
You can revisit these later with `eq_true` / `Eq.refl` proofs.

For now, just update the three comments to read `# TODO(PG): generate proof`
so they're easy to find later.

---

## Step 7 -- Verify your work

### 7a. Run the unit tests

```bash
python -m pytest tests/test_egraph3.py -v
```

All existing tests should still pass (they test `findBottom().found`, not the
proof term itself).

### 7b. Run on example problems

```bash
python main.py
```

### 7c. Inspect the output

Look at `problems/__output.lean`.  Where you previously saw:

```lean
false_of_true_eq_false (by grind)
```

You should now see something like:

```lean
false_of_true_eq_false
  (Eq.trans (Eq.symm h1) (congrArg P (Eq.symm h)))
```

(The exact form depends on the problem.  Example01 has hypotheses `h : x = y`
and `h1 : P x` with `P` being a single-argument predicate, so the proof
chain should involve `congrArg P (Eq.symm h)` composed with `h1`.)

### 7d. Quick sanity check

For `phase00_example01` (the simplest case), run this in Python to see what
the proof term looks like:

```bash
python -c "
import sys; sys.path.insert(0, 'src')
from scaffolding.parser import parse_declarations
from tinygrind.entry import tinygrind
from scaffolding.syntax import Definition
from scaffolding.printer import print_term

content = '''def phase00_example01 :
    (A : Type) ->
    (P : A -> Prop) ->
    (x : A) ->
    (y : A) ->
    @Eq A x y ->
    P x ->
    P y :=
  by grind'''

decls = parse_declarations(content)
if isinstance(decls[0], Definition):
    proof = tinygrind(decls[0])
    print(print_term(proof))
"
```

You should see a lambda-wrapped proof term containing `Classical.byContradiction`,
`false_of_true_eq_false`, and a chain of `Eq.trans`/`Eq.symm`/`congrArg`
calls -- **not** `(by grind)`.

---

## What you've accomplished

After completing these steps, `tiny-grind` can:

1.  **Store** the name of each user-provided hypothesis/gpal as a Lean variable
    reference in the proof graph.
2.  **Store** generated equality proofs (congruence, symmetry) as edges in the
    proof graph.
3.  **Traverse** the proof graph via BFS to find a path between any two nodes
    that are in the same equivalence class.
4.  **Compose** those edge proofs into a single chain using `Eq.trans` and
    `Eq.symm`.
5.  **Emit** a standalone `Classical.byContradiction` proof that no longer
    depends on the real `grind` tactic.

---

## Future work (beyond this tutorial)

- **Multi-argument function congruence** (arity > 1): requires curried
  `congrArg` composition (e.g. `Eq.trans (congrArg (· b) (congrArg f hA))
  (congrArg (f c) hB)`).

- **Equality reflection proofs** (`_reflect_equalities_once`): generate
  `eq_true (Eq.refl a)` for `Equals(a,a)`, and proper symmetry/transitivity
  for the key-based propagation.

- **`Eq.ndrec` / `HEq.refl` proofs**: match the kernel-level style shown in
  `GRIND.md` for maximum compatibility with Lean's kernel.

- **Predicate congruence**: currently handled identically to function
  congruence (both use `congrArg`). This works in Lean since `congrArg` is
  polymorphic over the return type, but you may want to use `iff_of_eq` or
  `propext` for Prop-valued congruence in advanced cases.

- **Path compression in proof reconstruction**: after `find_proof` finds a
  path, cache the composed proof as a direct edge to speed up future queries.
