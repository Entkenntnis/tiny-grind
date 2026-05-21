theorem SYN323_plus_1 : (_U : Type) -> (p_big_f_2 : _U -> _U -> Prop) -> (p_big_g_2 : _U -> _U -> Prop) -> @Exists _U (fun (Y : _U) => (X : _U) -> ((p_big_f_2 X Y -> p_big_f_2 Y X) -> p_big_g_2 X Y) -> Not ((X : _U) -> (p_big_f_2 X Y -> p_big_f_2 Y X) -> Not (p_big_g_2 X Y))) :=
  by grind

