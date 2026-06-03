theorem SYN410_plus_1 : (_U : Type) -> (p_f_2 : _U -> _U -> Prop) -> (X : _U) -> (Y : _U) -> p_f_2 X Y -> @Exists _U (fun (U : _U) => @Exists _U (fun (V : _U) => p_f_2 U V)) :=
  by grind

