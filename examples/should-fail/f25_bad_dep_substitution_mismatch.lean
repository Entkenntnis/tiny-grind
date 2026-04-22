def demo3_bad_dep_substitution_mismatch :
  (A : Type) -> (B : A -> Type) -> (x : A) -> ((y : A) -> B y) -> B x :=
  fun (A : Type) (B : A -> Type) (x : A) (h : (y : A) -> B y) =>
    h (h x)
