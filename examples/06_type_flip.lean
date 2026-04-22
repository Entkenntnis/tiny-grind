def demo_type_flip :
  (A : Type) -> (B : Type) -> (C : Type) -> (A -> B -> C) -> B -> A -> C :=
  fun (A : Type) (B : Type) (C : Type) (h : A -> B -> C) (b : B) (a : A) =>
    h a b
