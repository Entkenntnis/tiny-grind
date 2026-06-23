```markdown
# Proof Generation in tiny-grind — A Step‑by‑Step Tutorial

This tutorial walks you through adding explicit proof‑term generation to
`egraph.py`.  By the end, the e‑graph will no longer delegate to `by grind` but
instead produce a real Lean kernel proof using `Classical.byContradiction`,
`Eq.trans`, `Eq.symm`, `congrArg`, `eq_true`, `eq_false` and friends — similar
to the low‑level proofs shown in `GRIND.md` but with a simpler congruence
construction.

> **Key constraint:** We omit *heterogeneous equality* (`HEq` / `eq_of_heq`).
> This makes the congruence proofs simpler: instead of `@eq_of_heq … (Eq.ndrec … HEq.refl …)`,
> we use `congrArg` directly on the equality type.

---

## Table of Contents

1. [Big Picture](#1-big-picture)
2. [Deconstructing the Target Proof Shape](#2-deconstructing-the-target-proof-shape)
3. [The Scaffolding Syntax — Building Lean Terms in Python](#3-the-scaffolding-syntax--building-lean-terms-in-python)
4. [Catalog of Lemma `Var`s You Will Need](#4-catalog-of-lemma-vars-you-will-need)
5. [Where Nodes Get Merged — All 6 Merge Sites](#5-where-nodes-get-merged--all-6-merge-sites)
6. [Phase 1 — Tracking Proof Edges](#6-phase-1--tracking-proof-edges)
7. [Phase 2 — Equality Proof Extraction (`_get_eq_proof`)](#7-phase-2--equality-proof-extraction-_get_eq_proof)
8. [Phase 3 — Congruence Proof Construction (using `congrArg`)](#8-phase-3--congruence-proof-construction-using-congrarg)
9. [Phase 4 — The `generate_proof` Method](#9-phase-4--the-generate_proof-method)
10. [Phase 5 — Wiring into `entry.py`](#10-phase-5--wiring-into-entrypy)
11. [Complete Walkthrough — Example 1 (`basic_subst`)](#11-complete-walkthrough--example-1-basic_subst)
12. [Edge Cases and Debugging](#12-edge-cases-and-debugging)

---

## 1. Big Picture

Currently, when the e‑graph finds a contradiction (`True` and `False`
unioned into the same e‑class), `entry.py` line 91 just returns
`ElabTactic("grind")`, effectively begging Lean’s own `grind` tactic
to finish the job.

**Your task** is to replace that with a real proof `Term` built from
`Lam`, `App`, `Var`, etc.  The proof follows a fixed outer skeleton:

```
fun ctx_args … =>
  @Classical.byContradiction GOAL (fun (h_contra : Not GOAL) =>
    @id False
      (@Eq.mp True False
        ⟨proof that True = False⟩
        True.intro))
```

The inner part — **why** `True = False` — is the interesting piece.
It captures the e‑graph’s reasoning as a chain of equalities:

```
True = ⟨known-true-proposition⟩ = GOAL = False
```

The first link (`True = …`) comes from an asserted hypothesis via
`eq_true`.  The second link (`⟨true-prop⟩ = GOAL`) is built from the
e‑graph’s congruence‑closure and transitivity.  The third link
(`GOAL = False`) uses `eq_false` and the contradiction hypothesis
(`h_contra`).

**Data‑flow summary**: during e‑graph construction you *record* every
merge together with its *reason* (a proof term that the two nodes are
equal).  When the graph finds `bottom`, you *extract* a path through
those records, compose the proofs, and wrap them in the skeleton
above.

---

## 2. Deconstructing the Target Proof Shape

Look at `GRIND.md` Example 1 (lines 15–29).  The Lean input is:

```
def basic_subst : (A : Type) → (P : A → Prop) → (x : A) → (y : A) →
                  @Eq A x y → P x → P y := by grind
```

The low‑level kernel proof (using `congrArg` instead of `Eq.ndrec`) is:

```lean
fun (A : Type) (P : A → Prop) (x y : A) (h : x = y) (h_1 : P x) =>
  @Classical.byContradiction (P y) (fun (h_2 : ¬ (P y)) =>
    @id False
      (@Eq.mp True False
        (@Eq.trans Prop True (P y) False
          (@Eq.trans Prop True (P x) (P y)
            (@Eq.symm Prop (P x) True
              (@eq_true (P x) h_1))
            --     ^^^^^^^^^^^^  P x = True from hypothesis h_1
            (                   -- proof that (P x) = (P y) via congruence
              @congrArg A Prop (fun (z : A) => P z) h
            ))
            --   ^^^^^^^^^^^^^^^  P x = P y using congrArg (fun z => P z) h
          (@eq_false (P y) h_2))
          -- ^^^^^^^^^^^^^^^^^^   P y = False from contradiction hyp
        True.intro))
