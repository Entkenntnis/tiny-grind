def demo3_bad_arrow_pi_used_not_equiv :
  (A : Type) -> (B : A -> Type) -> (y : A) -> ((x : A) -> B x) -> B y :=
  fun (A : Type) (B : A -> Type) (y : A) (f : A -> B y) => f y
