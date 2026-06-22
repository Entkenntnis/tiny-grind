# Tutorial: Connecting the Lean Parser to the E-Graph

## Overview

`entry.py` is supposed to be the bridge: parse a Lean theorem → extract
hypotheses/goal → feed them into the E-graph → check if the theorem is proved.
Right now it only prints debug info and returns nothing, so every proof comes out
as `None`.  This tutorial walks through fixing it.

**Files you'll be editing:** `src/tinygrind/entry.py`

**Files you should understand:** `src/scaffolding/syntax.py`, `src/tinygrind/egraph.py`,
`src/scaffolding/parser.py`, `main.py`, `tests/test_egraph3.py`

---

## Part 1 — Understand the Two Term Languages

The project has **two completely separate ASTs** for terms.  The parser produces
one, the E-graph expects the other.  You need to translate between them.

### 1A.  Lean AST (`scaffolding/syntax.py`)

These are the nodes the parser produces from `.lean` files:

| Node | What it represents | Example input |
|------|-------------------|---------------|
| `Var(name)` | A named variable | `x`, `A`, `f` |
| `Sort(0)` | The universe `Prop` | `Prop` |
| `Sort(1)` | The universe `Type` | `Type` |
| `Pi(var, var_type, body)` | Dependent function type / `->` | `(x : A) -> B`; `A -> B` (var=None) |
| `App(m, n)` | Function application | `f x`, `@Eq A x y`, `P x` |
| `Lam(...)` | Lambda abstraction | `fun (x : A) => ...` |
| `ElabTactic(name)` | A tactic placeholder | `by grind`, `by sorry` |
| `Definition(name, type, value)` | A top-level definition | `def foo : ... := ...` |

Key patterns to recognize in the AST:

```
-- "A -> A -> A"  (simple arrows, no binder names)
Pi(None, Var("A"), Pi(None, Var("A"), Var("A")))

-- "P : A -> Prop"  (a predicate of arity 1)
Pi(None, Var("A"), Sort(0))

-- "@Eq A x y"  (equality — 3 arguments in Lean, first is the type)
App(App(App(Var("@Eq"), Var("A")), Var("x")), Var("y"))

-- "P x"  (predicate application)
App(Var("P"), Var("x"))

-- "f a"  (function application)
App(Var("f"), Var("a"))
```

### 1B.  E-Graph Public AST (`tinygrind/egraph.py`)

These are the types you pass into `EGraph.addTerm()`, `addEquation()`,
`addPredicateApplication()`, and `addGoal()`:

| Type | What it represents |
|------|-------------------|
| `Constant(name)` | A value constant (e.g. `a`, `b`, `x`) |
| `FunctionSymbol(name, arity)` | A function symbol |
| `PredicateSymbol(name, arity)` | A predicate symbol |
| `FunctionApplication(function, args)` | Applying a function to value terms |
| `PredicateApplication(predicate, args)` | Applying a predicate to value terms |
| `Equals(left, right)` | An equality proposition |
| `TrueTerm` / `FalseTerm` | Boolean constants |

### 1C.  The Translation Rule

Every Lean AST node for an equality/proposition/value must be converted:

| Lean AST | E-Graph Term | Notes |
|----------|-------------|-------|
| `App(App(App(Var("@Eq"), _type), left), right)` | `Equals(convert(left), convert(right))` | Strip the type argument |
| `Var("x")` where x is a value | `Constant("x")` | Look up in an environment to know |
| `Var("f")` where f is a function | `FunctionSymbol("f", arity)` | Arity from its type |
| `Var("P")` where P is a predicate | `PredicateSymbol("P", arity)` | Arity from its type |
| `App(f, x)` where f is a function | `FunctionApplication(func, (arg,))` | Multi-arg: `App(App(f, x), y)` |
| `App(P, x)` where P is a predicate | `PredicateApplication(pred, (arg,))` | |

---

