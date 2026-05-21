theorem SYN076_plus_1 : (_U : Type) -> (p_big_f_2 : _U -> _U -> Prop) -> (pel53_1 : @Exists _U (fun (X : _U) => @Exists _U (fun (Y : _U) => And (Not (@Eq _U X Y)) ((Z : _U) -> Or (@Eq _U Z X) (@Eq _U Z Y))))) -> @Exists _U (fun (Z : _U) => (X : _U) -> Iff (@Exists _U (fun (W : _U) => (Y : _U) -> Iff (Iff (p_big_f_2 X Y) (@Eq _U Y W)) (@Eq _U X Z))) (@Exists _U (fun (W1 : _U) => (Y1 : _U) -> @Exists _U (fun (Z1 : _U) => (X1 : _U) -> Iff (Iff (p_big_f_2 X1 Y1) (@Eq _U X1 Z1)) (@Eq _U Y1 W1))))) :=
  by grind

