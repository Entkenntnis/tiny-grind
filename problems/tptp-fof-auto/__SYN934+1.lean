theorem SYN934_plus_1 : (_U : Type) -> (p_c_0 : Prop) -> (p_p_1 : _U -> Prop) -> @Exists _U (fun (X : _U) => Iff (p_c_0 -> p_p_1 X) (p_c_0 -> @Exists _U (fun (X : _U) => p_p_1 X))) :=
  by grind

