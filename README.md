# tiny-grind

An educational best-effort reimplementation of the grind tactic in Python within a tiny LEAN kernel.

> **The Programmers' Credo:**
> "We do these things not because they are easy, but because we thought they were going to be easy."
> — *Maciej Cegłowski*

How hard can it be, haha?

## Scope

I would like to introduce tactics mode into the syntax. Next, I need an interface to read the context and pass this information to the grind module. The grind module should manage an E-graph (how exactly would it look like?), I'm settling on four operations for the start:

- congruence closure
- E-matching
- constraint propagation
- some basic case analysis

