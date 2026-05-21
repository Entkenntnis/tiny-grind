theorem SET045_plus_1 : (_U : Type) -> (p_element_2 : _U -> _U -> Prop) -> (pel41_1 : (Z : _U) -> @Exists _U (fun (Y : _U) => (X : _U) -> Iff (p_element_2 X Y) (And (p_element_2 X Z) (Not (p_element_2 X X))))) -> Not (@Exists _U (fun (Z : _U) => (X : _U) -> p_element_2 X Z)) :=
  by grind

