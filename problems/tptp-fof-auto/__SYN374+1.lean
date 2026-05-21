theorem SYN374_plus_1 : (_U : Type) -> (p_big_p_1 : _U -> Prop) -> @Exists _U (fun (X : _U) => (Y : _U) -> Iff (Iff (p_big_p_1 X) (p_big_p_1 Y)) (@Exists _U (fun (X : _U) => Iff (p_big_p_1 X) ((Y : _U) -> p_big_p_1 Y)))) :=
  by grind

