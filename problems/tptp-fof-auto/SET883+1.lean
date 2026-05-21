theorem SET883_plus_1 : (_U : Type) -> (f_singleton_1 : _U -> _U) -> (p_subset_2 : _U -> _U -> Prop) -> (p_empty_1 : _U -> Prop) -> (reflexivity_r1_tarski : (A : _U) -> (B : _U) -> p_subset_2 A A) -> (rc1_xboole_0 : @Exists _U (fun (A : _U) => p_empty_1 A)) -> (rc2_xboole_0 : @Exists _U (fun (A : _U) => Not (p_empty_1 A))) -> (t6_zfmisc_1 : (A : _U) -> (B : _U) -> p_subset_2 (f_singleton_1 A) (f_singleton_1 B) -> @Eq _U A B) -> (A : _U) -> (B : _U) -> p_subset_2 (f_singleton_1 A) (f_singleton_1 B) -> @Eq _U A B :=
  by grind

