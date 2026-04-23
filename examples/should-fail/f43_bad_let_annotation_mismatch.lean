def f43_bad_let_annotation_mismatch : (A : Type) -> A -> A :=
  fun (A : Type) (x : A) =>
    let y : Prop := x; x
