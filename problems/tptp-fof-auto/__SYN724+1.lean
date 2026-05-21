theorem SYN724_plus_1 : (_U : Type) -> (p_r_1 : _U -> Prop) -> (p_s_1 : _U -> Prop) -> (X : _U) -> Iff (p_r_1 X -> p_s_1 X) ((X : _U) -> Iff (And (p_r_1 X) (p_s_1 X)) (p_r_1 X)) :=
  by grind

