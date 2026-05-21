theorem SYN928_plus_1 : (_U : Type) -> (p_p_1 : _U -> Prop) -> (X : _U) -> p_p_1 X -> @Exists _U (fun (X : _U) => p_p_1 X) :=
  by grind

