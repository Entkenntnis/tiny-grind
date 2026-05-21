theorem MSC012_plus_1 : (_U : Type) -> (p_p_1 : _U -> Prop) -> (p_less_2 : _U -> _U -> Prop) -> (p_goal_0 : Prop) -> (left_to_right : (A : _U) -> (B : _U) -> And (And (p_p_1 A) (p_less_2 A B)) (p_p_1 B) -> p_goal_0) -> (right_to_left : (A : _U) -> Or (p_p_1 A) (@Exists _U (fun (B : _U) => And (p_less_2 A B) (p_p_1 B)))) -> (transitive_less : (A : _U) -> (B : _U) -> (C : _U) -> And (p_less_2 A B) (p_less_2 B C) -> p_less_2 A C) -> (serial_less : (A : _U) -> @Exists _U (fun (B : _U) => p_less_2 A B)) -> p_goal_0 :=
  by grind