```

Let us annotate every sub‑expression with its *role*:

| Sub‑term | Role |
|---|---|
| `Classical.byContradiction (P y)` | Assume the goal false, derive `False` |
| `h_2 : ¬ (P y)` | The contradiction hypothesis (goal is false) |
| `Eq.mp True False … True.intro` | From `True = False` and `True.intro` deduce `False` |
| `Eq.trans Prop True (P y) False … …` | Chain: `True = P y` and `P y = False` |
| `Eq.trans Prop True (P x) (P y) … …` | Chain: `True = P x` and `P x = P y` |
| `Eq.symm … (eq_true (P x) h_1)` | `P x = True` → `True = P x` |
| `@congrArg A Prop (fun (z : A) => P z) h` | Congruence: from `h : x = y` get `P x = P y` |
| `eq_false (P y) h_2` | `¬ P y` → `P y = False` |

**Why `congrArg` works (no `Eq.ndrec`)**:

`congrArg : {A B : Sort u} {a b : A} (f : A → B) → (a = b) → f a = f b`

Given `h : a = b`, we want to prove `f a = f b`.  Just apply `congrArg f h`.
For multi‑argument functions, we repeat the process, substituting one argument
at a time.  The construction is much simpler than building `Eq.ndrec` motives.

---

## 3. The Scaffolding Syntax — Building Lean Terms in Python

The `scaffolding/syntax.py` file (95 lines) defines the AST you will use.
Here is a quick reference:

```python
from scaffolding.syntax import Var, App, Lam, Pi, Sort, Ann, Let, Term

# Atoms
Var("x")                           # x
Sort(0)                            # Prop
Sort(1)                            # Type

# Application — LEFT‑associative:
# f a b c  =  ((f a) b) c
#                    ↓
App(App(App(Var("f"), Var("a")), Var("b")), Var("c"))

# Lambda:
Lam("x", Var("A"), Var("x"))       # fun (x : A) => x

# Pi (∀ / →):
Pi("x", Var("A"), Var("B"))        # (x : A) → B
Pi(None, Var("A"), Var("B"))       # A → B

# Annotation:
Ann(Var("x"), Var("A"))            # (x : A)
```

**Gotcha:** every `@`‑prefixed Lean constant (e.g. `@Eq`, `@congrArg`)
is just a `Var` whose name starts with `@`.  The printer outputs it
verbatim.

**Helper you will want** — a utility to build n‑ary applications:

```python
def mk_app(head: Term, *args: Term) -> Term:
    """mk_app(Var("@Eq"), A, a, b) → @Eq A a b"""
    result = head
    for arg in args:
        result = App(result, arg)
    return result
