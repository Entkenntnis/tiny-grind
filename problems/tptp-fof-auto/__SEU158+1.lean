theorem SEU158_plus_1 : (_U : Type) -> (f_singleton_1 : _U -> _U) -> (p_subset_2 : _U -> _U -> Prop) -> (p_in_2 : _U -> _U -> Prop) -> (reflexivity_r1_tarski : (A : _U) -> (B : _U) -> p_subset_2 A A) -> (antisymmetry_r2_hidden : (A : _U) -> (B : _U) -> p_in_2 A B -> Not (p_in_2 B A)) -> (dt_k1_tarski : True) -> (l2_zfmisc_1 : (A : _U) -> (B : _U) -> Iff (p_subset_2 (f_singleton_1 A) B) (p_in_2 A B)) -> (A : _U) -> (B : _U) -> Iff (p_subset_2 (f_singleton_1 A) B) (p_in_2 A B) :=
  by grind

