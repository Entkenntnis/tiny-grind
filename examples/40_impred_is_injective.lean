def impred_IsInjective : (alpha : Type) -> (beta : Type) -> (f : alpha -> beta) -> Prop :=
  fun (alpha : Type) (beta : Type) (f : alpha -> beta) =>
    forall (a : alpha) (b : alpha), @Eq beta (f a) (f b) -> @Eq alpha a b