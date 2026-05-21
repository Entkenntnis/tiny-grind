theorem SYN944_plus_1 : (_U : Type) -> (p_s_1 : _U -> Prop) -> (p_r_2 : _U -> _U -> Prop) -> (p_p_1 : _U -> Prop) -> (p_q_2 : _U -> _U -> Prop) -> (A : _U) -> (B : _U) -> (C : _U) -> And (And (And (p_s_1 A) (p_s_1 B)) (p_r_2 B C)) ((X : _U) -> And (p_s_1 X -> p_p_1 X) ((X : _U) -> (Y : _U) -> p_r_2 X Y -> p_q_2 X Y)) -> @Exists _U (fun (X : _U) => @Exists _U (fun (Y : _U) => And (p_p_1 X) (p_q_2 X Y))) :=
  by grind