```

Put this helper in `egraph.py` (or import it from a util module).

---

## 4. Catalog of Lemma `Var`s You Will Need

These are the Lean primitives used in the generated proofs.  Each is a
`Var`:

| `Var` name | Lean signature (pseudo) | Purpose |
|---|---|---|
| `@Classical.byContradiction` | `∀ {p}, (¬ p → False) → p` | Outer wrapper |
| `@Eq.mp` | `∀ {A B}, (A = B) → A → B` | Rewrite `True` to `False` |
| `@Eq.trans` | `∀ {A} {a b c}, a = b → b = c → a = c` | Chain equalities |
| `@Eq.symm` | `∀ {A} {a b}, a = b → b = a` | Flip an equality |
| `@Eq.refl` | `∀ {A} {a}, a = a` | Reflexivity |
| `@congrArg` | `∀ {A B} {a b} (f : A → B), a = b → f a = f b` | Congruence for function application |
| `@eq_true` | `∀ p, p → (p = True)` | Proposition → equality with True |
| `@eq_false` | `∀ p, ¬ p → (p = False)` | Negation → equality with False |
| `True.intro` | `True` | The trivial proof of `True` |
| `@id` | `∀ {A}, A → A` | Identity (used to embed `False`) |
| `Not` | `Prop → Prop` | `Not p` is `p → False` |

**Note on `@eq_false`**: the second argument is `¬ p`, so if `h_contra`
is your contradiction hypothesis (type `Not goal`), then
`mk_app(Var("@eq_false"), goal_term, h_contra_term)` yields
`goal = False`.

**Note on `@eq_true`**: the second argument is a proof of `p`.  So if
`h_1 : P x`, then `mk_app(Var("@eq_true"), px_term, h_1_term)` yields
`P x = True`.

---

## 5. Where Nodes Get Merged — All 6 Merge Sites

Every time two nodes end up in the same e‑class, you must record a
**proof edge** (a proof that those two nodes are equal).  Here are all
the call sites in `egraph.py` where `_union_nodes` or
`_union_nodes_without_rebuild` is called:

### 5a. `addGoal` — line 242

```python
_ = self._union_nodes(prop_node, self._false_node)
```

**What**: The goal proposition is assumed false (for contradiction).
**Proof edge**: You will NOT record a direct edge here.  Instead you
will store the *goal node* in a new attribute
`self._goal_node: Node | None`.  The later `generate_proof` method
will need it to apply `eq_false` with the contradiction hypothesis.

### 5b. `addTerm` (FalseTerm branch) — line 233

```python
_ = self._union_nodes(self._false_node, self._true_node)
```

**What**: The user explicitly gave `False` as a hypothesis → immediate
contradiction.
**Proof edge**: record that `_true_node = _false_node`.
**Reason**: `"immediate_contradiction"` — no hypothesis variable;
the proof is the identity (the two nodes are literally the same
truth value).  In practice, if this fires, you can skip the
`byContradiction` wrapping and just return `False.elim` or similar.

### 5c. `_add_true_equality_term` — lines 446–447

```python
_ = self._union_nodes(equality_node_term.left, equality_node_term.right)
_ = self._union_nodes(equality_node, self._true_node)
```

**What**: An `Equals(left, right)` hypothesis is asserted true.
**First union** (line 446): merge `left` with `right`.
  - Proof: the hypothesis variable for this equality.
  - This is a **value‑level** equality (type `A`, not `Prop`).

**Second union** (line 447): merge the equality proposition node with `_true_node`.
  - Proof: `eq_true (left = right) h_name` where `h_name` is
    the hypothesis variable.

### 5d. `addPredicateApplication` — line 273

```python
_ = self._union_nodes(prop_node, self._true_node)
```

**What**: A `PredicateApplication(P, args)` hypothesis is asserted true.
**Proof**: `eq_true (P args) h_name`.

### 5e. Congruence closure in `_rebuild` — line 613

```python
changed = self._union_nodes_without_rebuild(
    left=previous, right=node
) or changed
```

**What**: Two `_FunctionApplicationNode` or `_PredicateApplicationNode`
or `_EqualsNode` nodes are congruent (same function/predicate e‑class
and all arguments in equal e‑classes) → union them.

**Proof**: Construct a **congruence proof** (see §8) proving
`previous = node` using the equalities of their sub‑components.

### 5f. Equality reflection in `_reflect_equalities_once`

- Line 637: `_union_nodes_without_rebuild(node, self._true_node)`
  when `Equals(a,b)` has `class(a) == class(b)` (reflexivity).
  **Proof**: `a = a` via `Eq.refl` → the equality proposition is true.

- Lines 652–654: propagate true to equalities sharing the same
  canonical key.
  **Proof**: `Eq.trans` of the existing proof with the key equality.

- Lines 658–661: propagate false to equalities.
  **Proof**: similar.

**For a first implementation you can ignore 5f.**  The basic congruence
closure and direct hypotheses are sufficient to prove all the examples.

---

## 6. Phase 1 — Tracking Proof Edges

### 6.1 Data structure

Add to `EGraph.__init__`:

```python
# Adjacency list: node_id → [(neighbor_id, proof_term)]
# Proof_term is a scaffolding Term proving node_id = neighbor_id.
self._eq_proofs: dict[int, list[tuple[int, Term]]] = {}

# The node that was added via addGoal (for later eq_false wrapping).
self._goal_node: Node | None = None

# Mapping from node → the hypothesis variable name that asserts it true
# (for eq_true wrapping).  Only set for nodes added via addEquation
# or addPredicateApplication.
self._true_witness: dict[int, str] = {}
```

### 6.2 The `_record_eq` helper

Add a private method:

```python
def _record_eq(self, a: Node, b: Node, proof: Term) -> None:
    """Record that a = b with the given proof.  Also record b = a via symmetry."""
    a_id = self._node_index(a)
    b_id = self._node_index(b)
    if a_id == b_id:
        return
    self._eq_proofs.setdefault(a_id, []).append((b_id, proof))
    # Record the symmetric edge too (for simpler BFS).
    sym_proof = mk_app(Var("@Eq.symm"), proof)
    self._eq_proofs.setdefault(b_id, []).append((a_id, sym_proof))
