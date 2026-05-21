theorem SYN336_plus_1 : (_U : Type) -> (p_big_f_2 : _U -> _U -> Prop) -> (X : _U) -> @Exists _U (fun (Y1 : _U) => @Exists _U (fun (Y2 : _U) => (Z : _U) -> p_big_f_2 X Z -> p_big_f_2 Y1 Z -> p_big_f_2 Y2 Z -> p_big_f_2 Y1 X -> p_big_f_2 Z Y2)) :=
  by grind

