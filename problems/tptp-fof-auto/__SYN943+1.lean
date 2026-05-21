theorem SYN943_plus_1 : (_U : Type) -> (f_f_1 : _U -> _U) -> (p_p_1 : _U -> Prop) -> (p_e_1 : _U -> Prop) -> (p_g_1 : _U -> Prop) -> (p_s_2 : _U -> _U -> Prop) -> (p_c_1 : _U -> Prop) -> (A : _U) -> @Exists _U (fun (X : _U) => @Exists _U (fun (X2 : _U) => @Exists _U (fun (X3 : _U) => @Exists _U (fun (X4 : _U) => @Exists _U (fun (Y : _U) => And (And (And (And (p_p_1 A) (p_e_1 A)) (p_e_1 X -> Or (p_g_1 X) (p_s_2 X (f_f_1 X)))) (p_e_1 X2 -> Or (p_g_1 X2) (p_c_1 (f_f_1 X2)))) (p_s_2 A Y -> p_p_1 Y) -> Or (And (p_p_1 X3) (p_g_1 X3)) (And (p_p_1 X4) (p_c_1 X4))))))) :=
  by grind

