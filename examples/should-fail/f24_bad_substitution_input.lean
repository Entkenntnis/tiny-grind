def demo3_bad_substitution_input :
  (A : Type) -> (B : A -> Type) -> (x : A) -> ((y : A) -> B y) -> B x :=
  fun (A : Type) (B : A -> Type) (x : A) (h : (y : A) -> B y) =>
    h (fun (x : A) => x)
