theorem SYN969_plus_1 : (_U : Type) -> (p_p_1 : _U -> Prop) -> (p_q_1 : _U -> Prop) -> (p_r_1 : _U -> Prop) -> (B : _U) -> ((X : _U) -> And (p_p_1 X -> p_q_1 X) (p_r_1 B)) -> (Y : _U) -> (p_r_1 Y -> p_p_1 Y) -> p_q_1 B :=
  by grind

