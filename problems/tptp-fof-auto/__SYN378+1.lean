theorem SYN378_plus_1 : (_U : Type) -> (p_big_p_1 : _U -> Prop) -> (p_big_q_1 : _U -> Prop) -> (X : _U) -> p_big_p_1 X -> Not (@Exists _U (fun (Y : _U) => Or (p_big_q_1 Y) (@Exists _U (fun (Z : _U) => p_big_p_1 Z -> p_big_q_1 Z)))) :=
  by grind

