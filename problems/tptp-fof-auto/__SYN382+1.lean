theorem SYN382_plus_1 : (_U : Type) -> (p_big_p_2 : _U -> _U -> Prop) -> (p_big_q_2 : _U -> _U -> Prop) -> (Z : _U) -> @Exists _U (fun (X : _U) => ((Y : _U) -> Or (p_big_p_2 X Y) (p_big_q_2 X Z)) -> (Y : _U) -> @Exists _U (fun (X : _U) => Or (p_big_p_2 X Y) (p_big_q_2 X Y))) :=
  by grind

