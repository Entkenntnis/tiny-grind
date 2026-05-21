theorem SYN352_plus_1 : (_U : Type) -> (p_big_f_2 : _U -> _U -> Prop) -> (X1 : _U) -> (X2 : _U) -> @Exists _U (fun (Y1 : _U) => @Exists _U (fun (Y2 : _U) => (Z : _U) -> p_big_f_2 X1 X2 -> (p_big_f_2 Y1 Y2 -> Or (p_big_f_2 X2 Z) (p_big_f_2 Y2 Z)) -> ((p_big_f_2 Y1 Y2 -> Iff (p_big_f_2 X2 Z) (p_big_f_2 Y1 Z)) -> p_big_f_2 Z Z) -> And (p_big_f_2 Y1 Y2) (Iff (p_big_f_2 Y1 Z) (p_big_f_2 Y2 Z)))) :=
  by grind

