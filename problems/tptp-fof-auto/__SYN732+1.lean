theorem SYN732_plus_1 : (_U : Type) -> (p_p_2 : _U -> _U -> Prop) -> (p_q_2 : _U -> _U -> Prop) -> (Y : _U) -> ((X : _U) -> p_p_2 X Y -> (U : _U) -> p_q_2 U Y) -> @Exists _U (fun (Z : _U) => @Exists _U (fun (V : _U) => p_p_2 V Z -> @Exists _U (fun (W : _U) => Or (p_p_2 Z W) (p_q_2 W Z)))) :=
  by grind

