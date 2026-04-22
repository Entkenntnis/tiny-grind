axiom P : Prop
axiom proofA : P
axiom proofB : P

axiom A : Type
axiom f : P -> A

-- Lean accepts this because `f proofA` ≡ `f proofB` definitionally.
-- Your kernel fails: It infers @Eq.refl A (f proofA) as `@Eq A (f proofA) (f proofA)`.
-- It then checks this against `@Eq A (f proofA) (f proofB)`.
-- Since `proofA` != `proofB` syntactically, it throws a TypeError.
def example_2 : @Eq A (f proofA) (f proofB) := @Eq.refl A (f proofA)