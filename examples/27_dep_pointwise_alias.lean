def demo3_dep_pointwise_alias :
  (A : Type) -> (B : A -> Type) -> ((x : A) -> B x) -> (x : A) -> B x :=
  fun (A : Type) (B : A -> Type) (f : (y : A) -> B y) (x : A) =>
    f x
