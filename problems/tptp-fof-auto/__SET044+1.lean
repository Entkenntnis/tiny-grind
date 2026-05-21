theorem SET044_plus_1 : (_U : Type) -> (p_element_2 : _U -> _U -> Prop) -> @Exists _U (fun (Y : _U) => (X : _U) -> Iff (p_element_2 X Y) (p_element_2 X X) -> Not ((X1 : _U) -> @Exists _U (fun (Y1 : _U) => (Z : _U) -> Iff (p_element_2 Z Y1) (Not (p_element_2 Z X1))))) :=
  by grind

