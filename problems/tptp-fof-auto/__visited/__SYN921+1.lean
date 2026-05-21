theorem SYN921_plus_1 : (_U : Type) -> (p_p_1 : _U -> Prop) -> (p_q_1 : _U -> Prop) -> @Exists _U (fun (X : _U) => (Y : _U) -> (p_p_1 Y -> p_q_1 X) -> p_p_1 X -> p_q_1 X) :=
  by grind

