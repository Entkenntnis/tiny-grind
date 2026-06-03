theorem SYN068_plus_1 : (_U : Type) -> (p_big_f_1 : _U -> Prop) -> (p_big_g_1 : _U -> Prop) -> (p_big_h_2 : _U -> _U -> Prop) -> (p_big_j_1 : _U -> Prop) -> (pel44_1 : (X : _U) -> p_big_f_1 X -> @Exists _U (fun (Y : _U) => And (And (p_big_g_1 Y) (p_big_h_2 X Y)) (@Exists _U (fun (Y1 : _U) => And (p_big_g_1 Y1) (Not (p_big_h_2 X Y1)))))) -> (pel44_2 : @Exists _U (fun (X : _U) => And (p_big_j_1 X) ((Y : _U) -> p_big_g_1 Y -> p_big_h_2 X Y))) -> @Exists _U (fun (X : _U) => And (p_big_j_1 X) (Not (p_big_f_1 X))) :=
  by grind

