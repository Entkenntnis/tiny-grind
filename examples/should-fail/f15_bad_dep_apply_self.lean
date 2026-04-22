def demo2_bad_dep_apply_self :
  (A : Type) -> (B : A -> Type) -> ((x : A) -> B x) -> (x : A) -> B x :=
  fun (A : Type) (B : A -> Type) (f : (x : A) -> B x) (x : A) =>
    f (f x)
