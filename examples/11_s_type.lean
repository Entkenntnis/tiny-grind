def demo2_s_type :
  (A : Type) -> (B : Type) -> (C : Type) -> (A -> B -> C) -> (A -> B) -> A -> C :=
  fun (A : Type) (B : Type) (C : Type) (s : A -> B -> C) (g : A -> B) (a : A) =>
    s a (g a)
