-- Explicit forall binders mixed with arrow notation.
def p32_forall_map : ∀ (A : Type), ((x : A) -> A) -> A -> A :=
  λ (A : Type) (f : (x : A) -> A) (x : A) =>
    f x

def p32_arrow_map : (A : Type) -> (A -> A) -> A -> A :=
  fun (A : Type) (f : A -> A) (x : A) =>
    f x

def p32_pipeline : ∀ (A : Type), ((x : A) -> A) -> A -> A :=
  λ (A : Type) (f : (x : A) -> A) (x : A) =>
    p32_arrow_map A f x

