theorem SYN409_plus_1 : (_U : Type) -> (p_f_1 : _U -> Prop) -> (X : _U) -> Iff (p_f_1 X) ((Y : _U) -> (Z : _U) -> And (p_f_1 Y) (p_f_1 Z)) :=
  by grind

