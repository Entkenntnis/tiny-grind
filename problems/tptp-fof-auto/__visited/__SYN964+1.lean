theorem SYN964_plus_1 : (_U : Type) -> (p_p_1 : _U -> Prop) -> @Exists _U (fun (X : _U) => p_p_1 X -> @Exists _U (fun (Z : _U) => p_p_1 Z)) :=
  by grind

