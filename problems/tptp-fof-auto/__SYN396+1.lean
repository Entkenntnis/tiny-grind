theorem SYN396_plus_1 : (_U : Type) -> (p_f_1 : _U -> Prop) -> Not ((X : _U) -> Iff (p_f_1 X) (@Exists _U (fun (Y : _U) => Not (p_f_1 Y)))) :=
  by grind

