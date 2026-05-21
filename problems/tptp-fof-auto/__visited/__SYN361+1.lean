theorem SYN361_plus_1 : (_U : Type) -> (p_big_p_2 : _U -> _U -> Prop) -> (p_big_s_1 : _U -> Prop) -> (p_big_q_2 : _U -> _U -> Prop) -> @Exists _U (fun (V : _U) => (X : _U) -> And (p_big_p_2 X V) ((X : _U) -> And (p_big_s_1 X -> @Exists _U (fun (Y : _U) => p_big_q_2 Y X)) ((X : _U) -> (Y : _U) -> p_big_p_2 X Y -> Not (p_big_q_2 X Y)))) -> @Exists _U (fun (U : _U) => Not (p_big_s_1 U)) :=
  by grind

