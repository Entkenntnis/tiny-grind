theorem SYN049_plus_1 : (_U : Type) -> (p_big_p_1 : _U -> Prop) -> (p_big_q_1 : _U -> Prop) -> @Exists _U (fun (X : _U) => (Y : _U) -> (Z : _U) -> (p_big_p_1 Y -> p_big_q_1 Z) -> p_big_p_1 X -> p_big_q_1 X) :=
  by grind

