def demo2_dep_flip :
  (A : Type) -> (B : Type) -> (C : A -> B -> Type) ->
  ((x : A) -> (y : B) -> C x y) -> (y : B) -> (x : A) -> C x y :=
  fun (A : Type) (B : Type) (C : A -> B -> Type)
      (h : (x : A) -> (y : B) -> C x y) (y : B) (x : A) =>
    h x y
