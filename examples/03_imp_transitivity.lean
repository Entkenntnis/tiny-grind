def demo_imp_transitivity :
  (P : Prop) -> (Q : Prop) -> (R : Prop) -> (P -> Q) -> (Q -> R) -> P -> R :=
  fun (P : Prop) (Q : Prop) (R : Prop) (hpq : P -> Q) (hqr : Q -> R) (p : P) =>
    hqr (hpq p)
