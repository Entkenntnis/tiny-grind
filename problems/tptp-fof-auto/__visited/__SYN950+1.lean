theorem SYN950_plus_1 : (_U : Type) -> (p_q_1 : _U -> Prop) -> (p_p_1 : _U -> Prop) -> (A : _U) -> (B : _U) -> (Y : _U) -> (p_q_1 Y -> p_p_1 Y) -> @Exists _U (fun (X : _U) => And (p_p_1 X -> p_p_1 A) (p_q_1 X -> p_p_1 B)) :=
  by grind

