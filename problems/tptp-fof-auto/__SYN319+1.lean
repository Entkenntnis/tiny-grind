theorem SYN319_plus_1 : (_U : Type) -> (p_big_f_1 : _U -> Prop) -> (p_big_g_1 : _U -> Prop) -> (p_big_h_1 : _U -> Prop) -> @Exists _U (fun (X : _U) => @Exists _U (fun (Y : _U) => (Z1 : _U) -> (Z2 : _U) -> ((p_big_f_1 Y -> p_big_g_1 Z1) -> And (p_big_g_1 X) (Not (p_big_f_1 Z1))) -> (Or (p_big_f_1 X) (p_big_g_1 X) -> p_big_h_1 X) -> And (p_big_h_1 Z2) (p_big_h_1 Y -> Or (p_big_f_1 Z2) (p_big_g_1 Z2) -> p_big_h_1 Z2))) :=
  by grind

