theorem SYN327_plus_1 : (_U : Type) -> (p_big_f_2 : _U -> _U -> Prop) -> (X : _U) -> @Exists _U (fun (Y : _U) => (Z : _U) -> p_big_f_2 Y X -> And (p_big_f_2 X Z -> p_big_f_2 X Y) (p_big_f_2 X Y -> Not (p_big_f_2 X Z) -> And (p_big_f_2 Y X) (p_big_f_2 Z Y))) :=
  by grind

