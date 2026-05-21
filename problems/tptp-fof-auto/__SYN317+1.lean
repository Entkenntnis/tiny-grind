theorem SYN317_plus_1 : (_U : Type) -> (p_big_f_1 : _U -> Prop) -> (p_big_g_1 : _U -> Prop) -> @Exists _U (fun (X : _U) => Iff (p_big_f_1 X -> p_big_g_1 X) (@Exists _U (fun (X : _U) => @Exists _U (fun (Y : _U) => p_big_f_1 X -> p_big_g_1 Y)))) :=
  by grind