```

### 6.3 Modifying `_union_nodes_without_rebuild`

The current signature (line 540):

```python
def _union_nodes_without_rebuild(self, left: Node, right: Node) -> bool:
```

Add an optional parameter:

```python
def _union_nodes_without_rebuild(
    self,
    left: Node,
    right: Node,
    proof_edge: Term | None = None,     # <-- NEW
) -> bool:
```

And inside, after the merge succeeds (after line 560), record the edge:

```python
if proof_edge is not None:
    self._record_eq(left, right, proof_edge)
```

**Important**: The method works with *representatives* internally, but
you record the proof for the **original** nodes `left` and `right`,
because those are the ones the caller knows about.

### 6.4 Recording at each merge site

#### In `addGoal` (line 242)

```python
def addGoal(self, prop: PropTerm) -> Node:
    ...
    prop_node = self._add_prop_term(prop)
    self._goal_node = prop_node          # <-- NEW: remember the goal node
    _ = self._union_nodes(prop_node, self._false_node)
    return prop_node
```

No `_record_eq` call here — the connection to `_false_node` is handled
during `generate_proof` via `eq_false`.

#### In `addTerm` — `FalseTerm` branch (line 232–234)

```python
if isinstance(term, FalseTerm):
    _ = self._union_nodes(self._false_node, self._true_node)
    self._record_eq(self._false_node, self._true_node,
        mk_app(Var("@eq_false"), ...))  # optional, for completeness
    return self._false_node
```

#### In `addHypothesis` (new method, see §10)

We will introduce a dedicated method `addHypothesis` that records
edges for both equality and predicate‑application hypotheses.

---

## 7. Phase 2 — Equality Proof Extraction (`_get_eq_proof`)

Given two nodes `a` and `b` that you KNOW are in the same e‑class,
return a `Term` proving `a = b`.  This is the heart of proof
reconstruction.

### 7.1 Strategy: BFS through `_eq_proofs`

The `_eq_proofs` adjacency list connects nodes via recorded proof
edges.  Since you record symmetric edges too (via `_record_eq`), the
graph is undirected.  Run BFS from `a` to find a path to `b`, collecting
the proof terms along the way.

### 7.2 Implementation sketch

```python
from collections import deque

def _get_eq_proof(self, a: Node, b: Node) -> Term:
    """Return a proof that a = b.  Raises if no path found."""
    a_id = self._node_index(a)
    b_id = self._node_index(b)

    if self._find_index(a_id) != self._find_index(b_id):
        raise RuntimeError(f"Nodes {a_id} and {b_id} are not in the same e-class")
    if a_id == b_id:
        # Reflexivity
        return mk_app(
            Var("@Eq.refl"),
            self._type_name_var,   # type variable, e.g. Var("A")
            self._node_to_lean_term(a),
        )

    # BFS
    queue = deque([a_id])
    parent: dict[int, tuple[int, Term]] = {a_id: (-1, Var("dummy"))}

    while queue:
        cur = queue.popleft()
        if cur == b_id:
            break
        for neighbor_id, proof in self._eq_proofs.get(cur, []):
            if neighbor_id not in parent:
                parent[neighbor_id] = (cur, proof)
                queue.append(neighbor_id)

    if b_id not in parent:
        raise RuntimeError(f"No proof path from {a_id} to {b_id}")

    # Reconstruct path
    path: list[Term] = []
    cur = b_id
    while cur != a_id:
        prev, proof = parent[cur]
        path.append(proof)   # proof is: prev = cur
        cur = prev
    path.reverse()

    # Compose: (a = node1) → (node1 = node2) → ... → (node_n-1 = b)
    # via repeated Eq.trans
    result = path[0]   # a = next
    for proof in path[1:]:
        result = mk_app(Var("@Eq.trans"), result, proof)
    return result
```

### 7.3 Node‑to‑Lean‑term conversion

You need a way to convert an e‑graph node back into a scaffolding
`Term`.  Add a method `_node_to_lean_term`:

```python
def _node_to_lean_term(self, node: Node) -> Term:
    node_term = self._node_terms[self._node_index(node)]
    if isinstance(node_term, _ConstantNode):
        return Var(node_term.name)
    elif isinstance(node_term, _FunctionSymbolNode):
        return Var(node_term.name)
    elif isinstance(node_term, _PredicateSymbolNode):
        return Var(node_term.name)
    elif isinstance(node_term, _FunctionApplicationNode):
        fn = self._node_to_lean_term(node_term.function)
        args = [self._node_to_lean_term(a) for a in node_term.arguments]
        return mk_app(fn, *args)
    elif isinstance(node_term, _PredicateApplicationNode):
        pred = self._node_to_lean_term(node_term.predicate)
        args = [self._node_to_lean_term(a) for a in node_term.arguments]
        return mk_app(pred, *args)
    elif isinstance(node_term, _EqualsNode):
        left = self._node_to_lean_term(node_term.left)
        right = self._node_to_lean_term(node_term.right)
        return mk_app(Var("@Eq"), self._type_name_var, left, right)
    elif isinstance(node_term, _TrueNode):
        return Var("True")
    elif isinstance(node_term, _FalseNode):
        return Var("False")
    raise TypeError(f"Unknown node term: {node_term!r}")
