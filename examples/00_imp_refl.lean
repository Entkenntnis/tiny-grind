def demo_imp_refl : (P : Prop) -> P -> P :=
  fun (P : Prop) (p : P) => p
