theorem SYN384_plus_1 : (_U : Type) -> (p_big_p_3 : _U -> _U -> _U -> Prop) -> (Z : _U) -> @Exists _U (fun (X : _U) => @Exists _U (fun (Y : _U) => (U : _U) -> p_big_p_3 X Y Z -> p_big_p_3 U X X)) :=
  by grind

