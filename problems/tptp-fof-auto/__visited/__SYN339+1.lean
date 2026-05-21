theorem SYN339_plus_1 : (_U : Type) -> (p_big_f_3 : _U -> _U -> _U -> Prop) -> @Exists _U (fun (X : _U) => (Y : _U) -> @Exists _U (fun (Z : _U) => p_big_f_3 X Y Z -> p_big_f_3 Y Z Z)) :=
  by grind

