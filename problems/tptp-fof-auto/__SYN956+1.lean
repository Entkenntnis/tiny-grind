theorem SYN956_plus_1 : (_U : Type) -> (p_a_1 : _U -> Prop) -> (p_b_1 : _U -> Prop) -> @Exists _U (fun (X : _U) => (p_a_1 X -> p_b_1 X) -> (X : _U) -> p_a_1 X -> @Exists _U (fun (X : _U) => p_b_1 X)) :=
  by grind

