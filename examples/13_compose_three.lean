def demo2_compose_three :
  (A : Type) -> (B : Type) -> (C : Type) -> (D : Type) ->
  (C -> D) -> (B -> C) -> (A -> B) -> A -> D :=
  fun (A : Type) (B : Type) (C : Type) (D : Type)
      (cd : C -> D) (bc : B -> C) (ab : A -> B) (a : A) =>
    cd (bc (ab a))
