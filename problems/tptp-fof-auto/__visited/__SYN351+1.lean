theorem SYN351_plus_1 : (_U : Type) -> (p_big_f_4 : _U -> _U -> _U -> _U -> Prop) -> (X1 : _U) -> (X2 : _U) -> @Exists _U (fun (Y1 : _U) => @Exists _U (fun (Y2 : _U) => (Z : _U) -> p_big_f_4 X1 Y2 X1 Z -> Iff (p_big_f_4 X1 Y1 X1 Y2) (p_big_f_4 Y1 X2 Y1 Y2) -> p_big_f_4 X1 Y1 X1 Y2 -> And (p_big_f_4 X1 Y2 Y1 Y2 -> p_big_f_4 X1 Z Y1 Z) (p_big_f_4 X1 Z Y1 Z -> Iff (p_big_f_4 X1 Y1 X1 Y2) (p_big_f_4 X1 Y2 Y1 Y2)))) :=
  by grind

