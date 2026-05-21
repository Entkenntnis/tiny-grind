theorem SYN726_plus_1 : (_U : Type) -> (p_p_2 : _U -> _U -> Prop) -> (p_q_2 : _U -> _U -> Prop) -> Or (((X : _U) -> (Y : _U) -> (Z : _U) -> And (And (p_p_2 X Y) (p_p_2 Y Z) -> p_p_2 X Z) ((X : _U) -> (Y : _U) -> (Z : _U) -> And (And (p_q_2 X Y) (p_q_2 Y Z) -> p_q_2 X Z) ((X : _U) -> (Y : _U) -> And (p_q_2 X Y -> p_q_2 Y X) ((X : _U) -> (Y : _U) -> Or (p_p_2 X Y) (p_q_2 X Y))))) -> (X : _U) -> (Y : _U) -> p_p_2 X Y) ((X : _U) -> (Y : _U) -> p_q_2 X Y) :=
  by grind

