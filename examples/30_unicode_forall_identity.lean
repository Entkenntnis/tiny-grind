-- Unicode quantifiers and lambdas with reusable lemmas.
def p30_id_forall : ∀ (A : Type), A -> A :=
  λ (A : Type) (x : A) => x

def p30_apply_forall : ∀ (A : Type), A -> A :=
  λ (A : Type) (x : A) =>
    p30_id_forall A x

def p30_unicode_final : (A : Type) -> A -> A :=
  λ (A : Type) (x : A) =>
    p30_apply_forall A x
