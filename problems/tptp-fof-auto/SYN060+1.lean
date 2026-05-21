theorem SYN060_plus_1 : (_U : Type) -> (p_big_f_1 : _U -> Prop) -> (p_big_g_1 : _U -> Prop) -> (p_big_h_1 : _U -> Prop) -> (p_big_i_1 : _U -> Prop) -> (pel30_1 : (X : _U) -> Or (p_big_f_1 X) (p_big_g_1 X) -> Not (p_big_h_1 X)) -> (pel30_2 : (X : _U) -> (p_big_g_1 X -> Not (p_big_i_1 X)) -> And (p_big_f_1 X) (p_big_h_1 X)) -> (X : _U) -> p_big_i_1 X :=
  by grind

