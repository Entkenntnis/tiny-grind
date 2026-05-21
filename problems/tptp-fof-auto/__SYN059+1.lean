theorem SYN059_plus_1 : (_U : Type) -> (p_big_f_1 : _U -> Prop) -> (p_big_g_1 : _U -> Prop) -> (p_big_h_1 : _U -> Prop) -> (p_big_j_1 : _U -> Prop) -> (pel29_1 : @Exists _U (fun (X : _U) => p_big_f_1 X)) -> (pel29_2 : @Exists _U (fun (Y : _U) => p_big_g_1 Y)) -> Iff ((X : _U) -> And (p_big_f_1 X -> p_big_h_1 X) ((U : _U) -> p_big_g_1 U -> p_big_j_1 U)) ((W : _U) -> (Y : _U) -> And (p_big_f_1 W) (p_big_g_1 Y) -> And (p_big_h_1 W) (p_big_j_1 Y)) :=
  by grind

