def demo2_apply_twice_type : (A : Type) -> (A -> A) -> A -> A :=
  fun (A : Type) (f : A -> A) (x : A) => f (f x)
