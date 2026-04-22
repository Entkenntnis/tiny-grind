def demo_bad_dependent_return :
  (A : Type) -> (B : A -> Type) -> (x : A) -> B x -> B x :=
  fun (A : Type) (B : A -> Type) (x : A) (bx : B x) => x
