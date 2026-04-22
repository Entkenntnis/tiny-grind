def ImpredicativeAnd : Prop -> Prop -> Prop :=
  fun (A : Prop) (B : Prop) =>
    forall (C : Prop), (A -> B -> C) -> C