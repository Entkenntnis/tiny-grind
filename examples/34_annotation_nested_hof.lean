def p34_id : (A : Type) -> A -> A :=
  fun (A : Type) (x : A) => x

def p34_comp :
  (A : Type) -> (B : Type) -> (C : Type) -> (B -> C) -> (A -> B) -> A -> C :=
  fun (A : Type) (B : Type) (C : Type) (g : B -> C) (f : A -> B) (x : A) =>
    g (f x)

def p34_annotated_comp :
  (A : Type) -> (B : Type) -> (C : Type) -> (B -> C) -> (A -> B) -> A -> C :=
  ((fun (A : Type) (B : Type) (C : Type) (g : B -> C) (f : A -> B) (x : A) =>
      p34_comp A B C g f x) :
    ((X : Type) -> (Y : Type) -> (Z : Type) -> (Y -> Z) -> (X -> Y) -> X -> Z))

