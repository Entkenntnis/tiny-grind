theorem SWB015_plus_2 : (_U : Type) -> (f_uri_owl_sameAs_0 : _U) -> (p_iext_3 : _U -> _U -> _U -> Prop) -> (owl_eqdis_sameas : (X : _U) -> (Y : _U) -> Iff (p_iext_3 f_uri_owl_sameAs_0 X Y) (@Eq _U X Y)) -> p_iext_3 f_uri_owl_sameAs_0 f_uri_owl_sameAs_0 f_uri_owl_sameAs_0 :=
  by grind

