theorem SYN343_plus_1 : (_U : Type) -> (p_big_f_2 : _U -> _U -> Prop) -> @Exists _U (fun (X : _U) => @Exists _U (fun (Y1 : _U) => @Exists _U (fun (Y2 : _U) => (Z : _U) -> ((p_big_f_2 X Y1 -> p_big_f_2 Z X) -> p_big_f_2 X X) -> And (p_big_f_2 X X) (p_big_f_2 Y1 Y2)))) :=
  by grind

