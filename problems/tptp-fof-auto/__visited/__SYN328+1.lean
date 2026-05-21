theorem SYN328_plus_1 : (_U : Type) -> (p_big_f_1 : _U -> Prop) -> (p_big_g_1 : _U -> Prop) -> (p_big_h_1 : _U -> Prop) -> @Exists _U (fun (X : _U) => (Y : _U) -> (Z : _U) -> Iff (p_big_f_1 Y -> p_big_g_1 Y) (p_big_f_1 X) -> Iff (p_big_f_1 Y -> p_big_h_1 Y) (p_big_g_1 X) -> Iff ((p_big_f_1 Y -> p_big_g_1 Y) -> p_big_h_1 Y) (p_big_h_1 X) -> And (And (p_big_f_1 Z) (p_big_g_1 Z)) (p_big_h_1 Z)) :=
  by grind

