def f38_ok_id : (A : Type) -> A -> A :=
  fun (A : Type) (x : A) => x

def f38_ok_apply :
  (A : Type) -> (A -> A) -> A -> A :=
  fun (A : Type) (f : A -> A) (x : A) => f x

def f38_bad_annotation : (A : Type) -> A -> A :=
  fun (A : Type) (x : A) =>
    ((x : A)

