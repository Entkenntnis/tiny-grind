def f30_id_forall : ∀ (A : Type), A -> A :=
  λ (A : Type) (x : A) => x

def f30_apply_forall : ∀ (A : Type), A -> A :=
  λ (A : Type) (x : A) =>
    f30_id_forall A x

def f30_bad_unicode_application : ∀ (A : Type), ((x : A) -> A) -> A -> A :=
  λ (A : Type) (f : (x : A) -> A) (x : A) =>
    f (λ (y : A) => y)

