theorem SET043_plus_1 : (_U : Type) -> (p_element_2 : _U -> _U -> Prop) -> Not (@Exists _U (fun (X : _U) => (Y : _U) -> Iff (p_element_2 Y X) (Not (p_element_2 Y Y)))) :=
  by grind

