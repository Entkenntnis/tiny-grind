theorem ALG210_plus_2 : (_U : Type) -> (f_times_2 : _U -> _U -> _U) -> (p_element_1 : _U -> Prop) -> (axiom_1 : (A : _U) -> (B : _U) -> (C : _U) -> @Eq _U (f_times_2 (f_times_2 A B) C) (f_times_2 B (f_times_2 C A))) -> (axiom_2 : (B : _U) -> Iff (p_element_1 B) (@Exists _U (fun (C : _U) => And (@Eq _U (f_times_2 B C) B) (@Eq _U (f_times_2 B B) C)))) -> (A : _U) -> (B : _U) -> (C : _U) -> And (And (p_element_1 A) (p_element_1 B)) (@Eq _U C (f_times_2 A B)) -> p_element_1 C :=
  by grind

