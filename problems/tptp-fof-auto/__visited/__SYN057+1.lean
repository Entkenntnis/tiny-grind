theorem SYN057_plus_1 : (_U : Type) -> (p_big_f_1 : _U -> Prop) -> (p_big_g_1 : _U -> Prop) -> (p_big_h_1 : _U -> Prop) -> (p_big_j_1 : _U -> Prop) -> (p_big_i_1 : _U -> Prop) -> (pel27_1 : @Exists _U (fun (X : _U) => And (p_big_f_1 X) (Not (p_big_g_1 X)))) -> (pel27_2 : (X : _U) -> p_big_f_1 X -> p_big_h_1 X) -> (pel27_3 : (X : _U) -> And (p_big_j_1 X) (p_big_i_1 X) -> p_big_f_1 X) -> (pel27_4 : @Exists _U (fun (X : _U) => And (p_big_h_1 X) (Not (p_big_g_1 X)) -> (X1 : _U) -> p_big_i_1 X1 -> Not (p_big_h_1 X1))) -> (X : _U) -> p_big_j_1 X -> Not (p_big_i_1 X) :=
  by grind

