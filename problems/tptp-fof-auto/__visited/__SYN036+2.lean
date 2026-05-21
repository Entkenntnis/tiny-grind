theorem SYN036_plus_2 : (_U : Type) -> (p_big_p_1 : _U -> Prop) -> (p_big_q_1 : _U -> Prop) -> Iff (@Exists _U (fun (X : _U) => (Y : _U) -> Iff (Iff (p_big_p_1 X) (p_big_p_1 Y)) (@Exists _U (fun (U : _U) => Iff (p_big_q_1 U) ((W : _U) -> p_big_p_1 W))))) (@Exists _U (fun (X1 : _U) => (Y1 : _U) -> Iff (Iff (p_big_q_1 X1) (p_big_q_1 Y1)) (@Exists _U (fun (U1 : _U) => Iff (p_big_p_1 U1) ((W1 : _U) -> p_big_q_1 W1))))) :=
  by grind

