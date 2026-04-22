def f33_dep_eval :
  (A : Type) -> (B : A -> Type) -> ((x : A) -> B x) -> (x : A) -> B x :=
  fun (A : Type) (B : A -> Type) (h : (x : A) -> B x) (x : A) =>
    h x

def f33_two_index_goal :
  (A : Type) -> (B : A -> Type) -> (x : A) -> (y : A) -> ((z : A) -> B z) -> B y :=
  fun (A : Type) (B : A -> Type) (x : A) (y : A) (h : (z : A) -> B z) =>
    h y

def f33_bad_shadow_target :
  (A : Type) -> (B : A -> Type) -> (x : A) -> (y : A) -> ((z : A) -> B z) -> B y :=
  fun (A : Type) (B : A -> Type) (x : A) (y : A) (h : (z : A) -> B z) =>
    h x

