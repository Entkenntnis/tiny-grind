def demo2_bad_apply_twice_codomain :
  (A : Type) -> (A -> A) -> A -> Type :=
  fun (A : Type) (f : A -> A) (x : A) =>
    f (f x)
