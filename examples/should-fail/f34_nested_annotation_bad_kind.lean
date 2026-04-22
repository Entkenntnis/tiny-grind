def f34_id : (A : Type) -> A -> A :=
  fun (A : Type) (x : A) => x

def f34_comp :
  (A : Type) -> (B : Type) -> (C : Type) -> (B -> C) -> (A -> B) -> A -> C :=
  fun (A : Type) (B : Type) (C : Type) (g : B -> C) (f : A -> B) (x : A) =>
    g (f x)

def f34_bad_nested_annotation : (A : Type) -> A -> A :=
  fun (A : Type) (x : A) =>
    (x : (fun (T : Type) => T))

