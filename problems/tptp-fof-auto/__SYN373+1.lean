theorem SYN373_plus_1 : (_U : Type) -> (p_big_p_1 : _U -> Prop) -> (p_big_q_1 : _U -> Prop) -> @Exists _U (fun (X : _U) => Iff (p_big_p_1 X -> p_big_q_1 X) ((X : _U) -> p_big_p_1 X -> @Exists _U (fun (X : _U) => p_big_q_1 X))) :=
  by grind

