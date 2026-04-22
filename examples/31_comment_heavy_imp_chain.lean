-- A comment-heavy implication chain test.
def p31_step_mp : (P : Prop) -> (Q : Prop) -> (P -> Q) -> P -> Q :=
  fun (P : Prop) (Q : Prop) (hpq : P -> Q) (p : P) => hpq p

-- Reusing the same shape for a second hop.
def p31_step_qr : (Q : Prop) -> (R : Prop) -> (Q -> R) -> Q -> R :=
  fun (Q : Prop) (R : Prop) (hqr : Q -> R) (q : Q) => hqr q

-- Final transitive chain from P to R.
def p31_comment_chain :
  (P : Prop) -> (Q : Prop) -> (R : Prop) -> (P -> Q) -> (Q -> R) -> P -> R :=
  fun (P : Prop) (Q : Prop) (R : Prop) (hpq : P -> Q) (hqr : Q -> R) (p : P) =>
    p31_step_qr Q R hqr (p31_step_mp P Q hpq p)

