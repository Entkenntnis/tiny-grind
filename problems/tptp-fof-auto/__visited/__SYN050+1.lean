theorem SYN050_plus_1 : (_U : Type) -> (p_big_p_1 : _U -> Prop) -> (p_big_q_1 : _U -> Prop) -> (p_big_r_1 : _U -> Prop) -> (p_big_s_1 : _U -> Prop) -> (X : _U) -> (Y : _U) -> @Exists _U (fun (Z : _U) => (W : _U) -> (And (p_big_p_1 X) (p_big_q_1 Y) -> And (p_big_r_1 Z) (p_big_s_1 W)) -> @Exists _U (fun (X1 : _U) => @Exists _U (fun (Y1 : _U) => And (p_big_p_1 X1) (p_big_q_1 Y1) -> @Exists _U (fun (Z1 : _U) => p_big_r_1 Z1)))) :=
  by grind

