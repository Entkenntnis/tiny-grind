def demo2_bad_compose_order :
  (A : Type) -> (B : Type) -> (C : Type) -> (D : Type) ->
  (C -> D) -> (B -> C) -> (A -> B) -> A -> D :=
  fun (A : Type) (B : Type) (C : Type) (D : Type)
      (cd : C -> D) (bc : B -> C) (ab : A -> B) (a : A) =>
    bc (cd (ab a))
