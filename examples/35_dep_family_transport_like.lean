def p35_family_arrow : (A : Type) -> (A -> Type) -> Type :=
  fun (A : Type) (B : A -> Type) =>
    (x : A) -> B x

def p35_pointwise :
  (A : Type) -> (B : A -> Type) -> ((x : A) -> B x) -> (x : A) -> B x :=
  fun (A : Type) (B : A -> Type) (h : (x : A) -> B x) (x : A) =>
    h x

def p35_transport_like :
  (A : Type) -> (B : A -> Type) -> ((x : A) -> B x) -> (x : A) -> B x :=
  fun (A : Type) (B : A -> Type) (h : (x : A) -> B x) (x : A) =>
    p35_pointwise A B h x

