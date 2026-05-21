theorem SYN380_plus_1 : (_U : Type) -> (p_big_r_2 : _U -> _U -> Prop) -> (p_big_q_2 : _U -> _U -> Prop) -> (W : _U) -> Not (p_big_r_2 W W) -> @Exists _U (fun (X : _U) => @Exists _U (fun (Y : _U) => And (Not (p_big_r_2 X Y)) (p_big_q_2 Y X -> (Z : _U) -> p_big_q_2 Z Z))) :=
  by grind

