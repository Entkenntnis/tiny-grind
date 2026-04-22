def f32_dep_apply :
  (A : Type) -> (B : A -> Type) -> ((x : A) -> B x) -> (x : A) -> B x :=
  fun (A : Type) (B : A -> Type) (h : (x : A) -> B x) (x : A) =>
    h x

def f32_non_dep_view :
  (A : Type) -> (B : A -> Type) -> (y : A) -> (A -> B y) -> A -> B y :=
  fun (A : Type) (B : A -> Type) (y : A) (h : A -> B y) (x : A) =>
    h x

def f32_bad_used_binder :
  (A : Type) -> (B : A -> Type) -> (y : A) -> ((x : A) -> B x) -> B y :=
  fun (A : Type) (B : A -> Type) (y : A) (f : (x : A) -> B x) =>
    ((fun (h : A -> B y) => h y) f)

