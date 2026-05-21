theorem SYN061_plus_1 : (_U : Type) -> (p_big_f_1 : _U -> Prop) -> (p_big_g_1 : _U -> Prop) -> (p_big_h_1 : _U -> Prop) -> (p_big_i_1 : _U -> Prop) -> (p_big_j_1 : _U -> Prop) -> (pel31_1 : Not (@Exists _U (fun (X : _U) => And (p_big_f_1 X) (Or (p_big_g_1 X) (p_big_h_1 X))))) -> (pel31_2 : @Exists _U (fun (X : _U) => And (p_big_i_1 X) (p_big_f_1 X))) -> (pel31_3 : (X : _U) -> Not (p_big_h_1 X) -> p_big_j_1 X) -> @Exists _U (fun (X : _U) => And (p_big_i_1 X) (p_big_j_1 X)) :=
  by grind

