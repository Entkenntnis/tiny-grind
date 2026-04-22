def f35_pointwise :
  (A : Type) -> (B : A -> Type) -> ((x : A) -> B x) -> (x : A) -> B x :=
  fun (A : Type) (B : A -> Type) (h : (x : A) -> B x) (x : A) =>
    h x

def f35_choose_second :
  (A : Type) -> (B : A -> Type) -> (x : A) -> (y : A) -> ((z : A) -> B z) -> B y :=
  fun (A : Type) (B : A -> Type) (x : A) (y : A) (h : (z : A) -> B z) =>
    h y

def f35_bad_choose_first :
  (A : Type) -> (B : A -> Type) -> (x : A) -> (y : A) -> ((z : A) -> B z) -> B y :=
  fun (A : Type) (B : A -> Type) (x : A) (y : A) (h : (z : A) -> B z) =>
    f35_pointwise A B h x

