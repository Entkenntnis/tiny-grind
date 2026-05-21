theorem SWB003_plus_2 : (_U : Type) -> (f_uri_ex_p_0 : _U) -> (f_uri_ex_s_0 : _U) -> (f_literal_plain_1 : _U -> _U) -> (f_dat_str_foo_0 : _U) -> (p_iext_3 : _U -> _U -> _U -> Prop) -> (testcase_premise_fullish_003_Blank_Nodes_for_Literals : p_iext_3 f_uri_ex_p_0 f_uri_ex_s_0 (f_literal_plain_1 f_dat_str_foo_0)) -> @Exists _U (fun (BNODE_x : _U) => p_iext_3 f_uri_ex_p_0 f_uri_ex_s_0 BNODE_x) :=
  by grind

