theorem SYN398_plus_1 : (_U : Type) -> (p_p_0 : Prop) -> (p_f_1 : _U -> Prop) -> (X : _U) -> Iff (And p_p_0 (p_f_1 X)) (And p_p_0 ((Y : _U) -> p_f_1 Y)) :=
  by grind

