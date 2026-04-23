def f44_parser_bad_let_missing_body : (A : Type) -> A -> A :=
  fun (A : Type) (x : A) =>
    let y : A := x
