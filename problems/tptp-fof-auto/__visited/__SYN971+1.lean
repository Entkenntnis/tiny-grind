theorem SYN971_plus_1 : (_U : Type) -> (p_p_1 : _U -> Prop) -> @Exists _U (fun (Y : _U) => @Exists _U (fun (X : _U) => p_p_1 X -> p_p_1 Y)) :=
  by grind

