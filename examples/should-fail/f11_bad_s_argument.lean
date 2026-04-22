def demo2_bad_s_argument :
  (A : Type) -> (B : Type) -> (C : Type) -> (A -> B -> C) -> (A -> B) -> A -> C :=
  fun (A : Type) (B : Type) (C : Type) (s : A -> B -> C) (g : A -> B) (a : A) =>
    s (g a) a
