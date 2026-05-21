theorem SYN411_plus_1 : (_U : Type) -> (p_f_3 : _U -> _U -> _U -> Prop) -> (X : _U) -> (Y : _U) -> (Z : _U) -> Iff (p_f_3 X Y Z) (Not (@Exists _U (fun (U : _U) => @Exists _U (fun (V : _U) => @Exists _U (fun (W : _U) => Not (p_f_3 U V W)))))) :=
  by grind

