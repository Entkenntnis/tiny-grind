theorem SYN976_plus_1 : (_U : Type) -> (p_f_0 : Prop) -> (p_g_0 : Prop) -> (p_p_1 : _U -> Prop) -> (p_q_1 : _U -> Prop) -> (A : _U) -> And (Or p_f_0 p_g_0) ((X : _U) -> And (p_p_1 X) (p_q_1 X)) -> p_q_1 A :=
  by grind

