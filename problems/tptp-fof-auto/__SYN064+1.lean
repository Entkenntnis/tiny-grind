theorem SYN064_plus_1 : (_U : Type) -> (p_big_p_2 : _U -> _U -> Prop) -> @Exists _U (fun (X : _U) => @Exists _U (fun (Y : _U) => p_big_p_2 X Y -> (Z : _U) -> (W : _U) -> p_big_p_2 Z W)) :=
  by grind

