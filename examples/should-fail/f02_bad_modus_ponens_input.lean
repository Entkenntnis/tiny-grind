def demo_bad_modus_ponens_input : (P : Prop) -> (Q : Prop) -> (P -> Q) -> Q :=
  fun (P : Prop) (Q : Prop) (h : P -> Q) => h Q
