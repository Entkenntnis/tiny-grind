theorem SET047_plus_1 : (_U : Type) -> (p_set_equal_2 : _U -> _U -> Prop) -> (p_element_2 : _U -> _U -> Prop) -> (pel43_1 : (X : _U) -> (Y : _U) -> Iff (p_set_equal_2 X Y) ((Z : _U) -> Iff (p_element_2 Z X) (p_element_2 Z Y))) -> (X : _U) -> (Y : _U) -> Iff (p_set_equal_2 X Y) (p_set_equal_2 Y X) :=
  by grind

