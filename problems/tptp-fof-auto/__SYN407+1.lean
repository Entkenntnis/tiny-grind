theorem SYN407_plus_1 : (_U : Type) -> (p_f_1 : _U -> Prop) -> (p_g_1 : _U -> Prop) -> (p_h_1 : _U -> Prop) -> (X : _U) -> (p_f_1 X -> Or (p_g_1 X) (p_h_1 X)) -> (Y : _U) -> Or (p_f_1 Y -> p_g_1 Y) (@Exists _U (fun (Z : _U) => And (p_f_1 Z) (p_h_1 Z))) :=
  by grind

