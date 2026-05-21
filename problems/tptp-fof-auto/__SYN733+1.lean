theorem SYN733_plus_1 : (_U : Type) -> (p_p_1 : _U -> Prop) -> (p_q_1 : _U -> Prop) -> (X : _U) -> @Exists _U (fun (Y : _U) => And (p_p_1 X) (Or (p_q_1 Y) (p_q_1 X)) -> @Exists _U (fun (Z : _U) => And (p_p_1 Z) (p_q_1 Z))) :=
  by grind

