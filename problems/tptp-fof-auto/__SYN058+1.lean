theorem SYN058_plus_1 : (_U : Type) -> (p_big_p_1 : _U -> Prop) -> (p_big_q_1 : _U -> Prop) -> (p_big_r_1 : _U -> Prop) -> (p_big_s_1 : _U -> Prop) -> (p_big_f_1 : _U -> Prop) -> (p_big_g_1 : _U -> Prop) -> (pel28_1 : (X : _U) -> p_big_p_1 X -> (Z : _U) -> p_big_q_1 Z) -> (pel28_2 : (X : _U) -> Or (p_big_q_1 X) (p_big_r_1 X) -> @Exists _U (fun (X1 : _U) => And (p_big_q_1 X1) (p_big_s_1 X1))) -> (pel28_3 : @Exists _U (fun (X : _U) => p_big_s_1 X -> (X1 : _U) -> p_big_f_1 X1 -> p_big_g_1 X1)) -> (X : _U) -> And (p_big_p_1 X) (p_big_f_1 X) -> p_big_g_1 X :=
  by grind

