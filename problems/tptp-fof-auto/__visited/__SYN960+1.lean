theorem SYN960_plus_1 : (_U : Type) -> (p_a_2 : _U -> _U -> Prop) -> @Exists _U (fun (X : _U) => @Exists _U (fun (Y : _U) => Iff (p_a_2 X Y) (@Exists _U (fun (Y : _U) => @Exists _U (fun (X : _U) => p_a_2 X Y))))) :=
  by grind

