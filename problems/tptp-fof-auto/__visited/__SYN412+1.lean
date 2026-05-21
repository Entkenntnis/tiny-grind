theorem SYN412_plus_1 : (_U : Type) -> (p_f_2 : _U -> _U -> Prop) -> Not (@Exists _U (fun (X : _U) => (Y : _U) -> Iff (p_f_2 X Y) (Not (p_f_2 X X)))) :=
  by grind

