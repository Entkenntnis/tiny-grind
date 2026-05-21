theorem SYN415_plus_1 : (_U : Type) -> (p_f_1 : _U -> Prop) -> Iff (@Exists _U (fun (X : _U) => And (p_f_1 X) ((Y : _U) -> (Z : _U) -> And (p_f_1 Y) (p_f_1 Z) -> @Eq _U Y Z))) (@Exists _U (fun (U : _U) => And (p_f_1 U) ((V : _U) -> p_f_1 V -> @Eq _U U V))) :=
  by grind

