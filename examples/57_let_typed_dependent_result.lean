def p57_let_typed_dep :
  (A : Type) -> (x : A) -> @Eq A x x :=
  fun (A : Type) (x : A) =>
    let y : A := x; @Eq.refl A y
