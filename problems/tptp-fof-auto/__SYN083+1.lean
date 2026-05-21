theorem SYN083_plus_1 : (_U : Type) -> (f_f_2 : _U -> _U -> _U) -> (p61_1 : (X : _U) -> (Y : _U) -> (Z : _U) -> @Eq _U (f_f_2 X (f_f_2 Y Z)) (f_f_2 (f_f_2 X Y) Z)) -> (X : _U) -> (Y : _U) -> (Z : _U) -> (W : _U) -> @Eq _U (f_f_2 X (f_f_2 Y (f_f_2 Z W))) (f_f_2 (f_f_2 (f_f_2 X Y) Z) W) :=
  by grind

