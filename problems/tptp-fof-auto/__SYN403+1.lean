theorem SYN403_plus_1 : (_U : Type) -> (p_f_1 : _U -> Prop) -> (p_g_1 : _U -> Prop) -> (p_h_1 : _U -> Prop) -> (X : _U) -> And (p_f_1 X -> p_g_1 X) (p_g_1 X -> p_h_1 X) -> p_f_1 X -> p_h_1 X :=
  by grind

