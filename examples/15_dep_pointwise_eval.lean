def demo2_dep_pointwise_eval :
  (A : Type) -> (B : A -> Type) -> ((x : A) -> B x) -> (x : A) -> B x :=
  fun (A : Type) (B : A -> Type) (f : (x : A) -> B x) (x : A) =>
    f x
