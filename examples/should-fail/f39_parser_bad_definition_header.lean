def f39_ok_id : (A : Type) -> A -> A :=
  fun (A : Type) (x : A) => x

def f39_ok_comp :
  (A : Type) -> (B : Type) -> (C : Type) -> (B -> C) -> (A -> B) -> A -> C :=
  fun (A : Type) (B : Type) (C : Type) (g : B -> C) (f : A -> B) (x : A) =>
    g (f x)

def f39_bad_header (A : Type) -> A -> A :=
  fun (A : Type) (x : A) => x
