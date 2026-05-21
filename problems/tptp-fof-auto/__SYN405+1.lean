theorem SYN405_plus_1 : (_U : Type) -> (p_f_1 : _U -> Prop) -> (p_g_1 : _U -> Prop) -> ((X : _U) -> And (p_f_1 X) (@Exists _U (fun (Y : _U) => p_g_1 Y))) -> @Exists _U (fun (Z : _U) => And (p_f_1 Z) (p_g_1 Z)) :=
  by grind

