def p38_I : (A : Type) -> A -> A :=
  fun (A : Type) (x : A) => x

def p38_K : (A : Type) -> (B : Type) -> A -> B -> A :=
  fun (A : Type) (B : Type) (a : A) (b : B) => a

def p38_B :
  (A : Type) -> (B : Type) -> (C : Type) -> (B -> C) -> (A -> B) -> A -> C :=
  fun (A : Type) (B : Type) (C : Type) (g : B -> C) (f : A -> B) (x : A) =>
    g (f x)

def p38_bundle_final : (A : Type) -> A -> A :=
  fun (A : Type) (x : A) =>
    p38_B A A A (p38_I A) (p38_I A) x