```

The type variable `self._type_name_var` is set from `entry.py` (see §10).

### 7.4 Node types and `_type_name_var`

The e‑graph currently does not store types, but the proofs need a type
argument for `@Eq.refl`, `@congrArg`, and `@Eq`.  A simple fix: add a field
`self._type_name_var: Term = Var("A")` and set it from `entry.py` when the
single type variable is encountered (see §10).  This is sufficient for the
current single‑type setup.

---

## 8. Phase 3 — Congruence Proof Construction (using `congrArg`)

### 8.1 When is this needed?

During congruence closure in `_rebuild` (line 613), two function‑ or
predicate‑application nodes `prev` and `curr` are found to share the
same congruence key.  You need to construct a proof that `prev = curr`
using the equality proofs of their arguments.

### 8.2 The `_build_congruence_proof` method

Instead of building `Eq.ndrec` motives, we use `congrArg` step by step.

```python
def _build_congruence_proof(self, a: Node, b: Node) -> Term:
    """Construct proof that function/predicate app a equals app b.

    Precondition: a and b share the same congruence key, meaning
    they have the same function/predicate symbol e-class and all
    corresponding arguments are pairwise in the same e-class.
    """
    a_term = self._node_terms[self._node_index(a)]
    b_term = self._node_terms[self._node_index(b)]

    # Both must be FunctionApplicationNode or PredicateApplicationNode
    if not (isinstance(a_term, _FunctionApplicationNode)
            or isinstance(a_term, _PredicateApplicationNode)):
        raise TypeError(f"Not an application node: {a_term!r}")

    a_args: tuple[Node, ...] = a_term.arguments
    b_args: tuple[Node, ...] = b_term.arguments

    if a_args == b_args:
        # Identical arguments – trivially refl (should not happen)
        lhs = self._node_to_lean_term(a)
        return mk_app(Var("@Eq.refl"), self._type_name_var, lhs)

    # Start with proof: f(a0, a1, ...) = f(a0, a1, ...)
    lhs = self._node_to_lean_term(a)
    proof = mk_app(Var("@Eq.refl"), self._type_name_var, lhs)

    n = len(a_args)
    assert n == len(b_args)

    fn = self._node_to_lean_term(a_term.function)

    for i in range(n):
        # At this point, proof is:
        #   f(b0, ..., b_{i-1}, a_i, a_{i+1}, ...) = f(b0, ..., b_{i-1}, a_i, a_{i+1}, ...)
        # We want to replace the second a_i with b_i.

        # Build the function: fun (z : T) => f(b0, ..., b_{i-1}, z, a_{i+1}, ...)
        prev_args = [self._node_to_lean_term(b_args[j]) for j in range(i)]
        next_args = [self._node_to_lean_term(a_args[j]) for j in range(i+1, n)]
        body = mk_app(fn, *(prev_args + [Var("z")] + next_args))
        f_lam = Lam("z", self._type_name_var, body)   # type of the argument is the single type

        # Get proof that a_i = b_i
        eq_arg = self._get_eq_proof(a_args[i], b_args[i])

        # congrArg f_lam eq_arg : f(... a_i ...) = f(... b_i ...)
        step = mk_app(Var("@congrArg"), f_lam, eq_arg)

        # Compose: proof (lhs = f(... a_i ...)) ; step (f(... a_i ...) = f(... b_i ...))
        proof = mk_app(Var("@Eq.trans"), proof, step)

    return proof
```

**Worked example (unary function)**:

- `a` = `f(x)`, `b` = `f(y)`, `a_args = (x_node,)`, `b_args = (y_node,)`
- `lhs` = `f x`, initial `proof = refl (f x)`
- Loop i=0:
  - `prev_args = []`, `next_args = []`, `body = f z`
  - `f_lam = fun (z : A) => f z`
  - `eq_arg = h : x = y`
  - `step = congrArg (fun z => f z) h` → `f x = f y`
  - `proof = trans (refl (f x)) step` → `f x = f y`

This is much simpler than building `Eq.ndrec` motives.

---

## 9. Phase 4 — The `generate_proof` Method

### 9.1 Signature

```python
def generate_proof(
    self,
    context: list[tuple[str | None, Term]],  # Pi bindings from entry.py
) -> Term:
    goal_node = self._goal_node
    assert goal_node is not None
    goal_lean_term = self._node_to_lean_term(goal_node)
    ...
