theorem SYN375_plus_1 : (_U : Type) -> (p_big_p_1 : _U -> Prop) -> (X : _U) -> Iff (Iff (p_big_p_1 X) (@Exists _U (fun (Y : _U) => p_big_p_1 Y))) ((X : _U) -> Iff (p_big_p_1 X) (@Exists _U (fun (Y : _U) => p_big_p_1 Y))) :=
  by grind

