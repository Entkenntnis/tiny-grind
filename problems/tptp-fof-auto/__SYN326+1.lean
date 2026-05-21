theorem SYN326_plus_1 : (_U : Type) -> (p_big_f_2 : _U -> _U -> Prop) -> (p_big_g_1 : _U -> Prop) -> (p_big_h_1 : _U -> Prop) -> @Exists _U (fun (X : _U) => (Y : _U) -> (Z : _U) -> ((p_big_f_2 Y Z -> p_big_g_1 Y -> p_big_h_1 X) -> p_big_f_2 X X) -> ((p_big_f_2 Z X -> p_big_g_1 X) -> p_big_h_1 Z) -> p_big_f_2 X Y -> p_big_f_2 Z Z) :=
  by grind

