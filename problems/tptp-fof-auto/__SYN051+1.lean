theorem SYN051_plus_1 : (_U : Type) -> (p_p_0 : Prop) -> (p_big_f_1 : _U -> Prop) -> (pel21_1 : @Exists _U (fun (X : _U) => p_p_0 -> p_big_f_1 X)) -> (pel21_2 : @Exists _U (fun (X : _U) => p_big_f_1 X -> p_p_0)) -> @Exists _U (fun (X : _U) => Iff p_p_0 (p_big_f_1 X)) :=
  by grind

