theorem SYN368_plus_1 : (_U : Type) -> (p_big_p_1 : _U -> Prop) -> @Exists _U (fun (Y : _U) => (X : _U) -> p_big_p_1 Y -> p_big_p_1 X) :=
  by grind

