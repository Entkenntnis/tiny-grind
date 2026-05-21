theorem SYN972_plus_1 : (_U : Type) -> (p_p_2 : _U -> _U -> Prop) -> @Exists _U (fun (X : _U) => (Y : _U) -> p_p_2 X Y -> (Y : _U) -> @Exists _U (fun (X : _U) => p_p_2 X Y)) :=
  by grind

