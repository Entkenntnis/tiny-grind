theorem SET009_plus_3 : (_U : Type) -> (f_difference_2 : _U -> _U -> _U) -> (p_member_2 : _U -> _U -> Prop) -> (p_subset_2 : _U -> _U -> Prop) -> (difference_defn : (B : _U) -> (C : _U) -> (D : _U) -> Iff (p_member_2 D (f_difference_2 B C)) (And (p_member_2 D B) (Not (p_member_2 D C)))) -> (subset_defn : (B : _U) -> (C : _U) -> Iff (p_subset_2 B C) ((D : _U) -> p_member_2 D B -> p_member_2 D C)) -> (reflexivity_of_subset : (B : _U) -> p_subset_2 B B) -> (B : _U) -> (C : _U) -> (D : _U) -> p_subset_2 B C -> p_subset_2 (f_difference_2 D C) (f_difference_2 D B) :=
  by grind

