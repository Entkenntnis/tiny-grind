theorem SYN406_plus_1 : (_U : Type) -> (p_f_1 : _U -> Prop) -> (p_g_1 : _U -> Prop) -> (p_h_1 : _U -> Prop) -> ((X : _U) -> And (p_f_1 X -> p_g_1 X) (@Exists _U (fun (Y : _U) => And (p_f_1 Y) (p_h_1 Y)))) -> @Exists _U (fun (Z : _U) => And (p_g_1 Z) (p_h_1 Z)) :=
  by grind

