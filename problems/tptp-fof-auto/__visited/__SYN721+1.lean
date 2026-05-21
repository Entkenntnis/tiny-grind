theorem SYN721_plus_1 : (_U : Type) -> (f_a_0 : _U) -> (f_b_0 : _U) -> (p_r_2 : _U -> _U -> Prop) -> (p_q_2 : _U -> _U -> Prop) -> And (p_r_2 f_a_0 f_b_0) ((X : _U) -> And (@Exists _U (fun (Y : _U) => p_r_2 X Y -> p_q_2 X X)) ((U : _U) -> (V : _U) -> p_q_2 U V -> (Z : _U) -> p_r_2 Z V)) -> @Exists _U (fun (W : _U) => And (p_r_2 f_b_0 W) (p_q_2 W f_a_0)) :=
  by grind

