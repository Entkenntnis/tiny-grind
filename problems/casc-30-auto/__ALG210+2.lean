theorem ALG210_plus_2 : (_U : Type) -> (f_times_2 : _U -> _U -> _U) -> (p_element_1 : _U -> Prop) -> (_kw_axiom__1 : (A : _U) -> (B : _U) -> (C : _U) -> @Eq _U (f_times_2 (f_times_2 A B) C) (f_times_2 B (f_times_2 C A))) -> (_kw_axiom__2 : (B : _U) -> @Exists _U (fun (C : _U) => Not (Iff (And (@Eq _U (f_times_2 B B) C) (@Eq _U B (f_times_2 B C))) (p_element_1 B)))) -> (A : _U) -> (B : _U) -> (C : _U) -> And (And (p_element_1 A) (p_element_1 B)) (@Eq _U C (f_times_2 A B)) -> p_element_1 C :=
  by grind