```

### 9.2 Algorithm

```python
def generate_proof(self, context) -> Term:
    goal_node = self._goal_node
    assert goal_node is not None
    goal_term = self._node_to_lean_term(goal_node)

    # 1. Find a true witness: a proposition node in _true_node's e‑class
    #    with a stored _true_witness name.
    true_witness_node: Node | None = None
    true_witness_name: str | None = None
    for nid, name in self._true_witness.items():
        node = self._nodes[nid]
        if self.sameClass(node, self._true_node):
            true_witness_node = node
            true_witness_name = name
            break

    if true_witness_node is None:
        # Fallback: maybe the goal itself is trivially true (reflexivity)
        # For now, return a dummy to keep going; real code handles this
        return Var("dummy")

    # 2. Get the proof that true_witness = goal
    eq_proof = self._get_eq_proof(true_witness_node, goal_node)

    # 3. Build the chain: True = true_witness = goal = False
    witness_term = self._node_to_lean_term(true_witness_node)

    # true_witness = True  (via eq_true)
    eq_true_proof = mk_app(Var("@eq_true"), witness_term,
                           Var(true_witness_name))
    # True = true_witness  (symmetry)
    true_eq_witness = mk_app(Var("@Eq.symm"), eq_true_proof)

    # goal = False  (via eq_false with contradiction hypothesis)
    # The contradiction hypothesis is bound inside the byContradiction lambda;
    # we use Var("h_contra") as a placeholder.
    eq_false_proof = mk_app(Var("@eq_false"), goal_term,
                            Var("h_contra"))

    # Chain: True = goal
    true_eq_goal = mk_app(Var("@Eq.trans"), true_eq_witness, eq_proof)
    # Chain: True = False
    true_eq_false = mk_app(Var("@Eq.trans"), true_eq_goal, eq_false_proof)

    # 4. Inner block: @Eq.mp True False true_eq_false True.intro
    false_proof = mk_app(
        mk_app(Var("@Eq.mp"), Var("True"), Var("False"),
               true_eq_false),
        Var("True.intro"),
    )

    # @id False false_proof
    inner = mk_app(Var("@id"), Var("False"), false_proof)

    # 5. Wrap in Classical.byContradiction
    not_goal = mk_app(Var("Not"), goal_term)
    contra_lam = Lam("h_contra", not_goal, inner)

    body = mk_app(
        Var("@Classical.byContradiction"),
        goal_term,
        contra_lam,
    )

    # 6. Wrap in outer Lambdas for the context
    result = body
    for var_name, var_type in reversed(context):
        if var_name is not None:
            result = Lam(var_name, var_type, result)

    return result
```

---

## 10. Phase 5 — Wiring into `entry.py`

### 10.1 Changes to `entry.py`

In `tinygrind()` (entry.py lines 26–94):

1. **Capture the type name** (line 49):
   ```python
   if isinstance(type, Sort) and type.level == 1 and name:
       ...
       egraph.set_type_name(name)    # NEW: sets self._type_name_var = Var(name)
   ```

2. **Change hypothesis handling** (lines 66–73):
   Replace `egraph.addTerm(eg_term)` with `egraph.addHypothesis(eg_term, name)`
   when the term is a hypothesis.

   Define `addHypothesis` in `egraph.py`:
   ```python
   def addHypothesis(self, term: Term, hyp_name: str) -> Node:
       if isinstance(term, Equals):
           return self._add_true_equality_term_with_name(term, hyp_name)
       elif isinstance(term, PredicateApplication):
           return self._add_predicate_application_term_with_name(term, hyp_name)
       elif isinstance(term, TrueTerm):
           return self._true_node
       elif isinstance(term, FalseTerm):
           _ = self._union_nodes(self._false_node, self._true_node)
           return self._false_node
       raise TypeError(f"Not a hypothesis: {term!r}")
   ```

   The `_add_true_equality_term_with_name` method records edges and stores the
   witness name (as shown in §11).

3. **Generate proof instead of `by grind`** (lines 89–91):
   ```python
   if egraph.isBottom():
       print(f"   = egraph found solution, generating proof")
       return egraph.generate_proof(context)
   ```

### 10.2 The `set_type_name` method

```python
def set_type_name(self, name: str) -> None:
    self._type_name_var = Var(name)
```

---

## 11. Complete Walkthrough — Example 1 (`basic_subst`)

To make everything concrete, let's trace through Example 1
(`GRIND.md` lines 5–9) step by step.

### Input

```
def phase00_example01 :
    (A : Type) → (P : A → Prop) → (x : A) → (y : A) →
    @Eq A x y → P x → P y := by grind
