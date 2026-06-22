theorem missionaries_and_cannibals :
    (Num : Type) ->
    (n0 : Num) ->
    (n1 : Num) ->
    (n2 : Num) ->
    (n3 : Num) ->
    (Boat : Type) ->
    (boatonwest : Boat) ->
    (boatoneast : Boat) ->
    (banks : Num -> Num -> Num -> Num -> Boat -> Prop) ->
    -- Moving cannibals only, west to east
    (h_bccc_mmm_to_cc_bmmmc : banks n0 n3 n3 n0 boatonwest -> banks n0 n2 n3 n1 boatoneast) ->
    (h_bmmmcc_c_to_mmmc_cc : banks n3 n2 n0 n1 boatonwest -> banks n3 n1 n0 n2 boatoneast) ->
    (h_bcc_mmmc_to_c_mmmcc : banks n0 n2 n3 n1 boatonwest -> banks n0 n1 n3 n2 boatoneast) ->
    (h_bmmmc_cc_to_mmm_ccc : banks n3 n1 n0 n2 boatonwest -> banks n3 n0 n0 n3 boatoneast) ->
    (h_bc_mmmcc_to_x_bmmmccc : banks n0 n1 n3 n2 boatonwest -> banks n0 n0 n3 n3 boatoneast) ->
    (h_bmmmccc_x_to_mmmc_bcc : banks n3 n3 n0 n0 boatonwest -> banks n3 n1 n0 n2 boatoneast) ->
    (h_bccc_mmm_to_c_bmmmcc : banks n0 n3 n3 n0 boatonwest -> banks n0 n1 n3 n2 boatoneast) ->
    (h_bmmmcc_c_to_mmm_bccc : banks n3 n2 n0 n1 boatonwest -> banks n3 n0 n0 n3 boatoneast) ->
    (h_bcc_mmmc_to_x_bmmmccc : banks n0 n2 n3 n1 boatonwest -> banks n0 n0 n3 n3 boatoneast) ->
    -- Moving cannibals only, east to west
    (h_cc_bmmmc_to_bccc_mmm : banks n0 n2 n3 n1 boatoneast -> banks n0 n3 n3 n0 boatonwest) ->
    (h_c_bmmmcc_to_bcc_mmmc : banks n0 n1 n3 n2 boatoneast -> banks n0 n2 n3 n1 boatonwest) ->
    (h_mmm_bccc_to_bmmmc_cc : banks n3 n0 n0 n3 boatoneast -> banks n3 n1 n0 n2 boatonwest) ->
    (h_mmmcc_bc_to_bmmmccc_x : banks n3 n2 n0 n1 boatoneast -> banks n3 n3 n0 n0 boatonwest) ->
    (h_mmmc_bcc_to_bmmmcc_c : banks n3 n1 n0 n2 boatoneast -> banks n3 n2 n0 n1 boatonwest) ->
    (h_c_bmmmcc_to_bccc_mmm : banks n0 n1 n3 n2 boatoneast -> banks n0 n3 n3 n0 boatonwest) ->
    (h_mmmc_bcc_to_bmmmccc_x : banks n3 n1 n0 n2 boatoneast -> banks n3 n3 n0 n0 boatonwest) ->
    (h_mmm_bccc_to_bmmmcc_c : banks n3 n0 n0 n3 boatoneast -> banks n3 n2 n0 n1 boatonwest) ->
    -- Moving missionaries only, west to east
    (h_bmmmcc_c_to_mmcc_bmc : banks n3 n2 n0 n1 boatonwest -> banks n2 n2 n1 n1 boatoneast) ->
    (h_bmc_mmcc_to_c_bmmmcc : banks n1 n1 n2 n2 boatonwest -> banks n0 n1 n3 n2 boatoneast) ->
    (h_bmmmc_cc_to_mc_bmmcc : banks n3 n1 n0 n2 boatonwest -> banks n1 n1 n2 n2 boatoneast) ->
    (h_bmmcc_mc_to_cc_bmmmc : banks n2 n2 n1 n1 boatonwest -> banks n0 n2 n3 n1 boatoneast) ->
    -- Moving missionaries only, east to west
    (h_c_bmmmcc_to_bmc_mmcc : banks n0 n1 n3 n2 boatoneast -> banks n1 n1 n2 n2 boatonwest) ->
    (h_mmcc_bmc_to_bmmmcc_c : banks n2 n2 n1 n1 boatoneast -> banks n3 n2 n0 n1 boatonwest) ->
    (h_cc_bmmmc_to_bmmcc_mc : banks n0 n2 n3 n1 boatoneast -> banks n2 n2 n1 n1 boatonwest) ->
    (h_mc_bmmcc_to_bmmmc_cc : banks n1 n1 n2 n2 boatoneast -> banks n3 n1 n0 n2 boatonwest) ->
    -- Moving a missionary and a cannibal, west to east
    (h_bmmmccc_x_to_mmcc_bmc : banks n3 n3 n0 n0 boatonwest -> banks n2 n2 n1 n1 boatoneast) ->
    (h_bmmcc_mc_to_mc_bmmcc : banks n2 n2 n1 n1 boatonwest -> banks n1 n1 n2 n2 boatoneast) ->
    (h_bmc_mmcc_to_x_bmmmccc : banks n1 n1 n2 n2 boatonwest -> banks n0 n0 n3 n3 boatoneast) ->
    -- Moving a missionary and a cannibal, east to west
    (h_mc_bmmcc_to_bmmcc_mc : banks n1 n1 n2 n2 boatoneast -> banks n2 n2 n1 n1 boatonwest) ->
    (h_mmcc_bmc_to_bmmmccc_x : banks n2 n2 n1 n1 boatoneast -> banks n3 n3 n0 n0 boatonwest) ->
    -- Starting configuration and goal
    (h_start : banks n3 n3 n0 n0 boatonwest) ->
    banks n0 n0 n3 n3 boatoneast
:= by
  grind
