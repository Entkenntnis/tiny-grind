theorem SWB002_plus_2 : (_U : Type) -> (f_uri_ex_p_0 : _U) -> (f_uri_ex_q_0 : _U) -> (f_uri_ex_s_0 : _U) -> (p_iext_3 : _U -> _U -> _U -> Prop) -> (testcase_premise_fullish_002_Existential_Blank_Nodes : @Exists _U (fun (BNODE_o : _U) => And (p_iext_3 f_uri_ex_p_0 f_uri_ex_s_0 BNODE_o) (p_iext_3 f_uri_ex_q_0 BNODE_o f_uri_ex_s_0))) -> @Exists _U (fun (BNODE_x : _U) => @Exists _U (fun (BNODE_y : _U) => And (p_iext_3 f_uri_ex_p_0 BNODE_x BNODE_y) (p_iext_3 f_uri_ex_q_0 BNODE_y BNODE_x))) :=
  by grind

