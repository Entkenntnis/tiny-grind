theorem SYN942_plus_1 : (_U : Type) -> (p_a_1 : _U -> Prop) -> (p_b_1 : _U -> Prop) -> (p_c_1 : _U -> Prop) -> ((X : _U) -> And (p_a_1 X -> Or (p_b_1 X) (p_c_1 X)) (Not ((X : _U) -> p_a_1 X -> p_b_1 X))) -> @Exists _U (fun (X : _U) => And (p_a_1 X) (p_c_1 X)) :=
  by grind

