theorem SYN979_plus_1 : (_U : Type) -> (p_q_1 : _U -> Prop) -> (p_p_2 : _U -> _U -> Prop) -> (p_r_1 : _U -> Prop) -> (p_s_1 : _U -> Prop) -> (A : _U) -> (B : _U) -> @Exists _U (fun (X : _U) => @Exists _U (fun (Y : _U) => And (And (And (And (And (And (And (p_q_1 X -> p_p_2 X A) (p_q_1 A)) (p_q_1 B)) (p_r_1 Y -> p_p_2 B Y)) (p_r_1 A)) (p_r_1 B)) (p_s_1 A -> p_p_2 X Y)) (p_s_1 A) -> p_p_2 A B)) :=
  by grind

