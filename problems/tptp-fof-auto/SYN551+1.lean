theorem SYN551_plus_1 : (_U : Type) -> (f_f_1 : _U -> _U) -> (f_g_1 : _U -> _U) -> Iff (@Exists _U (fun (X : _U) => And (@Eq _U X (f_f_1 (f_g_1 X))) ((Y : _U) -> (Z : _U) -> And (@Eq _U Y (f_f_1 (f_g_1 Y))) (@Eq _U Z (f_f_1 (f_g_1 Z))) -> @Eq _U Y Z))) (@Exists _U (fun (X : _U) => And (@Eq _U X (f_g_1 (f_f_1 X))) ((Y : _U) -> (Z : _U) -> And (@Eq _U Y (f_g_1 (f_f_1 Y))) (@Eq _U Z (f_g_1 (f_f_1 Z))) -> @Eq _U Y Z))) :=
  by grind

