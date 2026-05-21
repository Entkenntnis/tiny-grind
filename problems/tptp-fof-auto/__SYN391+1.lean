theorem SYN391_plus_1 : (_U : Type) -> (p_p1_0 : Prop) -> (p_p2_0 : Prop) -> And (And (Or p_p1_0 p_p2_0) (Or (Not p_p1_0) p_p2_0)) (Or p_p1_0 (Not p_p2_0)) -> Not (Or (Not p_p1_0) (Not p_p2_0)) :=
  by grind

