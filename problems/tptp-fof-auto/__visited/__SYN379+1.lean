theorem SYN379_plus_1 : (_U : Type) -> (p_big_p_1 : _U -> Prop) -> (p_big_q_3 : _U -> _U -> _U -> Prop) -> (X : _U) -> p_big_p_1 X -> @Exists _U (fun (Y : _U) => (X : _U) -> (Z : _U) -> p_big_q_3 X Y Z -> Not ((Z : _U) -> And (p_big_p_1 Z) (Not (p_big_q_3 Y Y Z)))) :=
  by grind

