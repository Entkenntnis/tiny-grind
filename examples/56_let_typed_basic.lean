def p56_let_typed_id : (A : Type) -> A -> A :=
  fun (A : Type) (x : A) =>
    let y : A := x; y

def p56_let_typed_chain : (A : Type) -> A -> A :=
  fun (A : Type) (x : A) =>
    let y : A := x; let z : A := y; z
