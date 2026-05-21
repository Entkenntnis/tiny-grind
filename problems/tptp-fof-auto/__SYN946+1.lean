theorem SYN946_plus_1 : (_U : Type) -> (p_p_1 : _U -> Prop) -> (p_q_1 : _U -> Prop) -> (p_r_1 : _U -> Prop) -> ((X : _U) -> And (p_p_1 X) (@Exists _U (fun (Y : _U) => p_q_1 Y))) -> @Exists _U (fun (Z : _U) => (Y : _U) -> Or (p_p_1 Y) (p_r_1 Z)) :=
  by grind