## Part 2 — Fix the Three Bugs in `entry.py`

### Bug A: Goal extraction is wrong (line 27)

**Current code:**

```python
while isinstance(theorem, Pi):
    ...
    context.append((var, var_type))
    theorem = theorem.body

goal = context.pop()    # <-- WRONG: pops the last HYPOTHESIS
```

**What's happening:** For a theorem `(A:Type) -> ... -> @Eq A x y -> P x -> P y`,
after the loop `theorem` holds `P y` (the actual goal).  But the code pops
`P x` from context and calls that the goal, leaving `P y` lost.

**The fix:**

```python
# After the while loop, theorem IS the goal
goal = theorem   # <-- the body after all Pi nodes is the conclusion

# ALL context entries (including the last one) are hypotheses.
# Do NOT pop from context.
```

### Bug B: `checkContextTyp` receives the wrong argument (line 48)

**Current code:**

```python
for c in context:
    print(checkContextTyp(c, theType))
```

`c` is a tuple `(name, Term)` — the whole pair.  Inside `checkContextTyp`, the
`isinstance(t, Sort)` check always fails because `t` is a tuple, not a `Sort`.

**The fix:** Pass only the **type** part of the tuple:

```python
for (name, typ) in context:
    kind = classify_term(typ, env)
    ...
```

### Bug C: No return value (line 49)

The function falls off the end and returns `None`.  It needs to actually create
an EGraph, populate it, run it, and return a `Term` (at minimum an
`ElabTactic("sorry")`).

---

## Part 3 — Build the Translation Layer

You need two data structures during translation:

### 3A.  An "environment" dict

Track what each name means so you can convert `Var(name)` correctly:

```python
env: dict[str, str] = {}  # name -> "type" | "constant" | "function" | "predicate"
symbol_arities: dict[str, int] = {}  # name -> arity (for functions/predicates)
```

### 3B.  A function to classify a type

Given a Lean AST `Term` (the type part of a context entry), determine what kind
of thing it is:

```python
def classify_term(t: Term) -> str:
    """Returns "type", "constant", "function", "predicate", "prop_eq", "prop_pred" """
    if isinstance(t, Sort):
        if t.level == 1:
            return "type"
        elif t.level == 0:
            return "prop"           # Sort 0 = Prop (a hypothesis)
    if isinstance(t, Var):
        return "constant"           # e.g. x : A where A is a type
    if isinstance(t, Pi):
        # A Pi whose body is a Sort(0) = predicate
        # A Pi whose body is a Var (of a type) = function
        # Otherwise recurse into body to find what's at the end
        ...
```

### 3C.  A function to compute arity from a Pi chain

```python
def compute_arity(t: Term) -> int:
    """Count how many Pi nodes wrap this term before hitting non-Pi."""
    count = 0
    while isinstance(t, Pi):
        count += 1
        t = t.body
    return count
```

Example: `Pi(None, Var("A"), Pi(None, Var("A"), Var("A")))` → arity 2

### 3D.  The main converter

```python
def lean_to_egraph(term: Term, env: dict[str, str], arities: dict[str, int]) -> egraph.Term:
    """
    Convert a Lean AST term to an E-Graph term.
    Uses env and arities to know what Var nodes represent.
    """
```

This must handle:

1. **`@Eq` detection**: Walk `App(App(App(Var("@Eq"), _), left), right))` →
   `Equals(convert(left), convert(right))`

2. **Function application**: `App(Var("f"), Var("x"))` → look up `f` in arities,
   create `FunctionApplication(FunctionSymbol("f", n), (Constant("x"),))`

3. **Multi-arg application**: `App(App(Var("f"), Var("x")), Var("y"))` →
   `FunctionApplication(FunctionSymbol("f", 2), (Constant("x"), Constant("y")))`

4. **Predicate application**: `App(Var("P"), Var("x"))` →
   `PredicateApplication(PredicateSymbol("P", n), (Constant("x"),))`

