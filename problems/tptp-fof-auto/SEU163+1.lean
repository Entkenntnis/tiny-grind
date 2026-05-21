theorem SEU163_plus_1 : (_U : Type) -> (f_union_1 : _U -> _U) -> (p_subset_2 : _U -> _U -> Prop) -> (p_in_2 : _U -> _U -> Prop) -> (reflexivity_r1_tarski : (A : _U) -> (B : _U) -> p_subset_2 A A) -> (antisymmetry_r2_hidden : (A : _U) -> (B : _U) -> p_in_2 A B -> Not (p_in_2 B A)) -> (dt_k3_tarski : True) -> (l50_zfmisc_1 : (A : _U) -> (B : _U) -> p_in_2 A B -> p_subset_2 A (f_union_1 B)) -> (A : _U) -> (B : _U) -> p_in_2 A B -> p_subset_2 A (f_union_1 B) :=
  by grind

