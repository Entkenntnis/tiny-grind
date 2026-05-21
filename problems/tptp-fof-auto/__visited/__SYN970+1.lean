theorem SYN970_plus_1 : (_U : Type) -> (p_p_1 : _U -> Prop) -> (p_r_1 : _U -> Prop) -> (A : _U) -> (B : _U) -> @Exists _U (fun (X : _U) => @Exists _U (fun (Y : _U) => (p_p_1 X -> p_r_1 Y) -> p_p_1 A -> p_r_1 B)) :=
  by grind

