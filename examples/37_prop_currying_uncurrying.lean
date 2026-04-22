def p37_step :
  (P : Prop) -> (Q : Prop) -> (P -> Q) -> P -> Q :=
  fun (P : Prop) (Q : Prop) (hpq : P -> Q) (p : P) =>
    hpq p

def p37_chain4 :
  (P : Prop) -> (Q : Prop) -> (R : Prop) -> (S : Prop) ->
  (P -> Q) -> (Q -> R) -> (R -> S) -> P -> S :=
  fun (P : Prop) (Q : Prop) (R : Prop) (S : Prop)
      (hpq : P -> Q) (hqr : Q -> R) (hrs : R -> S) (p : P) =>
    hrs (hqr (p37_step P Q hpq p))

def p37_currying_final :
  (P : Prop) -> (Q : Prop) -> (R : Prop) -> (S : Prop) ->
  (P -> Q) -> (Q -> R) -> (R -> S) -> P -> S :=
  fun (P : Prop) (Q : Prop) (R : Prop) (S : Prop)
      (hpq : P -> Q) (hqr : Q -> R) (hrs : R -> S) (p : P) =>
    p37_chain4 P Q R S hpq hqr hrs p

