theorem SYN919_plus_1 : (_U : Type) -> (p_r_2 : _U -> _U -> Prop) -> ((X : _U) -> (Y : _U) -> And (p_r_2 X Y -> p_r_2 Y X) ((X : _U) -> (Y : _U) -> (Z : _U) -> And (p_r_2 X Y) (p_r_2 Y Z) -> p_r_2 X Z)) -> (X : _U) -> (Y : _U) -> p_r_2 X Y -> p_r_2 X X :=
  by grind

