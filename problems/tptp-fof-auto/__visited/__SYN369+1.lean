theorem SYN369_plus_1 : (_U : Type) -> (p_big_p_2 : _U -> _U -> Prop) -> (U : _U) -> (V : _U) -> (W : _U) -> Or (p_big_p_2 U V) (p_big_p_2 V W) -> @Exists _U (fun (X : _U) => (Y : _U) -> p_big_p_2 X Y) :=
  by grind

