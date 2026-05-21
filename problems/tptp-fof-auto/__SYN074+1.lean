theorem SYN074_plus_1 : (_U : Type) -> (p_big_f_2 : _U -> _U -> Prop) -> (pel51_1 : @Exists _U (fun (Z : _U) => @Exists _U (fun (W : _U) => (X : _U) -> (Y : _U) -> Iff (p_big_f_2 X Y) (And (@Eq _U X Z) (@Eq _U Y W))))) -> @Exists _U (fun (Z : _U) => (X : _U) -> @Exists _U (fun (W : _U) => (Y : _U) -> Iff (Iff (p_big_f_2 X Y) (@Eq _U Y W)) (@Eq _U X Z))) :=
  by grind

