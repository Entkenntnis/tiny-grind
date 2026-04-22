def demo_bad_type_identity_target : (A : Type) -> A -> Type :=
  fun (A : Type) (x : A) => x
