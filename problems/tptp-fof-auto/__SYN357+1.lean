theorem SYN357_plus_1 : (_U : Type) -> (p_big_p_1 : _U -> Prop) -> (X : _U) -> @Exists _U (fun (Y : _U) => p_big_p_1 X -> p_big_p_1 Y) :=
  by grind

