theorem SET788_plus_1 : (_U : Type) -> (p_equalish_2 : _U -> _U -> Prop) -> (p_a_member_of_2 : _U -> _U -> Prop) -> (X : _U) -> (Y : _U) -> Iff (p_equalish_2 X Y) ((Z : _U) -> Iff (p_a_member_of_2 Z X) (p_a_member_of_2 Z Y)) -> (X : _U) -> (Y : _U) -> Iff (p_equalish_2 X Y) (p_equalish_2 Y X) :=
  by grind

