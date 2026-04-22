-- Dependent identities with beta steps under alpha-renamed binders.
def p33_dep_id :
  (A : Type) -> (B : A -> Type) -> (x : A) -> B x -> B x :=
  fun (A : Type) (B : A -> Type) (x : A) (bx : B x) => bx

def p33_beta_step :
  (A : Type) -> (B : A -> Type) -> ((x : A) -> B x) -> (x : A) -> B x :=
  fun (A : Type) (B : A -> Type) (f : (x : A) -> B x) =>
    f

def p33_beta_use :
  (A : Type) -> (B : A -> Type) -> ((x : A) -> B x) -> (x : A) -> B x :=
  fun (A : Type) (B : A -> Type) (f : (x : A) -> B x) (x : A) =>
    p33_beta_step A B f x

def p33_shadow_safe :
  (A : Type) -> (B : A -> Type) -> (x : A) -> ((y : A) -> B y) -> B x :=
  fun (A : Type) (B : A -> Type) (x : A) (g : (y : A) -> B y) =>
    g x
