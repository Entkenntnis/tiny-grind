theorem SYN056_plus_1 : (_U : Type) -> (p_big_p_1 : _U -> Prop) -> (p_big_q_1 : _U -> Prop) -> (p_big_r_1 : _U -> Prop) -> (p_big_s_1 : _U -> Prop) -> (pel26_1 : @Exists _U (fun (X : _U) => Iff (p_big_p_1 X) (@Exists _U (fun (Y : _U) => p_big_q_1 Y)))) -> (pel26_2 : (X : _U) -> (Y : _U) -> And (p_big_p_1 X) (p_big_q_1 Y) -> Iff (p_big_r_1 X) (p_big_s_1 Y)) -> (X : _U) -> Iff (p_big_p_1 X -> p_big_r_1 X) ((Y : _U) -> p_big_q_1 Y -> p_big_s_1 Y) :=
  by grind

