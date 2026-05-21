theorem SYN365_plus_1 : (_U : Type) -> (f_g_1 : _U -> _U) -> (f_h_1 : _U -> _U) -> (p_big_p_1 : _U -> Prop) -> (p_big_r_2 : _U -> _U -> Prop) -> ((X : _U) -> @Exists _U (fun (Y : _U) => And (p_big_p_1 X -> And (p_big_r_2 X (f_g_1 (f_h_1 Y))) (p_big_p_1 Y)) ((W : _U) -> p_big_p_1 W -> And (p_big_p_1 (f_g_1 W)) (p_big_p_1 (f_h_1 W))))) -> (X : _U) -> p_big_p_1 X -> @Exists _U (fun (Y : _U) => And (p_big_r_2 X Y) (p_big_p_1 Y)) :=
  by grind

