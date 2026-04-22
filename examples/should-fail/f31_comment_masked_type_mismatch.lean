-- Valid helper theorem.
def f31_step_mp : (P : Prop) -> (Q : Prop) -> (P -> Q) -> P -> Q :=
  fun (P : Prop) (Q : Prop) (hpq : P -> Q) (p : P) =>
    hpq p

-- Another valid helper.
def f31_keep_left : (P : Prop) -> (Q : Prop) -> P -> Q -> P :=
  fun (P : Prop) (Q : Prop) (p : P) (q : Q) => p

-- Intentionally wrong codomain in final theorem body.
def f31_bad_return_q : (P : Prop) -> (Q : Prop) -> (P -> Q) -> P -> Q :=
  fun (P : Prop) (Q : Prop) (hpq : P -> Q) (p : P) =>
    p

