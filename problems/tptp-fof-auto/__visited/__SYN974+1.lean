theorem SYN974_plus_1 : (_U : Type) -> (p_p_1 : _U -> Prop) -> @Exists _U (fun (X : _U) => p_p_1 X -> @Exists _U (fun (Y : _U) => p_p_1 Y)) :=
  by grind

