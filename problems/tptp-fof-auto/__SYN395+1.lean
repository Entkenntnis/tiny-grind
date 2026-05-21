theorem SYN395_plus_1 : (_U : Type) -> (p_f_1 : _U -> Prop) -> (p_g_1 : _U -> Prop) -> (X : _U) -> (p_f_1 X -> p_g_1 X) -> @Exists _U (fun (Y : _U) => p_f_1 Y -> @Exists _U (fun (Z : _U) => p_g_1 Z)) :=
  by grind

