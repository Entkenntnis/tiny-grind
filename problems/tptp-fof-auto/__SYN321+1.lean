theorem SYN321_plus_1 : (_U : Type) -> (p_big_f_2 : _U -> _U -> Prop) -> (p_big_g_2 : _U -> _U -> Prop) -> @Exists _U (fun (X : _U) => @Exists _U (fun (Y : _U) => @Exists _U (fun (Z : _U) => p_big_f_2 X Z -> (Z : _U) -> p_big_g_2 X Z) -> (Z : _U) -> (p_big_g_2 Z Z -> p_big_f_2 Z Y) -> Iff (p_big_f_2 X Y) ((Z : _U) -> p_big_g_2 X Z))) :=
  by grind

