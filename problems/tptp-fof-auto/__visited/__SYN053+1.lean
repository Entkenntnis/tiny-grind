theorem SYN053_plus_1 : (_U : Type) -> (p_p_0 : Prop) -> (p_big_f_1 : _U -> Prop) -> (X : _U) -> Iff (Or p_p_0 (p_big_f_1 X)) (Or p_p_0 ((X1 : _U) -> p_big_f_1 X1)) :=
  by grind

