theorem SYN062_plus_1 : (_U : Type) -> (p_big_f_1 : _U -> Prop) -> (p_big_g_1 : _U -> Prop) -> (p_big_h_1 : _U -> Prop) -> (p_big_i_1 : _U -> Prop) -> (p_big_j_1 : _U -> Prop) -> (p_big_k_1 : _U -> Prop) -> (pel32_1 : (X : _U) -> And (p_big_f_1 X) (Or (p_big_g_1 X) (p_big_h_1 X)) -> p_big_i_1 X) -> (pel32_2 : (X : _U) -> And (p_big_i_1 X) (p_big_h_1 X) -> p_big_j_1 X) -> (pel32_3 : (X : _U) -> p_big_k_1 X -> p_big_h_1 X) -> (X : _U) -> And (p_big_f_1 X) (p_big_k_1 X) -> p_big_j_1 X :=
  by grind

