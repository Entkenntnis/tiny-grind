theorem SYN358_plus_1 : (_U : Type) -> (p_p_0 : Prop) -> (p_big_q_1 : _U -> Prop) -> @Exists _U (fun (X : _U) => Iff (And p_p_0 (p_big_q_1 X)) (And p_p_0 (@Exists _U (fun (X : _U) => p_big_q_1 X)))) :=
  by grind

