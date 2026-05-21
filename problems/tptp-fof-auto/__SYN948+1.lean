theorem SYN948_plus_1 : (_U : Type) -> (p_a_2 : _U -> _U -> Prop) -> (X : _U) -> @Exists _U (fun (Y : _U) => And (p_a_2 X Y) (p_a_2 Y Y) -> @Exists _U (fun (Z : _U) => p_a_2 Z Z)) :=
  by grind

