theorem SYN362_plus_1 : (_U : Type) -> (p_big_r_2 : _U -> _U -> Prop) -> (p_big_p_1 : _U -> Prop) -> ((Y : _U) -> @Exists _U (fun (W : _U) => And (p_big_r_2 Y W) (@Exists _U (fun (Z : _U) => (X : _U) -> p_big_p_1 X -> Not (p_big_r_2 Z X))))) -> @Exists _U (fun (X : _U) => Not (p_big_p_1 X)) :=
  by grind

