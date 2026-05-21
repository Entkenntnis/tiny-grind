theorem SET574_plus_3 : (_U : Type) -> (p_intersect_2 : _U -> _U -> Prop) -> (p_member_2 : _U -> _U -> Prop) -> (intersect_defn : (B : _U) -> (C : _U) -> Iff (p_intersect_2 B C) (@Exists _U (fun (D : _U) => And (p_member_2 D B) (p_member_2 D C)))) -> (symmetry_of_intersect : (B : _U) -> (C : _U) -> p_intersect_2 B C -> p_intersect_2 C B) -> (B : _U) -> (C : _U) -> (D : _U) -> And (p_member_2 B C) (p_member_2 B D) -> p_intersect_2 C D :=
  by grind

