theorem SYN966_plus_1 : (_U : Type) -> (p_eq_2 : _U -> _U -> Prop) -> (p_a_member_of_2 : _U -> _U -> Prop) -> (X : _U) -> (Y : _U) -> Iff (p_eq_2 X Y) ((Z : _U) -> Iff (p_a_member_of_2 Z X) (p_a_member_of_2 Z Y)) -> (A : _U) -> (B : _U) -> p_eq_2 A B -> p_eq_2 B A :=
  by grind

