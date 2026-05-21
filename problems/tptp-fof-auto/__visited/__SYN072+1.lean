theorem SYN072_plus_1 : (_U : Type) -> (f_a_0 : _U) -> (f_b_0 : _U) -> (p_big_p_1 : _U -> Prop) -> (pel49_1 : @Exists _U (fun (X : _U) => @Exists _U (fun (Y : _U) => (Z : _U) -> Or (@Eq _U Z X) (@Eq _U Z Y)))) -> (pel49_2 : p_big_p_1 f_a_0) -> (pel49_3 : p_big_p_1 f_b_0) -> (pel49_4 : Not (@Eq _U f_a_0 f_b_0)) -> (X : _U) -> p_big_p_1 X :=
  by grind

