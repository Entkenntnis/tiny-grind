theorem SYN355_plus_1 : (_U : Type) -> (p_big_r_1 : _U -> Prop) -> (p_big_p_1 : _U -> Prop) -> (p_big_q_1 : _U -> Prop) -> ((X : _U) -> And (p_big_r_1 X -> p_big_p_1 X) ((X : _U) -> Not (p_big_q_1 X) -> p_big_r_1 X)) -> (X : _U) -> Or (p_big_p_1 X) (p_big_q_1 X) :=
  by grind

