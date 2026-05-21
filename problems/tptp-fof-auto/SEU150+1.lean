theorem SEU150_plus_1 : (_U : Type) -> (f_unordered_pair_2 : _U -> _U -> _U) -> (f_singleton_1 : _U -> _U) -> (commutativity_k2_tarski : (A : _U) -> (B : _U) -> @Eq _U (f_unordered_pair_2 A B) (f_unordered_pair_2 B A)) -> (dt_k1_tarski : True) -> (dt_k2_tarski : True) -> (t8_zfmisc_1 : (A : _U) -> (B : _U) -> (C : _U) -> @Eq _U (f_singleton_1 A) (f_unordered_pair_2 B C) -> @Eq _U A B) -> (A : _U) -> (B : _U) -> (C : _U) -> @Eq _U (f_singleton_1 A) (f_unordered_pair_2 B C) -> @Eq _U B C :=
  by grind

