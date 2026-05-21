theorem SYN354_plus_1 : (_U : Type) -> (p_big_f_2 : _U -> _U -> Prop) -> (p_big_g_2 : _U -> _U -> Prop) -> (X1 : _U) -> (X2 : _U) -> @Exists _U (fun (Y1 : _U) => @Exists _U (fun (Y2 : _U) => (Z : _U) -> p_big_f_2 X1 X2 -> p_big_g_2 X1 X2 -> (Iff (p_big_g_2 X2 Z) (p_big_g_2 Y2 Z) -> p_big_f_2 Y1 Y2 -> p_big_f_2 X2 Y2) -> Iff (p_big_g_2 X2 Z) (p_big_g_2 Y1 Z) -> And (And (p_big_f_2 X1 Y1) (p_big_f_2 X2 Y1)) (p_big_f_2 Y1 Y2))) :=
  by grind

