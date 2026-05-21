theorem SYN340_plus_1 : (_U : Type) -> (p_big_f_5 : _U -> _U -> _U -> _U -> _U -> Prop) -> @Exists _U (fun (X : _U) => (Y : _U) -> @Exists _U (fun (Z1 : _U) => @Exists _U (fun (Z2 : _U) => p_big_f_5 X Y Z1 Z2 Z1 -> p_big_f_5 Z1 X Y Z1 Z2))) :=
  by grind

