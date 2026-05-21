theorem SYN360_plus_1 : (_U : Type) -> (p_big_p_2 : _U -> _U -> Prop) -> (p_big_q_2 : _U -> _U -> Prop) -> ((X : _U) -> And (@Exists _U (fun (Y : _U) => p_big_p_2 X Y -> (Y : _U) -> p_big_q_2 X Y)) ((Z : _U) -> @Exists _U (fun (Y : _U) => p_big_p_2 Z Y))) -> (Y : _U) -> (X : _U) -> p_big_q_2 X Y :=
  by grind

