theorem SET786_plus_1 : (_U : Type) -> (p_element_2 : _U -> _U -> Prop) -> Not (@Exists _U (fun (Y : _U) => (X : _U) -> Iff (p_element_2 X Y) (Not (@Exists _U (fun (Z : _U) => And (p_element_2 X Z) (p_element_2 Z X)))))) :=
  by grind

