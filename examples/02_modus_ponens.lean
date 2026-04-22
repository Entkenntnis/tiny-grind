def demo_modus_ponens : (P : Prop) -> (Q : Prop) -> (P -> Q) -> P -> Q :=
  fun (P : Prop) (Q : Prop) (h : P -> Q) (p : P) => h p
