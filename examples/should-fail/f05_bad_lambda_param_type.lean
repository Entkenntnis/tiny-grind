def demo_bad_lambda_param_type : (A : Type) -> A -> A :=
  fun (A : Prop) (x : A) => x
