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

## Overall architecture

Our prover will take problems from `/problems`, each problem is a lean file with a theorem definition which is solvable solely with `by grind`. Our parser read these definitions and output a lean proof for each definition into `output.lean`. This file should type check when inserted into an lean environment. In the beginning, we want to focus only on problems that grind is able to solve in the latest release of lean. Converting TPTP problems into lean seems feasable and can serve as a foundation of problems to look at. Due to the modular nature E-graphs, we aim to build and expand the prover in several phases.

### Phase 1

The focus in on ground terms and function applications, very similiar to the example in the introduction. We need to implement the E-graph, congruence closure, handling of True/False/Eq and a basic proof generator. The graph can be untyped at first (we assume all symbols are operating on the same type). We might generate a synthetical set of problems to test the prover and get edge cases right.

### Phase 2

Next up, we want to improve the logical expressiveness of the language. Support for AND, OR, and other logical operations will be added including constraint propagations, and E-matching will be explored to allow instantiations. Case spliting might be necessary to handle alternative branches. This will also be the time to consider adding a good set of lemmas to the E-matching engine, so that more logical proofs can be found.

We assume that this phase might take a good amount of time, but after that, the prover should have a strong foundation that can be easily extended with further lemmas - without the need to rewrite much of the internal logic.

### Phase 3

There are several possible extensions to the solver, there are surely edge cases of phase 2 that need more attention, we can fine-tune the performance more and find bigger problem sets to benchmark the prover. Additionally, more lemmas could be added or more nested problems be attempted. Finally, we might integrate satellite theory solvers.






