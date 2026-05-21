theorem SYN930_plus_1 : (_U : Type) -> (p_p_1 : _U -> Prop) -> (p_c_0 : Prop) -> (X : _U) -> Iff (Or (p_p_1 X) p_c_0) ((X : _U) -> Or (p_p_1 X) p_c_0) :=
  by grind

