theorem SYN082_plus_1 : (_U : Type) -> (f_f_1 : _U -> _U) -> (p_big_f_2 : _U -> _U -> Prop) -> (X : _U) -> Iff (p_big_f_2 X (f_f_1 X)) (@Exists _U (fun (Y : _U) => (Z : _U) -> And (p_big_f_2 Z Y -> p_big_f_2 Z (f_f_1 X)) (p_big_f_2 X Y))) :=
  by grind

