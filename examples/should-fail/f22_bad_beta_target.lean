def demo3_bad_beta_target : (A : Type) -> A -> A :=
  fun (A : Type) (x : A) =>
    ((fun (f : A -> A) => f) (fun (z : A) => z)) (fun (u : A) => u)
