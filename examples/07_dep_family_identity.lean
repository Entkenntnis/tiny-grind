def demo_dep_family_identity :
  (A : Type) -> (B : A -> Type) -> (x : A) -> B x -> B x :=
  fun (A : Type) (B : A -> Type) (x : A) (bx : B x) => bx
