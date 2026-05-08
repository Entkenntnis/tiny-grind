# tiny-grind

An educational best-effort reimplementation of the `grind` tactic in Python.

## Introduction

Let's look at this set of equalities/inequalities with constants $a$, $b$, $c$, $d$ and unary functions $f$, $g$, $h$ (all operating on variables of the same type):

- $a = f(b)$
- $f(b) = g(c)$
- $g(c) = h(d)$
- $d = a$
- $g(f(h(a))) \neq g(f(g(c)))$

By rewriting the terms and using congruence rules, you can derive a contradiction. Many mathematical problems can be expressed as such sets of equalities, and automated theorem provers aim to solve them automatically.

One could, for example, define a term ordering and apply superposition to derive the empty clause. Another approach is to construct an *E-graph* and perform congruence closure on it; a contradiction is found when `True` and `False` land in the same equivalence class. This latter approach is taken by `grind`, and our project will build a proof generator that can prove theorems, create a suitable context (proof by contradiction), construct the E-graph, and finally generate a Lean proof for the theorem.

### Superposition vs. E-graphs

There is no “better” – both approaches have their unique strengths and weaknesses. Superposition has a stronger theoretical foundation, and high-performance implementations exist, although doing superposition right is hard because the number of clauses can grow very large when the selection is not optimal. Congruence closure on E-graphs, on the other hand, is simpler to implement. Because an E-graph represents an exponential number of possible equalities in a compact way, it often avoids state explosion; even naive implementations tend to be reasonably stable for congruence closure. E-graphs are also more modular: additional elements like logical operators, quantifiers, or inductive types can be added with their respective saturation rules and treated as “modules”, following the architecture of SMT solvers. In contrast, superposition always works within the resolution framework, which assumes that problems are decomposed into CNF already. During this process much of the intuition from the original context is lost – E-graphs can retain that context and operate on it, e.g. through E-matching.

For standalone, fully automated provers, superposition is a tried-and-tested approach. Within interactive theorem provers that work alongside human-written theorems, keeping the context and having a modular design are strengths of E-graphs, which may explain the success of a tactic like `grind`. We find this aspect intriguing, and to learn more about how it works in practice and how one can structure such a prover, we will attempt to rebuild `grind`.
