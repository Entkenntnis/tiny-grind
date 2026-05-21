theorem SYN722_plus_1 : (_U : Type) -> (f_c_0 : _U) -> (f_d_0 : _U) -> (f_a_0 : _U) -> (f_b_0 : _U) -> (p_p_1 : _U -> Prop) -> (p_r_1 : _U -> Prop) -> (p_q_1 : _U -> Prop) -> Not ((Z : _U) -> And (And (Or (p_p_1 Z) (p_r_1 Z)) (p_q_1 Z)) ((X : _U) -> @Exists _U (fun (Y : _U) => And (Or (Or (Or (Or (p_p_1 X) (Not (p_q_1 X))) (Not (p_q_1 Y))) (Not (p_q_1 f_c_0))) (Not (p_q_1 f_d_0))) (Or (Not (p_p_1 f_a_0)) (Not (p_p_1 f_b_0)))))) :=
  by grind

