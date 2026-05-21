theorem SYN397_plus_1 : (_U : Type) -> (p_f_1 : _U -> Prop) -> Not (@Exists _U (fun (X : _U) => Iff (p_f_1 X) ((Y : _U) -> Not (p_f_1 Y)))) :=
  by grind

