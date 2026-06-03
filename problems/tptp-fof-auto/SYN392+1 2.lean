theorem SYN392_plus_1 : (_U : Type) -> (p_p1_0 : Prop) -> (p_p2_0 : Prop) -> Iff (Iff p_p1_0 p_p2_0) (And (Or p_p2_0 (Not p_p1_0)) (Or (Not p_p2_0) p_p1_0)) :=
  by grind