5. **Simple Var**: If it's a value constant → `Constant(name)`

---

## Part 4 — Process Each Context Entry

Loop through the context and handle each entry based on its classification:

```python
graph = EGraph()

for (name, typ) in context:
    kind = classify_term(typ)

    if kind == "type":
        env[name] = "type"

    elif kind == "constant":
        env[name] = "constant"
        graph.addTerm(Constant(name))

    elif kind == "function":
        arity = compute_arity(typ)
        arities[name] = arity
        env[name] = "function"
        graph.addTerm(FunctionSymbol(name, arity))

    elif kind == "predicate":
        arity = compute_arity(typ)  # Pi chain before Sort(0)
        arities[name] = arity
        env[name] = "predicate"
        graph.addTerm(PredicateSymbol(name, arity))

    elif kind == "prop_eq":
        # name is None (simple arrow hypothesis), typ is @Eq A x y
        eg_term = lean_to_egraph(typ, env, arities)
        if isinstance(eg_term, Equals):
            graph.addEquation(eg_term.left, eg_term.right)
        # (Or use addTerm(eg_term) which asserts it as true)

    elif kind == "prop_pred":
        # name is None, typ is P x
        eg_term = lean_to_egraph(typ, env, arities)
        if isinstance(eg_term, PredicateApplication):
            graph.addPredicateApplication(eg_term.predicate, eg_term.arguments)
```

**Important ordering:** Process type and symbol declarations BEFORE hypotheses.
Otherwise you won't know how to convert the Vars inside the hypotheses.  You can
do this by making two passes over the context, or by ensuring types/symbols come
first in the input (which they do for all current examples).

---

## Part 5 — Add the Goal and Check

```python
# Convert the goal (which is a Lean AST term)
goal_eg = lean_to_egraph(goal, env, arities)

# addGoal unions it with False (proof by contradiction)
graph.addGoal(goal_eg)

if graph.isBottom():
    # Contradiction found → theorem is proved
    return ElabTactic("grind")
else:
    # Could not prove
    return ElabTactic("sorry")
```

---

## Part 6 — Edge Cases to Handle

### Nested function applications in equalities

Example: `@Eq A (f a) b` → `Equals(FunctionApplication(FunctionSymbol("f",1), (Constant("a"),)), Constant("b"))`

Your converter must handle `App` nodes recursively on BOTH sides of `@Eq`.

### Multi-arity predicates / functions

Example: `P : A -> A -> Prop` → predicate of arity 2.
Example: `f : A -> A -> A` → function of arity 2.

In application: `App(App(Var("f"), Var("x")), Var("y"))` → `f x y`.

Your converter must collect **all** the consecutive `App` nodes to determine the
full argument list, then use the symbol's arity from `arities`.

### The `@Eq` case with 3 arguments

