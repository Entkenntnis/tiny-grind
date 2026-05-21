theorem SYN951_plus_1 : (_U : Type) -> (p_p_1 : _U -> Prop) -> (p_a_0 : Prop) -> (p_b_0 : Prop) -> (p_q_0 : Prop) -> @Exists _U (fun (X : _U) => p_p_1 X -> @Exists _U (fun (X : _U) => And (p_p_1 X) (p_a_0 -> And (Or p_b_0 (Not p_b_0)) (p_q_0 -> p_q_0)))) :=
  by grind

