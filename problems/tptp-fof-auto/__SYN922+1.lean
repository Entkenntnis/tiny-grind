theorem SYN922_plus_1 : (_U : Type) -> (p_p_1 : _U -> Prop) -> (p_q_1 : _U -> Prop) -> (X : _U) -> Iff (And (p_p_1 X) (p_q_1 X)) ((X : _U) -> And (p_p_1 X) ((X : _U) -> p_q_1 X)) :=
  by grind

