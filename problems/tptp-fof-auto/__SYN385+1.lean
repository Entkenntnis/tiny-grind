theorem SYN385_plus_1 : (_U : Type) -> (p_big_p_1 : _U -> Prop) -> (p_big_q_1 : _U -> Prop) -> @Exists _U (fun (X : _U) => (Y : _U) -> p_big_p_1 X -> Or (p_big_q_1 X) (p_big_p_1 Y)) :=
  by grind

