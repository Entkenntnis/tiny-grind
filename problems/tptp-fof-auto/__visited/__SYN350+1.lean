theorem SYN350_plus_1 : (_U : Type) -> (p_big_f_2 : _U -> _U -> Prop) -> (X : _U) -> @Exists _U (fun (Y1 : _U) => @Exists _U (fun (Y2 : _U) => (Z : _U) -> Iff (p_big_f_2 X Z) (p_big_f_2 Z X) -> Iff (p_big_f_2 X Z) (And (p_big_f_2 Y2 Z) (p_big_f_2 Y1 Z -> p_big_f_2 Y1 Y2)))) :=
  by grind

