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

## Limitations

Main omissions from the kernel:

- No `inductive` keyword, constructors are hardcoded as axioms, recursors implemented in python where necessary. Stick to LEAN implementation for soundness, avoids a lot of headaches in the kernel.
- No universe polymorphism, so category theory will be pain, stick to the parts of mathematics that are intended for mortals.

Most syntactical sugar (implicit arguments, shorthands, match, case) is omitted, as this is not impacting the theoretical expressiveness, it can be added ad-hoc.
