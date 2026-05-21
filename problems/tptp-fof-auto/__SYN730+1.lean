theorem SYN730_plus_1 : (_U : Type) -> (f_a_0 : _U) -> (f_h_1 : _U -> _U) -> (f_k_1 : _U -> _U) -> (p_p_3 : _U -> _U -> _U -> Prop) -> @Exists _U (fun (V : _U) => (J : _U) -> @Exists _U (fun (Q : _U) => Or (p_p_3 f_a_0 J (f_h_1 J)) (p_p_3 V J (f_k_1 J)) -> p_p_3 V J Q)) :=
  by grind

