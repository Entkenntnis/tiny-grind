def demo3_arrow_pi_unused_equiv :
  (A : Type) -> ((y : A) -> A) -> A -> A :=
  fun (A : Type) (f : A -> A) (x : A) => f x
