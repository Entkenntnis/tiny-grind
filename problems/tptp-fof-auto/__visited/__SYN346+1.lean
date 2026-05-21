theorem SYN346_plus_1 : (_U : Type) -> (p_big_f_2 : _U -> _U -> Prop) -> (X1 : _U) -> (X2 : _U) -> @Exists _U (fun (Y1 : _U) => @Exists _U (fun (Y2 : _U) => (Z1 : _U) -> (Z2 : _U) -> p_big_f_2 X2 Z1 -> p_big_f_2 Y1 Z2 -> Or (And (p_big_f_2 Y1 Z1) (p_big_f_2 Y2 Z1)) (And (p_big_f_2 X2 Z2) (p_big_f_2 Y2 Z2)))) :=
  by grind

