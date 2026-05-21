theorem SET027_plus_3 : (_U : Type) -> (p_subset_2 : _U -> _U -> Prop) -> (p_member_2 : _U -> _U -> Prop) -> (subset_defn : (B : _U) -> (C : _U) -> Iff (p_subset_2 B C) ((D : _U) -> p_member_2 D B -> p_member_2 D C)) -> (reflexivity_of_subset : (B : _U) -> p_subset_2 B B) -> (B : _U) -> (C : _U) -> (D : _U) -> And (p_subset_2 B C) (p_subset_2 C D) -> p_subset_2 B D :=
  by grind

