theorem SYN341_plus_1 : (_U : Type) -> (p_big_f_3 : _U -> _U -> _U -> Prop) -> @Exists _U (fun (X1 : _U) => (X2 : _U) -> @Exists _U (fun (X3 : _U) => (X4 : _U) -> p_big_f_3 X1 X2 X3 -> p_big_f_3 X2 X3 X4)) :=
  by grind

