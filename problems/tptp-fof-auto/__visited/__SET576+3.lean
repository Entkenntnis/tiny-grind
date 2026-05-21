theorem SET576_plus_3 : (_U : Type) -> (p_intersect_2 : _U -> _U -> Prop) -> (p_member_2 : _U -> _U -> Prop) -> (p_disjoint_2 : _U -> _U -> Prop) -> (intersect_defn : (B : _U) -> (C : _U) -> Iff (p_intersect_2 B C) (@Exists _U (fun (D : _U) => And (p_member_2 D B) (p_member_2 D C)))) -> (disjoint_defn : (B : _U) -> (C : _U) -> Iff (p_disjoint_2 B C) (Not (p_intersect_2 B C))) -> (symmetry_of_intersect : (B : _U) -> (C : _U) -> p_intersect_2 B C -> p_intersect_2 C B) -> (B : _U) -> (C : _U) -> (D : _U) -> (p_member_2 D B -> Not (p_member_2 D C)) -> p_disjoint_2 B C :=
  by grind

