def f37_ok_id : (A : Type) -> A -> A :=
  fun (A : Type) (x : A) => x

def f37_ok_k : (A : Type) -> (B : Type) -> A -> B -> A :=
  fun (A : Type) (B : Type) (a : A) (b : B) => a

def f37_bad_unicode :
  ∀ (A Type), A -> A :=
  λ (A : Type) (x : A) => x

