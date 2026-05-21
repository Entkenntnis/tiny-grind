theorem SYN065_plus_1 : (_U : Type) -> (p_big_f_2 : _U -> _U -> Prop) -> (p_big_g_2 : _U -> _U -> Prop) -> (p_big_h_2 : _U -> _U -> Prop) -> (pel36_1 : (X : _U) -> @Exists _U (fun (Y : _U) => p_big_f_2 X Y)) -> (pel36_2 : (X : _U) -> @Exists _U (fun (Y : _U) => p_big_g_2 X Y)) -> (pel36_3 : (X : _U) -> (Y : _U) -> Or (p_big_f_2 X Y) (p_big_g_2 X Y) -> (Z : _U) -> Or (p_big_f_2 Y Z) (p_big_g_2 Y Z) -> p_big_h_2 X Z) -> (X : _U) -> @Exists _U (fun (Y : _U) => p_big_h_2 X Y) :=
  by grind

