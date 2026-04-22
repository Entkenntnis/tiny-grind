def demo_type_compose :
  (A : Type) -> (B : Type) -> (C : Type) -> (B -> C) -> (A -> B) -> A -> C :=
  fun (A : Type) (B : Type) (C : Type) (g : B -> C) (f : A -> B) (x : A) =>
    g (f x)
