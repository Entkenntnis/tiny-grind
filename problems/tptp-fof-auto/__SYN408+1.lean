theorem SYN408_plus_1 : (_U : Type) -> (p_f_1 : _U -> Prop) -> (p_g_1 : _U -> Prop) -> Not (@Exists _U (fun (X : _U) => p_f_1 X -> (Y : _U) -> p_f_1 Y -> p_g_1 Y)) :=
  by grind

