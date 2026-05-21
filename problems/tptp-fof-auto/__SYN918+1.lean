theorem SYN918_plus_1 : (_U : Type) -> (p_f_1 : _U -> Prop) -> (p_g_1 : _U -> Prop) -> (p_h_1 : _U -> Prop) -> ((X : _U) -> And ((And (p_f_1 X) (p_g_1 X) -> p_h_1 X) -> @Exists _U (fun (Y : _U) => And (p_f_1 Y) (Not (p_g_1 Y)))) ((W : _U) -> Or (p_f_1 W -> p_g_1 W) ((Z : _U) -> p_f_1 Z -> p_h_1 Z))) -> (R : _U) -> (And (p_f_1 R) (p_h_1 R) -> p_g_1 R) -> @Exists _U (fun (V : _U) => And (And (p_f_1 V) (p_g_1 V)) (Not (p_h_1 V))) :=
  by grind

