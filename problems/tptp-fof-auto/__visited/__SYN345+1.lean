theorem SYN345_plus_1 : (_U : Type) -> (p_big_f_3 : _U -> _U -> _U -> Prop) -> (X1 : _U) -> (X2 : _U) -> @Exists _U (fun (Y1 : _U) => @Exists _U (fun (Y2 : _U) => (Z : _U) -> ((p_big_f_3 X1 X2 Y1 -> p_big_f_3 Y2 Y1 Z) -> p_big_f_3 X1 X1 X2 -> p_big_f_3 X1 X2 X2) -> ((p_big_f_3 X2 Y1 Y2 -> p_big_f_3 Y1 Z Z) -> p_big_f_3 X1 X2 X2 -> p_big_f_3 X1 X1 X2) -> p_big_f_3 Y1 Y2 Z -> And (p_big_f_3 X2 X2 Y1) (Iff (p_big_f_3 X1 X1 X2) (p_big_f_3 X1 X2 X2)))) :=
  by grind

