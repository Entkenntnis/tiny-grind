theorem SYN077_plus_1 : (_U : Type) -> (p_big_f_2 : _U -> _U -> Prop) -> (pel54_1 : (Y : _U) -> @Exists _U (fun (Z : _U) => (X : _U) -> Iff (p_big_f_2 X Z) (@Eq _U X Y))) -> Not (@Exists _U (fun (W : _U) => (X : _U) -> Iff (p_big_f_2 X W) ((U : _U) -> p_big_f_2 X U -> @Exists _U (fun (Y : _U) => And (p_big_f_2 Y U) (Not (@Exists _U (fun (Z : _U) => And (p_big_f_2 Z U) (p_big_f_2 Z Y)))))))) :=
  by grind