```

### Context extracted by `entry.py`

```python
context = [
    ("A", Sort(1)),                  # Type
    ("P", Pi("a", Var("A"), Sort(0))),  # A → Prop
    ("x", Var("A")),                 # A
    ("y", Var("A")),                 # A
    ("h", App(App(App(Var("@Eq"), Var("A")), Var("x")), Var("y"))),  # @Eq A x y
    ("h_1", App(Var("P"), Var("x"))),  # P x
]
goal = App(Var("P"), Var("y"))       # P y
```

### E‑graph construction

**Step 1:** `A` is recognized as a type (`Sort(1)`).  `egraph.set_type_name("A")` sets `self._type_name_var = Var("A")`.

**Step 2:** `P` is recognized as a predicate (arity 1).  `egraph.addTerm(PredicateSymbol("P", 1))` creates node N_P.

**Step 3:** `x`, `y` are constants.  `egraph.addTerm(Constant("x"))` creates N_x.  Same for N_y.

**Step 4:** `h: @Eq A x y` is a hypothesis (App type).  This translates to egraph `Equals(Constant("x"), Constant("y"))`.
    - `addHypothesis(Equals(Constant("x"), Constant("y")), "h")` is called.
    - Creates:
        - N_x (already exists → reused)
        - N_y (already exists → reused)
        - N_eq = `_EqualsNode(N_x, N_y)`
    - Unions:
        - **Merge 1**: `N_x` with `N_y` — records proof edge: `N_x = N_y` via `Var("h")`.
        - **Merge 2**: `N_eq` with `N_true` — records proof edge: `N_eq = True` via `eq_true (x=y) h`. Stores `("h", N_eq)` in `_true_witness`.

**Step 5:** `h_1: P x` is a hypothesis.  Translates to egraph `PredicateApplication(PredicateSymbol("P", 1), (Constant("x"),))`.
    - `addHypothesis(PredicateApplication(P, (Constant("x"),)), "h_1")`
    - Creates N_Px.
    - Unions N_Px with N_true — records proof edge: `N_Px = True` via `eq_true (P x) h_1`.  Stores `("h_1", N_Px)` in `_true_witness`.

**Step 6:** Goal `P y` → `addGoal(PredicateApplication(P, (Constant("y"),)))`.
    - Creates N_Py.
    - Stores `_goal_node = N_Py`.
    - Unions N_Py with N_false (no edge recorded — handled later).

**Step 7:** `_rebuild` runs congruence closure.
    - N_Px and N_Py both have predicate class = class(N_P) and argument class = class(N_x) (since N_x and N_y are now in the same class).
    - **Merge 3**: `_build_congruence_proof(N_Px, N_Py)` produces:
        - `@congrArg A Prop (fun (z : A) => P z) h`
    - Records proof edge: `N_Px = N_Py` via this `congrArg` proof.

### Proof extraction

`isBottom()` returns True (N_true and N_false are in the same class).

**`generate_proof` runs:**

1. `goal_node` = N_Py, `goal_term` = `P y`.
2. `true_witness_node` = N_Px, `true_witness_name` = "h_1".
3. `_get_eq_proof(N_Px, N_Py)` runs BFS:
    - N_Px has edge to N_Py via `congrArg … h …`.
    - Returns that proof directly.
    - `eq_proof` = `@congrArg A Prop (fun (z : A) => P z) h`
    - (Type: `P x = P y`)

4. Build the chain:
    - `eq_true_proof` = `eq_true (P x) h_1`  (type: `P x = True`)
    - `true_eq_witness` = `Eq.symm (eq_true (P x) h_1)`  (type: `True = P x`)
    - `eq_false_proof` = `eq_false (P y) h_contra`  (type: `P y = False`)
    - `true_eq_goal` = `Eq.trans (True = P x) (P x = P y)`  (type: `True = P y`)
    - `true_eq_false` = `Eq.trans (True = P y) (P y = False)`  (type: `True = False`)

5. Inner block: `@Eq.mp True False (True = False) True.intro`
6. Wrap in `@Classical.byContradiction (P y) (fun h_contra : Not (P y) => inner)`
7. Wrap in outer Lam chain for `A, P, x, y, h, h_1`.

### Result (printed)

```lean
fun (A : Type) (P : A → Prop) (x : A) (y : A) (h : @Eq A x y) (h_1 : P x) =>
  @Classical.byContradiction (P y) (fun (h_contra : Not (P y)) =>
    @id False (@Eq.mp True False
      (@Eq.trans True (P y) False
        (@Eq.trans True (P x) (P y)
          (@Eq.symm (P x) True (@eq_true (P x) h_1))
          (@congrArg A Prop (fun (z : A) => P z) h))
        (@eq_false (P y) h_contra))
      True.intro))
