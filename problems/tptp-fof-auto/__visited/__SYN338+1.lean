theorem SYN338_plus_1 : (_U : Type) -> (p_big_f_2 : _U -> _U -> Prop) -> @Exists _U (fun (X : _U) => (Y : _U) -> @Exists _U (fun (Z : _U) => p_big_f_2 X Y -> p_big_f_2 Z X -> p_big_f_2 Y Y)) :=
  by grind

