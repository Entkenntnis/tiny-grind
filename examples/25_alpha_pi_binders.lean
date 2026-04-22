def demo3_alpha_pi_binders :
  (A : Type) -> ((x : A) -> A) -> A -> A :=
  fun (A : Type) (f : (z : A) -> A) (a : A) => f a
