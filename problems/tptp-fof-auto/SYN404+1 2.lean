theorem SYN404_plus_1 : (_U : Type) -> (p_f_1 : _U -> Prop) -> (X : _U) -> p_f_1 X -> @Exists _U (fun (Y : _U) => p_f_1 Y) :=
  by grind