```

---

## 12. Edge Cases and Debugging

### 12.1 The goal IS an equality

Example 3 (`congruence_on_functions`):
```
Goal: @Eq A (f (f a)) (f (f b))
```

Here the goal itself is an `Equals` node.  The `_true_witness` may be
another equality node, and `_get_eq_proof` works at the *Prop* level.
The BFS naturally handles both value‑level and prop‑level edges.

### 12.2 Reflexivity (no hypothesis)

Example 6: `a = a`.  The e‑graph unions `Equals(a,a)` with True via
reflexivity.  No hypothesis variable asserts it.  The `_true_witness` dict
will be empty.

**Fix**: If no `_true_witness` is found, check if the goal node is
itself `Equals(a,b)` and `a` and `b` are in the same e‑class.  Then
the goal itself can act as the true witness:

```python
if true_witness_node is None:
    goal_node_term = self._node_terms[self._node_index(goal_node)]
    if isinstance(goal_node_term, _EqualsNode):
        l, r = goal_node_term.left, goal_node_term.right
        if self.sameClass(l, r):
            eq_pf = self._get_eq_proof(l, r)
            # eq_true (l = r) eq_pf → (l = r) = True
            true_witness_node = goal_node
            true_witness_name = None  # we'll use the proof directly
            eq_true_proof = mk_app(Var("@eq_true"), goal_term, eq_pf)
            true_eq_witness = mk_app(Var("@Eq.symm"), eq_true_proof)
            # Then proceed without a name…
```

Alternatively, you can generate a direct proof without `byContradiction`.

### 12.3 Predicate goal (no hypothesis)

Example: `P a` as a goal, `P a` as a hypothesis.  The goal node is
`P a`, which is already in `True`'s e‑class.  The goal IS its own true
witness.  You can handle it the same way: check `self.sameClass(goal_node, self._true_node)` and use the goal node itself.

### 12.4 Debug printing

Add a debug method to dump the proof edge graph:

```python
def debug_print_edges(self) -> None:
    from scaffolding.printer import print_term
    for src, edges in self._eq_proofs.items():
        for dst, proof in edges:
            src_term = self._node_to_lean_term(self._nodes[src])
            print(f"  {print_term(src_term)}  =  {print_term(self._node_to_lean_term(self._nodes[dst]))}")
            print(f"    via {print_term(proof)}")
```

---

## Appendix A — Summary of Methods to Add to `EGraph`

| Method | Purpose |
|---|---|
| `set_type_name(name: str)` | Store the single type variable name |
| `addHypothesis(term, hyp_name)` | Add a hypothesis, recording its variable name |
| `_record_eq(a, b, proof)` | Register a proof that `a = b` in the adjacency graph |
| `_node_to_lean_term(node) → Term` | Convert an e‑graph node to a scaffolding `Term` |
| `_get_eq_proof(a, b) → Term` | BFS‑based proof that two nodes are equal |
| `_build_congruence_proof(a, b) → Term` | `congrArg`‑based congruence proof |
| `generate_proof(context) → Term` | The top‑level proof‑term constructor |
| `debug_print_edges()` | Print the proof adjacency graph for debugging |

## Appendix B — Summary of Changes to `entry.py`

| Line(s) | Change |
|---|---|
| 49 | Add `egraph.set_type_name(name)` |
| 66–73 | Replace `egraph.addTerm(eg_term)` with `egraph.addHypothesis(eg_term, name)` |
| 89–91 | Replace `ElabTactic("grind")` with `egraph.generate_proof(context)` |
| 242 | In `addGoal`, store `self._goal_node = prop_node` |

## Appendix C — What to Test First

Recommended order for implementation and testing:

1. Add `_record_eq` and wire it into `_add_true_equality_term_with_name` and
   `addPredicateApplication` (with `hyp_name` parameters).
2. Implement `_node_to_lean_term` and `set_type_name`.
3. Implement `_get_eq_proof` (BFS).
4. Implement `_build_congruence_proof` using `congrArg` and wire it into `_rebuild`.
5. Implement `generate_proof`.
6. Wire `entry.py`.
7. Test with `example06.lean` (reflexivity — simplest).
8. Test with `example01.lean` (basic_subst — one congruence).
9. Test with `example03.lean` (double congruence).
10. Test with `example10.lean` (transitive chain only, no functions).

Run with `python main.py` — the output file `problems/__output.lean`
will contain the generated proofs.  Compile them with `lake build` in
the problems directory to verify they typecheck.
```