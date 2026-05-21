theorem MSC011_plus_1 : (_U : Type) -> (p_drunk_1 : _U -> Prop) -> (p_not_drunk_1 : _U -> Prop) -> (p_goal_0 : Prop) -> (p_neg_psi_0 : Prop) -> (d_cons : (A : _U) -> And (p_drunk_1 A) (p_not_drunk_1 A) -> p_goal_0) -> (neg_phi : (A : _U) -> And (p_drunk_1 A) p_neg_psi_0) -> (neg_psi_ax : p_neg_psi_0 -> @Exists _U (fun (A : _U) => p_not_drunk_1 A)) -> p_goal_0 :=
  by grind

