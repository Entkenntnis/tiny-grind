theorem SYN080_plus_1 : (_U : Type) -> (f_f_1 : _U -> _U) -> (f_g_1 : _U -> _U) -> (pel58_1 : (X : _U) -> (Y : _U) -> @Eq _U (f_f_1 X) (f_g_1 Y)) -> (X : _U) -> (Y : _U) -> @Eq _U (f_f_1 (f_f_1 X)) (f_f_1 (f_g_1 Y)) :=
  by grind

