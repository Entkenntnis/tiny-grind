theorem SYN078_plus_1 : (_U : Type) -> (f_f_1 : _U -> _U) -> (p_big_p_1 : _U -> Prop) -> (X : _U) -> Iff (@Exists _U (fun (Y : _U) => And (p_big_p_1 Y) (@Eq _U X (f_f_1 Y)) -> p_big_p_1 X)) ((U : _U) -> p_big_p_1 U -> p_big_p_1 (f_f_1 U)) :=
  by grind

