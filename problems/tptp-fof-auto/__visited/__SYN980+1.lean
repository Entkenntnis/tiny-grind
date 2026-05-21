theorem SYN980_plus_1 : (_U : Type) -> (f_f_1 : _U -> _U) -> (p_r_1 : _U -> Prop) -> (p_p_2 : _U -> _U -> Prop) -> (p_q_2 : _U -> _U -> Prop) -> (B : _U) -> (Y : _U) -> ((p_r_1 B -> p_r_1 Y) -> p_p_2 (f_f_1 Y) Y) -> @Exists _U (fun (X : _U) => @Exists _U (fun (Y : _U) => And (p_p_2 X Y) (p_q_2 (f_f_1 B) B -> p_q_2 X Y))) :=
  by grind

