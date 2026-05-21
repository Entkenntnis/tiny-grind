theorem SYN048_plus_1 : (_U : Type) -> (p_big_f_1 : _U -> Prop) -> @Exists _U (fun (Y : _U) => (X : _U) -> p_big_f_1 Y -> p_big_f_1 X) :=
  by grind

