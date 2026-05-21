theorem SYN551_plus_2 : (_U : Type) -> (f_f_1 : _U -> _U) -> (f_g_1 : _U -> _U) -> @Exists _U (fun (X : _U) => (Y : _U) -> Iff (Iff (@Eq _U Y (f_f_1 (f_g_1 Y))) (@Eq _U X Y)) (@Exists _U (fun (X : _U) => (Y : _U) -> Iff (@Eq _U Y (f_g_1 (f_f_1 Y))) (@Eq _U X Y)))) :=
  by grind

