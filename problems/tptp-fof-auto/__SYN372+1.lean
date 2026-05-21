theorem SYN372_plus_1 : (_U : Type) -> (p_big_p_1 : _U -> Prop) -> (p_big_q_1 : _U -> Prop) -> (X : _U) -> @Exists _U (fun (Y : _U) => (p_big_p_1 Y -> p_big_q_1 X) -> @Exists _U (fun (Y : _U) => p_big_p_1 Y -> p_big_q_1 Y)) :=
  by grind

