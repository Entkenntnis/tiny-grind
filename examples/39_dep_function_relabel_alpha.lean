def p39_alpha_value :
  (A : Type) -> (B : A -> Type) -> ((x : A) -> B x) -> (x : A) -> B x :=
  fun (A : Type) (B : A -> Type) (g : (x : A) -> B x) (x : A) =>
    g x

def p39_alpha_annotated :
  (A : Type) -> (B : A -> Type) -> ((x : A) -> B x) -> (x : A) -> B x :=
  ((fun (A : Type) (B : A -> Type) (h : (u : A) -> B u) (t : A) =>
      h t) :
    ((T : Type) -> (F : T -> Type) -> ((y : T) -> F y) -> (z : T) -> F z))

def p39_alpha_final :
  (A : Type) -> (B : A -> Type) -> ((x : A) -> B x) -> (x : A) -> B x :=
  fun (A : Type) (B : A -> Type) (g : (x : A) -> B x) (x : A) =>
    p39_alpha_annotated A B g x
