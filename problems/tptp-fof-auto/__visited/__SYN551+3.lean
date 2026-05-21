theorem SYN551_plus_3 : (_U : Type) -> (f_f_1 : _U -> _U) -> (f_g_1 : _U -> _U) -> @Exists _U (fun (X : _U) => Iff (And (@Eq _U X (f_f_1 (f_g_1 X))) ((Y : _U) -> @Eq _U Y (f_f_1 (f_g_1 Y)) -> @Eq _U Y X)) (@Exists _U (fun (X : _U) => And (@Eq _U X (f_g_1 (f_f_1 X))) ((Y : _U) -> @Eq _U Y (f_g_1 (f_f_1 Y)) -> @Eq _U Y X)))) :=
  by grind

