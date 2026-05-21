theorem SYN940_plus_1 : (_U : Type) -> (f_f_1 : _U -> _U) -> (p_q_1 : _U -> Prop) -> (p_p_1 : _U -> Prop) -> (p_r_1 : _U -> Prop) -> (B : _U) -> (C : _U) -> (Z : _U) -> p_q_1 (f_f_1 Z) -> @Exists _U (fun (X : _U) => @Exists _U (fun (Y : _U) => And (p_p_1 (f_f_1 Y) -> And (p_p_1 X) (p_r_1 Y -> And (p_r_1 B) (p_r_1 C))) (p_q_1 X))) :=
  by grind

