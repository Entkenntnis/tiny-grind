theorem SYN367_plus_1 : (_U : Type) -> (p_p_0 : Prop) -> (p_big_q_1 : _U -> Prop) -> (p_big_r_1 : _U -> Prop) -> (X : _U) -> Or (And p_p_0 (p_big_q_1 X)) (And (Not p_p_0) (p_big_r_1 X)) -> (X : _U) -> Or (p_big_q_1 X) ((X : _U) -> p_big_r_1 X) :=
  by grind

