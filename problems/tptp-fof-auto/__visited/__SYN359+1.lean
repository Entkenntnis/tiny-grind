theorem SYN359_plus_1 : (_U : Type) -> (p_big_r_1 : _U -> Prop) -> (p_big_q_2 : _U -> _U -> Prop) -> @Exists _U (fun (X : _U) => And (p_big_r_1 X) ((Y : _U) -> And (p_big_r_1 Y -> @Exists _U (fun (Z : _U) => p_big_q_2 Y Z)) ((X : _U) -> (Y : _U) -> p_big_q_2 X Y -> p_big_q_2 X X))) -> @Exists _U (fun (X : _U) => @Exists _U (fun (Y : _U) => And (p_big_q_2 X Y) (p_big_r_1 Y))) :=
  by grind

