theorem SYN965_plus_1 : (_U : Type) -> (p_p_2 : _U -> _U -> Prop) -> @Exists _U (fun (Z : _U) => (X : _U) -> @Exists _U (fun (Y : _U) => And (p_p_2 Y X -> @Exists _U (fun (W : _U) => p_p_2 W Y)) (And (p_p_2 Z Y) (p_p_2 Y Z) -> p_p_2 Y X))) :=
  by grind

