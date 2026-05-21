theorem SYN334_plus_1 : (_U : Type) -> (p_big_f_2 : _U -> _U -> Prop) -> (p_big_g_2 : _U -> _U -> Prop) -> @Exists _U (fun (X : _U) => @Exists _U (fun (Y : _U) => (Z : _U) -> (p_big_f_2 X Y -> Iff (p_big_f_2 X Z) (p_big_g_2 Y Z)) -> Iff (p_big_f_2 X Y) (p_big_f_2 Z Z -> p_big_g_2 Z Z) -> Iff (p_big_g_2 X Y) (p_big_g_2 Z Z))) :=
  by grind

