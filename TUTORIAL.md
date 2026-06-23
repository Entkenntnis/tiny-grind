# Proof Generation in tiny-grind — A Step-by-Step Tutorial

This tutorial walks you through adding explicit proof-term generation to
`egraph.py`.  By the end, the e‑graph will no longer delegate to `by grind` but
instead produce a real Lean kernel proof using `Classical.byContradiction`,
`Eq.trans`, `Eq.symm`, `Eq.ndrec`, `eq_true`, `eq_false` and friends —
exactly like the low-level proofs shown in `GRIND.md`.

> **Key constraint:** We omit *heterogeneous equality* (`HEq` / `eq_of_heq`).
> This makes the congruence proofs simpler: where GRIND.md uses
> `@eq_of_heq … (Eq.ndrec … HEq.refl …)`, we use plain `Eq.ndrec` directly
> on the equality type.

---

## Table of Contents

1. [Big Picture](#1-big-picture)
2. [Deconstructing the Target Proof Shape](#2-deconstructing-the-target-proof-shape)
3. [The Scaffolding Syntax — Building Lean Terms in Python](#3-the-scaffolding-syntax--building-lean-terms-in-python)
4. [Catalog of Lemma `Var`s You Will Need](#4-catalog-of-lemma-vars-you-will-need)
5. [Where Nodes Get Merged — All 6 Merge Sites](#5-where-nodes-get-merged--all-6-merge-sites)
6. [Phase 1 — Tracking Proof Edges](#6-phase-1--tracking-proof-edges)
7. [Phase 2 — Equality Proof Extraction (`_get_eq_proof`)](#7-phase-2--equality-proof-extraction-_get_eq_proof)
8. [Phase 3 — Congruence Proof Construction](#8-phase-3--congruence-proof-construction)
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
e‑graph’s congruence-closure and transitivity.  The third link
(`GOAL = False`) uses `eq_false` and the contradiction hypothesis
(`h_contra`).

**Data-flow summary**: during e‑graph construction you *record* every
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

The low-level kernel proof (with `HEq` stripped away for clarity)
would be:

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
            (             -- proof that (P x) = (P y) via congruence
              @Eq.ndrec A x
                (fun (z : A) => (P x) = (P z))
                (@Eq.refl Prop (P x))
                y
                h
            ))
            --   ^^^^^^^^^^^^^^^  P x = P y from h : x = y
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
| `Eq.ndrec A x (fun z => P x = P z) …` | Congruence: from `x = y` get `P x = P y` |
| `eq_false (P y) h_2` | `¬ P y` → `P y = False` |

**Why `Eq.ndrec` works for congruence (no `HEq`)**:

`Eq.ndrec` has the signature (in Lean kernel notation):

```
Eq.ndrec : {A : Sort u} {a : A} {motive : A → Sort v}
         → motive a → {b : A} → (a = b) → motive b
```

Given `h : a = b`, we want to prove `f a = f b`.  Set:
- `A` = the type of `a`
- `motive` = `fun (z : A) => f a = f z`
- `motive a` = `f a = f a` — trivially true via `Eq.refl (f a)`
- `h : a = b`

Then `Eq.ndrec A a (fun z => f a = f z) (Eq.refl (f a)) b h` has type
`motive b` = `f a = f b`.  Done.

For a multi‑argument function, substitute one argument at a time,
chaining `Eq.ndrec` calls (or equivalently `h₁ ▸ h₂ ▸ … ▸ rfl`).

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

**Gotcha:** every `@`‑prefixed Lean constant (e.g. `@Eq`, `@Eq.ndrec`)
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
| `@Eq.ndrec` | `∀ {A a} (motive : A → Sort v), motive a → ∀ {b}, a = b → motive b` | Substitution / congruence |
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

Add two optional parameters:

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

**Important**: `_union_nodes_without_rebuild` currently works with
*representatives* (`left_root`, `right_root`), not the original nodes.
But you should record the proof for the **original** nodes `left` and
`right`, because those are the ones the caller knows about.

Actually, the safest approach: record the proof edge BEFORE calling `_union_nodes_without_rebuild`, in the *caller*.  That way you have the
original `Node` objects and the original proof term.  The
`_union_nodes_without_rebuild` method stays unchanged; you just call
`_record_eq` in each caller, right before the union call.

**Revised plan**: Do NOT modify `_union_nodes_without_rebuild`.
Instead, add `_record_eq` calls at each merge site in the public and
private API methods.

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

#### In `addEquation` (delegates to `_add_true_equality_term`, lines 433–448)

```python
def _add_true_equality_term(self, term: Equals, hyp_name: str | None = None) -> Node:
    ...
    equality_node = self._add_equals_term(term)
    equality_node_term = ...
    left = equality_node_term.left
    right = equality_node_term.right

    # Proof edge: left = right (value-level equality)
    if hyp_name is not None:
        eq_proof: Term = Var(hyp_name)      # the hypothesis variable
        self._record_eq(left, right, eq_proof)

    _ = self._union_nodes(left, right)

    # Proof edge: (left = right) = True (prop-level equality)
    if hyp_name is not None:
        eq_prop_proof: Term = mk_app(
            Var("@eq_true"),
            ⟨equality_prop_term⟩,    # need the Term for `Equals(left, right)`
            Var(hyp_name)
        )
        self._record_eq(equality_node, self._true_node, eq_prop_proof)

    _ = self._union_nodes(equality_node, self._true_node)
    return equality_node
```

But `addEquation` currently does not receive a hypothesis name — it's
called from `entry.py` via `addTerm`, which also lacks this info.

**Solution**: This is where you need to thread the hypothesis variable
name from `entry.py` through to the e‑graph.  See §10.

#### In `addPredicateApplication` (lines 260–274)

Similarly, this method needs the hypothesis variable name:

```python
def addPredicateApplication(
    self, predicate: PredicateSymbol, arguments: tuple[ValueTerm, ...],
    hyp_name: str | None = None,
) -> Node:
    ...
    prop_node = self._add_predicate_application_term(
        PredicateApplication(predicate, arguments)
    )
    if hyp_name is not None:
        prop_term: Term = ...  # reconstruct the Term for this proposition
        proof: Term = mk_app(Var("@eq_true"), prop_term, Var(hyp_name))
        self._record_eq(prop_node, self._true_node, proof)
    _ = self._union_nodes(prop_node, self._true_node)
    return prop_node
```

#### In `_rebuild` (line 613) — congruence closure

```python
# Inside _rebuild, when previous is not None:
changed = self._union_nodes_without_rebuild(left=previous, right=node) or changed

# Before the union, record the congruence proof:
congruence_proof = self._build_congruence_proof(previous, node)
self._record_eq(previous, node, congruence_proof)
```

Wait — but you need to call `_record_eq` BEFORE the merge, because
`_union_nodes_without_rebuild` may trigger path compression that
obscures which nodes were originally merged.  However,
`_union_nodes_without_rebuild` does NOT compress; only `_find_index`
compresses.  So calling `_record_eq` right after the merge is also fine
as long as you use the original `previous` and `node` objects.

**Actually, it's cleaner to pass the proof into `_union_nodes_without_rebuild`**,
so let's go back to adding an optional `proof_edge` parameter to it.
Then in `_rebuild`:

```python
proof = self._build_congruence_proof(previous, node)
changed = self._union_nodes_without_rebuild(
    left=previous, right=node, proof_edge=proof
) or changed
```

And inside `_union_nodes_without_rebuild`, after line 562
(`self._sizes[left_root] += …`), add:

```python
if proof_edge is not None:
    self._record_eq(left, right, proof_edge)
```

Using the original `left` and `right` (which are `Node` objects, not
the representatives `left_root`/`right_root`).

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
            self._type_of_node(a),   # need node types — see note below
            self._node_to_term(a),
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
        # result : a = mid,  proof : mid = next
        # → Eq.trans result proof : a = next
        result = mk_app(Var("@Eq.trans"), result, proof)
    return result
```

### 7.3 Important nuance: node "types" and `_node_to_term`

The `Eq.refl` case needs a type annotation `@Eq.refl T t`.  But your
e‑graph does not currently store the *type* of each node (it only knows
`NodeKind.VALUE` vs `NodeKind.PROP`).  For simplicity, do NOT include
type annotations in the generated proofs — let Lean’s elaborator infer
them.  The `@Eq.refl` call can be just `Var("@Eq.refl")` applied to a
placeholder or the term itself.

However, to reconstruct the **term** a node represents (needed by
`Eq.refl`, `eq_true`, etc.), you need a helper:

```python
def _node_to_term(self, node: Node) -> Term:
    """Reconstruct a scaffolding Term from an e-graph node.
    
    This is the inverse of _add_node: given a Node, return the
    public Term that created it.  You already have
    self._node_terms and self._term_to_node, but the latter maps
    Term → Node.  You need the reverse mapping.
    """
    # Store a reverse mapping in _add_node:
    # self._node_to_public_term: dict[int, Term] = {}
```

Add to `_add_node` (after line 527):

```python
self._node_to_public_term[self._node_index(node)] = public_term
```

Then `_node_to_term` just reads this dictionary.

**Actually, for `Eq.refl` on a value node, you need to construct the
scaffolding Term manually** — you can't just look up the stored
`public_term`, because stored `public_term`s for function applications
are the *original syntax*, not the fully evaluated form.

A cleaner approach: store the *scaffolding Term* for each node as it's
created.  In `_add_node`, also store a scaffolding representation:

```python
# Mapping node_id → scaffolding Term
self._node_terms_lean: dict[int, Term] = {}
```

But you need to define how to convert each `_NodeTerm` variant into a
scaffolding `Term`.  Example:

```python
def _node_internal_to_lean(self, node_term: _NodeTerm) -> Term:
    if isinstance(node_term, _ConstantNode):
        return Var(node_term.name)
    elif isinstance(node_term, _FunctionApplicationNode):
        func = self._node_to_lean(node_term.function)
        args = [self._node_to_lean(a) for a in node_term.arguments]
        return mk_app(func, *args)
    elif isinstance(node_term, _EqualsNode):
        left = self._node_to_lean(node_term.left)
        right = self._node_to_lean(node_term.right)
        return mk_app(Var("@Eq"), Var("A"), left, right)  # A is a placeholder
    ...
```

### 7.4 Simpler alternative: store public Term per node

Since every node was created from a public `Term` argument
passed to `_add_node`, you already have the `public_term` in that method.
Just store it:

```python
# In _add_node, before returning:
self._node_to_public_term[self._node_index(node)] = public_term
```

Then:

```python
def _node_to_term(self, node: Node) -> Term:
    # Use the reverse mapping stored at node creation time.
    return self._node_to_public_term.get(
        self._node_index(node),
        Var("<unknown>")  # fallback
    )
```

This maps an e‑graph node back to the **original public syntax** — a
`Constant`, `FunctionApplication`, `Equals`, `PredicateApplication`,
etc.  These are exactly the `Term` objects you want in the proof.
Since they're `Term` (scaffolding type), you can embed them directly.

**Wait, careful**: the `egraph.Term` (e‑graph public AST) is NOT the
same type as `scaffolding.syntax.Term` (Lean AST).  They are different
hierarchies.  See `egraph.py` lines 5–9:

```python
type HigherOrderTerm = FunctionSymbol | PredicateSymbol
type ValueTerm = Constant | FunctionApplication
type PropTerm = PredicateApplication | Equals | TrueTerm | FalseTerm
type Term = HigherOrderTerm | ValueTerm | PropTerm
```

These are egraph‑internal AST classes.  The scaffolding AST classes
(`Var`, `App`, `Lam`, etc.) are unrelated.

**So you cannot use the egraph `Term` directly in the proof.**  You must
convert every egraph node *internally* to a scaffolding `Term`.

### 7.5 Recommended approach: convert `_NodeTerm` to scaffolding `Term` recursively

Store a recusive converter:

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
        # Use a placeholder Type — the elaborator will fill it in
        return mk_app(Var("@Eq"), Var("A"), left, right)
    elif isinstance(node_term, _TrueNode):
        return Var("True")
    elif isinstance(node_term, _FalseNode):
        return Var("False")
    raise TypeError(f"Unknown node term: {node_term!r}")
```

But this requires a type name to use as the first argument of `@Eq`.
You don't have that information in the e‑graph (the type is erased).
You have two options:

**Option A**: Store the type alongside each node (add a `_node_types`
list).  This is clean but more work.

**Option B (simpler, recommended)**: Don't specify the type argument at all.
Use `Var("@Eq")` alone, and let Lean infer.  However, the scaffolding
printer will output `@Eq` with no arguments, which is not valid Lean.

**Option C (pragmatic)**: Track the single type variable name (e.g.
`"A"`) from `entry.py` and pass it into the e‑graph.  For the current
codebase, there is exactly one type variable per problem (see
`entry.py` line 46: `"We only support at most one type right now"`).

**Use Option C.**  Add `self._type_name: str = "A"` to `EGraph` and set
it from `entry.py`.  This gives you the type `Var("A")` for `@Eq` and
for motive types in `Eq.ndrec`.

### 7.6 Revised `_get_eq_proof` with type awareness

```python
def _get_eq_proof(self, a: Node, b: Node) -> Term:
    a_id = self._node_index(a)
    b_id = self._node_index(b)

    if self._find_index(a_id) != self._find_index(b_id):
        raise RuntimeError(f"not in same e-class: {a_id}, {b_id}")

    if a_id == b_id:
        return mk_app(
            Var("@Eq.refl"),
            Var(self._type_name),
            self._node_to_lean_term(a),
        )

    # BFS as in §7.2
    ...
```

---

## 8. Phase 3 — Congruence Proof Construction

### 8.1 When is this needed?

During congruence closure in `_rebuild` (line 613), two function‑ or
predicate‑application nodes `prev` and `curr` are found to share the
same congruence key.  You need to construct a proof that `prev = curr`
using the equality proofs of their arguments.

### 8.2 The `_build_congruence_proof` method

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

    # Reconstruct arguments
    a_args: tuple[Node, ...] = a_term.arguments
    b_args: tuple[Node, ...] = b_term.arguments

    # We'll prove:  f(args_a) = f(args_b)
    # by substituting one argument at a time via Eq.ndrec.

    # Start with the full left‑hand‑side and right‑hand‑side as Lean terms
    lhs = self._node_to_lean_term(a)
    rhs = self._node_to_lean_term(b)

    if a_args == b_args:
        # Arguments are the same nodes → trivial
        # (Should not happen since they'd be the same node)
        return mk_app(Var("@Eq.refl"), Var(self._type_name), lhs)

    # The initial proof: f(a0, a1, ...) = f(a0, a1, ...)
    proof = mk_app(Var("@Eq.refl"), Var(self._type_name), lhs)

    n = len(a_args)
    assert n == len(b_args)

    for i in range(n):
        # At this point, proof is:
        #   f(b0, ..., b_{i-1}, a_i, a_{i+1}, ..., a_{n-1})
        #   = f(b0, ..., b_{i-1}, a_i, a_{i+1}, ..., a_{n-1})
        # We want to replace the second a_i with b_i.

        # Get the proof that a_i = b_i
        eq_arg = self._get_eq_proof(a_args[i], b_args[i])

        # Build the motive:
        # fun (z : T_i) =>
        #   f(b0, ..., b_{i-1}, a_i, a_{i+1}, ...)
        #   = f(b0, ..., b_{i-1},  z,  b_{i+1}, ...)

        left_args: list[Term] = []
        right_args: list[Term] = []
        for j in range(n):
            if j < i:
                left_args.append(self._node_to_lean_term(b_args[j]))
                right_args.append(self._node_to_lean_term(b_args[j]))
            elif j == i:
                left_args.append(self._node_to_lean_term(a_args[j]))
                right_args.append(Var("z"))
            else:
                left_args.append(self._node_to_lean_term(a_args[j]))
                right_args.append(self._node_to_lean_term(b_args[j]))

        fn = self._node_to_lean_term(a_term.function)
        left_side = mk_app(fn, *left_args)
        right_side = mk_app(fn, *right_args)

        motive = Lam("z", Var(self._type_name),
            mk_app(Var("@Eq"), Var(self._type_name), left_side, right_side)
        )

        # Apply Eq.ndrec
        proof = mk_app(
            Var("@Eq.ndrec"),
            Var(self._type_name),      # A
            self._node_to_lean_term(a_args[i]),  # a
            motive,                     # motive
            proof,                      # motive a
            self._node_to_lean_term(b_args[i]),  # b
            eq_arg,                     # a_i = b_i
        )

    return proof
```

**Worked example (unary function)**:

- `a` = `f(x)`, `b` = `f(y)`, `a_args = (x_node,)`, `b_args = (y_node,)`
- `_get_eq_proof(x_node, y_node)` returns `h` (the hypothesis `Var("h")`)
- `lhs` = `f x`, `rhs` = `f y`
- Initial proof: `Eq.refl (f x)`
- Loop i=0:
  - `eq_arg` = `h`
  - `motive` = `fun (z : A) => f x = f z`
  - `proof` = `Eq.ndrec A x (fun z => f x = f z) (Eq.refl (f x)) y h`
- Result type: `f x = f y` ✓

### 8.3 What about `_EqualsNode` congruence?

`_EqualsNode` is also in `_congruence_nodes`, so `_rebuild` may try to
merge two `_EqualsNode`s.  This happens when the left/right e‑classes
of two equality propositions match.  For now, skip this case — the
proof graph is still sound (the equalities are already in the e‑class
via other means).  You can add a special case:

```python
if isinstance(a_term, _EqualsNode):
    # Congruence of equality propositions.
    # a = (l = r), b = (l' = r'), and we have l=l', r=r'.
    # The proof is more involved; skip for v1.
    return mk_app(Var("@Eq.refl"), Var(self._type_name), lhs)
```

---

## 9. Phase 4 — The `generate_proof` Method

### 9.1 What it receives

```python
def generate_proof(
    self,
    context: list[tuple[str | None, Term]],  # Pi bindings from entry.py
    goal_type: Term,                          # the goal proposition type
    goal_term: Term,                          # the scaffolding Term for the goal
) -> Term:
    """Build the full Classical.byContradiction proof term.

    Called from entry.py when isBottom() returns True.
    """
```

Actually, rather than receiving the full context, you can receive a
simplified structure.  But let's be precise about what happens: the
overall proof is a `Lam` chain wrapping the `byContradiction` block.

`entry.py` line 31 already extracts the `context` list.  It contains
`(name, type)` pairs from the Pi bindings of the theorem.  These are the
arguments to the top‑level `Lam`s.

The `goal` (entry.py line 37) is the final body of the theorem — the
proposition to prove.

### 9.2 Algorithm

```python
def generate_proof(self, context, goal_type, goal_term) -> Term:
    # 1. Find the goal node (we stored it in addGoal)
    goal_node = self._goal_node
    assert goal_node is not None

    # 2. Find a "true witness" — a proposition node in _true_node's
    #    e-class that has a stored _true_witness name (i.e., it was
    #    directly asserted true by a hypothesis).
    true_witness_node: Node | None = None
    true_witness_name: str | None = None
    for nid, name in self._true_witness.items():
        node = self._nodes[nid]
        if self.sameClass(node, self._true_node):
            true_witness_node = node
            true_witness_name = name
            break

    if true_witness_node is None:
        # No hypothesis — maybe the goal is trivially true?
        # Fall back to by grind for now.
        return ElabTactic("grind")  # TODO: handle reflexivity etc.

    # 3. Get the proof that true_witness = goal
    eq_proof = self._get_eq_proof(true_witness_node, goal_node)
    # eq_proof : true_witness = goal

    # 4. Build the chain: True = true_witness = goal = False
    #    true_witness = True  (via eq_true)
    #    Symmetry gives True = true_witness
    true_witness_term = self._node_to_lean_term(true_witness_node)
    eq_true_proof = mk_app(Var("@eq_true"), true_witness_term,
                           Var(true_witness_name))
    true_eq_witness = mk_app(Var("@Eq.symm"), eq_true_proof)

    # goal = False  (via eq_false with contradiction hypothesis)
    goal_node_term = self._node_to_lean_term(goal_node)
    # The contradiction hypothesis is bound inside the byContradiction
    # lambda — we'll use Var("h_contra") as a placeholder.
    eq_false_proof = mk_app(Var("@eq_false"), goal_node_term,
                            Var("h_contra"))

    # Chain:
    #   Eq.trans (True = witness) (witness = goal)  →  True = goal
    #   Eq.trans (True = goal)     (goal = False)    →  True = False
    true_eq_goal = mk_app(Var("@Eq.trans"), true_eq_witness, eq_proof)
    true_eq_false = mk_app(Var("@Eq.trans"), true_eq_goal, eq_false_proof)

    # 5. Build the inner block
    #    @Eq.mp True False true_eq_false True.intro
    false_proof = mk_app(
        mk_app(Var("@Eq.mp"), Var("True"), Var("False"),
               true_eq_false),
        Var("True.intro"),
    )

    #    @id False false_proof
    inner = mk_app(Var("@id"), Var("False"), false_proof)

    # 6. Wrap in Classical.byContradiction
    #    The contradiction hypothesis is: fun (h_contra : Not goal) => ...
    not_goal = mk_app(Var("Not"), goal_node_term)
    contra_lam = Lam("h_contra", not_goal, inner)

    body = mk_app(
        Var("@Classical.byContradiction"),
        goal_node_term,
        contra_lam,
    )

    # 7. Wrap in outer Lambdas for the context
    result = body
    for var_name, var_type in reversed(context):
        if var_name is not None:
            result = Lam(var_name, var_type, result)

    return result
```

### 9.3 Passing hypothesis variable names

`entry.py` needs to pass the hypothesis variable names to the e‑graph.
Modify the `addTerm` call in `entry.py` line 73:

**Current** (lines 66–73):
```python
elif isinstance(type, App):
    print(f"    - add hypothesis {print_term(type)} to egraph")
    eg_term = lean_to_egraph(type, env, arities)
    ...
    _ = egraph.addTerm(eg_term)
```

**Needed change**: `addTerm` needs to know `name` (the hypothesis
variable name, e.g. `"h"`, `"h_1"`).  Name is available from the
context loop variable on line 44.

You have two options:

**Option A**: Add a `hyp_name` parameter to `addTerm` and all its
callees.

**Option B**: Add a separate method `addHypothesis(term, name)`.

**Recommendation**: Add `addHypothesis`:

```python
def addHypothesis(self, term: Term, hyp_name: str) -> Node:
    """Add a hypothesis term, recording its variable name for proofs."""
    if isinstance(term, Equals):
        return self._add_true_equality_term_with_name(term, hyp_name)
    elif isinstance(term, PredicateApplication):
        return self._add_predicate_application_term_with_name(
            term, hyp_name)
    elif isinstance(term, TrueTerm):
        return self._true_node
    elif isinstance(term, FalseTerm):
        _ = self._union_nodes(self._false_node, self._true_node)
        return self._false_node
    raise TypeError(f"Not a hypothesis: {term!r}")
```

Then in `entry.py`, change the hypothesis‑handling branch to call
`egraph.addHypothesis(eg_term, name)`.

Because of how the loop works, `name` is already the hypothesis name
(e.g., `"h"` for `@Eq A x y`, `"h_1"` for `P x`).

### 9.4 Handling types in `Eq.ndrec` and `@Eq`

The `@Eq.ndrec` application needs the type variable.  Currently the
e‑graph doesn't store types.  Simple fix: set it from `entry.py`:

```python
# In entry.py, find the type variable name (the one with Sort(1))
# and pass it to the egraph:
egraph.set_type_name(type_name)
```

Or just hardcode `"A"` for the current single‑type setup (the e‑graph
doesn't use it for logic, only for proof printing).

**Better**: When `entry.py` processes the context and finds `(name, Sort(1))`,
store that name.  Pass it to `egraph.set_type_name(name)`.  For
example, in entry.py line 49:
```python
env[name] = "type"
egraph.set_type_name(name)  # <-- ADD THIS
```

For the `mk_app(Var("@Eq"), ...)` calls, use `Var(type_name)` as the
first argument.

---

## 10. Phase 5 — Wiring into `entry.py`

### 10.1 Changes to `entry.py`

In `tinygrind()` (entry.py lines 26–94):

1. **Capture the type name** (line 49):
   ```python
   if isinstance(type, Sort) and type.level == 1 and name:
       ...
       egraph.set_type_name(name)    # NEW
   ```

2. **Change hypothesis handling** (lines 66–73):
   ```python
   elif isinstance(type, App):
       ...
       _ = egraph.addHypothesis(eg_term, name)   # was: addTerm(eg_term)
   ```

3. **Generate proof instead of `by grind`** (lines 89–91):
   ```python
   if egraph.isBottom():
       print(f"   = egraph found solution, generating proof")
       return egraph.generate_proof(context, goal, goal_eg)
   ```

   Note: `goal` here is the scaffolding `Term` for the goal (from
   `theorem.body` after stripping Pi).  `goal_eg` is the egraph
   `Term` — not useful inside `generate_proof`, since `generate_proof`
   needs the goal node (stored in `_goal_node`).

   Actually, `generate_proof` needs the **scaffolding `Term`** for the
   goal to embed it in the proof.  So you need to convert `goal` (which
   is already a scaffolding `Term` from the parser) into something the
   e‑graph can use.

   The simplest: pass `context` and the `goal` scaffolding term directly:

   ```python
   return egraph.generate_proof(context, goal)
   ```

   Inside `generate_proof`, use `goal` as the `goal_term` for
   `Classical.byContradiction`, `eq_false`, and `Not` wrapping.

### 10.2 Updated `generate_proof` signature

```python
def generate_proof(
    self,
    context: list[tuple[str | None, Term]],  # from entry.py line 31
    goal_scaffolding_term: Term,              # scaffolding Term for the goal
) -> Term:
```

The `goal` scaffolding `Term` is e.g. `App(App(App(Var("@Eq"), Var("A")), ...), ...)`
for an equality goal — it comes straight from the parser.

### 10.3 Reconstructing the goal's Lean term from the e‑graph

Alternatively, to avoid passing two representations of the goal, you
can reconstruct the scaffolding `Term` for the goal from the e‑graph's
`_goal_node` using `_node_to_lean_term`.  This way `generate_proof`
takes only `context` and everything else comes from the e‑graph's
internal state.

```python
def generate_proof(
    self,
    context: list[tuple[str | None, Term]],
) -> Term:
    goal_node = self._goal_node
    assert goal_node is not None
    goal_lean_term = self._node_to_lean_term(goal_node)
    ...
```

This is cleaner.

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

**Step 1:** `A` is recognized as a type (`Sort(1)`).  `egraph.set_type_name("A")`.

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
        - `Eq.ndrec A x (fun z => P x = P z) (Eq.refl (P x)) y h`
    - Records proof edge: `N_Px = N_Py` via this `Eq.ndrec` proof.

### Proof extraction

`isBottom()` returns True (N_true and N_false are in the same class).

**`generate_proof` runs:**

1. `goal_node` = N_Py
2. `true_witness_node` = N_Px (the first `_true_witness` entry found)
3. `_get_eq_proof(N_Px, N_Py)` runs BFS:
    - N_Px has edge to N_Py via `Eq.ndrec … h …` proof.
    - Returns that proof directly.
    - `eq_proof` = `Eq.ndrec A x (fun z => P x = P z) (Eq.refl (P x)) y h`
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
          (@Eq.ndrec A x (fun (z : A) => @Eq (P x) (P z))
            (@Eq.refl (P x)) y h))
        (@eq_false (P y) h_contra))
      True.intro))
```

Compare with GRIND.md lines 15–29 — the structure matches (minus HEq).

---

## 12. Edge Cases and Debugging

### 12.1 The goal IS an equality

Example 3 (`congruence_on_functions`):
```
Goal: @Eq A (f (f a)) (f (f b))
```

Here the goal itself is an `Equals` node.  The `_true_witness` will
also be an `Equals` node (the equality is derivable from hypotheses
and congruence).  `_get_eq_proof` works at the *Prop* level for
proposition nodes, and at the *value* level for `left`/`right` of
equalities.  The BFS will naturally handle both.

### 12.2 Reflexivity (no hypothesis)

Example 6: `a = a`.  The e‑graph unions `Equals(a,a)` with True via
`_reflect_equalities_once` line 637 (reflexivity).  No hypothesis
variable asserts it.  The `_true_witness` dict will not have an
entry.

**Fix**: If no `_true_witness` is found, check if the goal node is
itself `Equals(a,b)` and `a` and `b` are in the same e‑class.  Build
the proof directly:

```python
goal_node_term = self._node_terms[self._node_index(goal_node)]
if isinstance(goal_node_term, _EqualsNode):
    left = goal_node_term.left
    right = goal_node_term.right
    if self.sameClass(left, right):
        eq_proof = self._get_eq_proof(left, right)
        # eq_proof: left = right
        # eq_true (left = right) eq_proof  →  (left = right) = True
        # But we need the goal = True directly...
```

Actually, for the `byContradiction` proof, you need the goal to be
equal to `True` (the first step in the chain).  If the goal is
`Equals(l, r)` and `l = r` is true, then `eq_true` applied to the proof
of `l = r` (a *value‑level* equality) gives `(l = r) = True` (a *Prop‑level*
equality).  But `eq_true` expects a proposition and a proof of that
proposition — and `l = r` IS a proposition.

So: `eq_true (l = r) (get_eq_proof(l, r))` gives `(l = r) = True`.

In this case, the `_true_witness` is the goal node itself.  You don't
need a separate witness — the goal is its own true witness.

### 12.3 Predicate goal (no hypothesis)

Example: `P a` as a goal, `P a` as a hypothesis.  The goal node is
`P a`, which is also in `True`'s e‑class (via the hypothesis).  Same
logic: the goal IS its own true witness.

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

### 12.5 What about `Eq.symm` in the BFS?

The `_record_eq` method (see §6.2) records both `a=b` and `b=a` edges.
This makes the BFS graph undirected, so you don't need to insert
`Eq.symm` calls during BFS — the symmetric edge already has symmetry
applied at recording time.

The only place you explicitly use `Eq.symm` is in `generate_proof` when
converting `(P x) = True` to `True = (P x)`.

### 12.6 Tracking node ID → variable name for `_true_witness`

```python
# In addHypothesis (or equivalent):
def _add_true_equality_term_with_name(
    self, term: Equals, hyp_name: str
) -> Node:
    eq_node = self._add_equals_term(term)
    eq_node_term = self._node_terms[self._node_index(eq_node)]
    assert isinstance(eq_node_term, _EqualsNode)

    left = eq_node_term.left
    right = eq_node_term.right

    # 1. left = right (value-level)
    eq_proof = Var(hyp_name)
    self._record_eq(left, right, eq_proof)

    _ = self._union_nodes(left, right)

    # 2. (left = right) = True  (prop-level)
    eq_prop = mk_app(Var("@Eq"), Var(self._type_name),
                     self._node_to_lean_term(left),
                     self._node_to_lean_term(right))
    true_proof = mk_app(Var("@eq_true"), eq_prop, Var(hyp_name))
    self._record_eq(eq_node, self._true_node, true_proof)

    # 3. Remember this node as a true witness
    self._true_witness[self._node_index(eq_node)] = hyp_name

    _ = self._union_nodes(eq_node, self._true_node)
    return eq_node
```

### 12.7 Multiple true witnesses

If the `_true_witness` dict has multiple entries in True's e‑class,
pick the first one.  The BFS will find a path from any of them to the
goal (all paths go through the same connected component).

### 12.8 No `Eq.ndrec` for the final "goal = False" step

Note the asymmetry: the `_true_witness = Goal` proof uses `_get_eq_proof`
(which may involve congruence/transitivity/etc.), but the `Goal = False`
proof always uses `eq_false` with the contradiction hypothesis.  You
do NOT need to record an edge from `_goal_node` to `_false_node` — the
`eq_false` lemma handles it directly.

---

## Appendix A — Summary of Methods to Add to `EGraph`

| Method | Purpose |
|---|---|
| `set_type_name(name: str)` | Store the single type variable name |
| `addHypothesis(term, hyp_name)` | Add a hypothesis, recording its variable name |
| `_record_eq(a, b, proof)` | Register a proof that `a = b` in the adjacency graph |
| `_node_to_lean_term(node) → Term` | Convert an e‑graph node to a scaffolding `Term` |
| `_get_eq_proof(a, b) → Term` | BFS‑based proof that two nodes are equal |
| `_build_congruence_proof(a, b) → Term` | `Eq.ndrec`‑based congruence proof |
| `generate_proof(context) → Term` | The top‑level proof‑term constructor |
| `debug_print_edges()` | Print the proof adjacency graph for debugging |

## Appendix B — Summary of Changes to `entry.py`

| Line(s) | Change |
|---|---|
| 49 | Add `egraph.set_type_name(name)` |
| 66–73 | Replace `egraph.addTerm(eg_term)` with `egraph.addHypothesis(eg_term, name)` |
| 89–91 | Replace `ElabTactic("grind")` with `egraph.generate_proof(context)` |
| 242 | In `addGoal`, store `self._goal_node = prop_node` |

---

## Appendix C — What to Test First

Recommended order for implementation and testing:

1. Add `_record_eq` and wire it into `_add_true_equality_term` and
   `addPredicateApplication` (with `hyp_name` parameters).
2. Implement `_node_to_lean_term`.
3. Implement `_get_eq_proof` (BFS).
4. Implement `_build_congruence_proof` and wire it into `_rebuild`.
5. Implement `generate_proof`.
6. Wire `entry.py`.
7. Test with `example06.lean` (reflexivity — simplest).
8. Test with `example01.lean` (basic_subst — one congruence).
9. Test with `example03.lean` (double congruence).
10. Test with `example10.lean` (transitive chain only, no functions).

Run with `python main.py` — the output file `problems/__output.lean`
will contain the generated proofs.  Compile them with `lake build` in
the problems directory to verify they typecheck.
