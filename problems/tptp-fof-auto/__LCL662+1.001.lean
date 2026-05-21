theorem LCL662_plus_1_dot_001 : (_U : Type) -> (p_p1_1 : _U -> Prop) -> Not (@Exists _U (fun (X : _U) => Not (Or (Not (p_p1_1 X)) (p_p1_1 X)))) :=
  by grind

