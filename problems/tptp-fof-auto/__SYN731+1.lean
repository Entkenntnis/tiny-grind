theorem SYN731_plus_1 : (_U : Type) -> (p_p_3 : _U -> _U -> _U -> Prop) -> @Exists _U (fun (W : _U) => (X : _U) -> @Exists _U (fun (Y : _U) => p_p_3 W X Y -> @Exists _U (fun (Z : _U) => p_p_3 Z Z W))) :=
  by grind

