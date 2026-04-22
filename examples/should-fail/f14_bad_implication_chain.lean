def demo2_bad_implication_chain :
  (P : Prop) -> (Q : Prop) -> (R : Prop) ->
  (P -> Q -> R) -> (P -> Q) -> P -> R :=
  fun (P : Prop) (Q : Prop) (R : Prop)
      (hpqr : P -> Q -> R) (hpq : P -> Q) (p : P) =>
    hpq p
