theorem SYN377_plus_1 : (_U : Type) -> (p_big_p_1 : _U -> Prop) -> (X : _U) -> Iff (Iff (p_big_p_1 X) ((Y : _U) -> p_big_p_1 Y)) (@Exists _U (fun (X : _U) => Iff (p_big_p_1 X) ((Y : _U) -> p_big_p_1 Y))) :=
  by grind

