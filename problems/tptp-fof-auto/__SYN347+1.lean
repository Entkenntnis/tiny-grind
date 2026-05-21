theorem SYN347_plus_1 : (_U : Type) -> (p_big_f_2 : _U -> _U -> Prop) -> (Z1 : _U) -> (Z2 : _U) -> @Exists _U (fun (X1 : _U) => @Exists _U (fun (X2 : _U) => (Y : _U) -> Or (Iff (Iff (p_big_f_2 X1 Y) (p_big_f_2 X2 Y)) (p_big_f_2 Z1 Z2)) (Iff (p_big_f_2 Z1 Y) (p_big_f_2 Z2 Y)))) :=
  by grind

