theorem SYN325_plus_1 : (_U : Type) -> (p_big_f_2 : _U -> _U -> Prop) -> (p_big_g_1 : _U -> Prop) -> @Exists _U (fun (X : _U) => (Y : _U) -> ((p_big_f_2 X X -> p_big_f_2 Y Y) -> And (p_big_f_2 X Y) (p_big_g_1 X)) -> p_big_g_1 Y) :=
  by grind