`@Eq A x y` is always `App(App(App(Var("@Eq"), type), left), right)`.
Strip the type argument (it's the domain type, not a value).

### Goals that are equalities

Example: `@Eq A a b` as goal → convert to `Equals(Constant("a"), Constant("b"))`,
then `graph.addGoal(eq_egraph_term)`.

### Goals that are predicate applications

Example: `P y` as goal → convert to `PredicateApplication(PredicateSymbol("P",1), (Constant("y"),))`,
then `graph.addGoal(pred_egraph_term)`.

---

## Part 7 — Testing Strategy

### 7A. Run the existing E-graph unit tests first

```bash
uv run python -m pytest tests/test_egraph3.py -v
```

This verifies the E-graph still works correctly.

### 7B. Test with example01

The simplest non-trivial test: `x=y, P x ⊢ P y`

```bash
uv run python -c "
import sys; sys.path.insert(0, 'src')
from scaffolding.parser import parse_declarations
from tinygrind.entry import tinygrind
from scaffolding.printer import print_term

decls = parse_declarations('''
def test : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> @Eq A x y -> P x -> P y := by grind
''')
result = tinygrind(decls[0])
print('Result:', print_term(result))
# Should print 'by grind' (proved), not 'by sorry'
"
```

### 7C. Run the full pipeline

```bash
uv run python main.py
```

Check `problems/__output.lean` — proofs should no longer be `None`.  Provable
theorems should have `by grind`, unprovable ones should have `by sorry`.

### 7D. Test with example03 (function congruence)

`a=b ⊢ f(f a) = f(f b)` — tests that function symbols and nested applications work.

### 7E. Test with example04 (the "deeper" example)

`a=f(b), f(b)=g(c), g(c)=h(d), d=a ⊢ g(f(h a)) = g(f(g c))` —
tests deep congruence closure with multiple function symbols.

### 7F. Test with example32 (multi-arity)

`a=b, c=d, f a c = g b d ⊢ f a c = g a d` — tests 2-arity functions.

---

## Part 8 — Reference: How the E-Graph API Works

Study `tests/test_egraph3.py` for the full pattern. Here's the minimal recipe:

```python
from tinygrind.egraph import EGraph, Constant, FunctionSymbol, PredicateSymbol, \
    FunctionApplication, PredicateApplication, Equals

graph = EGraph()

# Register symbols (not strictly required before use, but good practice)
a = graph.addNewConstant("a")
f = graph.addNewFunctionSymbol("f", arity=1)
P = graph.addNewPredicateSymbol("P", arity=1)

# Assert an equality as true
graph.addEquation(Constant("a"), Constant("b"))
# or equivalently:
graph.addTerm(Equals(Constant("a"), Constant("b")))

# Assert a predicate as true
graph.addPredicateApplication(PredicateSymbol("P", 1), (Constant("a"),))

# Set the goal (negated)
graph.addGoal(Equals(Constant("f a"), Constant("f b")))

# Check for contradiction
if graph.isBottom():
    print("Proved!")
```

**Key insight:** `addGoal(prop)` unions the proposition with `False`.
If the E-graph already knows it's true (from hypotheses + congruence closure),
then `True == False`, creating a contradiction (`isBottom()` returns `True`).

---

## Part 9 — Implementation Order

Do the steps in this order — each one builds on the last:

| Step | What | Check |
|------|------|-------|
| 1 | Fix goal extraction (Part 2, Bug A) | `output.txt` should show correct goals |
| 2 | Fix classification (Part 2, Bug B + Part 3B) | Debug-print each context entry's kind |
| 3 | Write `compute_arity` (Part 3C) | Test on `A->A->A` → 2 |
| 4 | Write `lean_to_egraph` for simple cases (Part 3D) | Var → Constant; @Eq x y → Equals |
| 5 | Write `lean_to_egraph` for applications (Part 3D) | App(f, x) → FunctionApplication |
| 6 | Populate EGraph (Part 4) | Equality hypotheses get asserted |
| 7 | Add goal (Part 5) | `isBottom()` returns correct result |
| 8 | Return proof term (Part 5) | `__output.lean` shows `by grind` / `by sorry` |

---

## Quick Reference: Useful Imports

At the top of `entry.py` you'll want something like:

```python
from scaffolding.syntax import Definition, ElabTactic, Pi, Sort, Term, Var, App
from tinygrind.egraph import (
    EGraph, Constant, FunctionSymbol, PredicateSymbol,
    FunctionApplication, PredicateApplication, Equals,
)
```

---

## Debugging Tips

Add a `--verbose` flag or just print during development:

```python
print(f"  kind={kind}, name={name}, type={print_term(typ)}")
print(f"  env={env}")
print(f"  arities={arities}")
print(f"  eterm={lean_to_egraph(term, env, arities)}")
```

The E-graph has `hasFact()` and `findClass()` methods you can call for debugging
after each `addTerm`/`addEquation` call.
