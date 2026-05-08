def oona_puzzle :
    (a_is_a_knight : Prop) ->
    (b_is_a_knight : Prop) ->
    (c_is_a_knight : Prop) ->
    (d_is_a_knight : Prop) ->
    (e_is_a_knight : Prop) ->
    -- c1: ~a \/ ~b
    (h1 : a_is_a_knight -> b_is_a_knight -> False) ->
    -- c2: ~a \/ ~d
    (h2 : a_is_a_knight -> d_is_a_knight -> False) ->
    -- c3: ~b \/ ~a
    (h3 : b_is_a_knight -> a_is_a_knight -> False) ->
    -- c4: b \/ a
    (h4 : Or b_is_a_knight a_is_a_knight) ->
    -- c5: ~b \/ c \/ d
    (h5 : b_is_a_knight -> Or c_is_a_knight d_is_a_knight) ->
    -- c6: ~c \/ ~d
    (h6 : c_is_a_knight -> d_is_a_knight -> False) ->
    -- c7: ~d \/ ~a
    (h7 : d_is_a_knight -> a_is_a_knight -> False) ->
    -- c8: ~d \/ b
    (h8 : d_is_a_knight -> b_is_a_knight) ->
    -- c9: ~d \/ ~c
    (h9 : d_is_a_knight -> c_is_a_knight -> False) ->
    -- c10: ~e \/ ~d \/ c
    (h10 : e_is_a_knight -> d_is_a_knight -> c_is_a_knight) ->
    -- c11: e \/ d
    (h11 : Or e_is_a_knight d_is_a_knight) ->
    -- c12: e \/ ~c
    (h12 : Or e_is_a_knight (Not c_is_a_knight)) ->
    -- c13: d \/ a \/ c
    (h13 : Or d_is_a_knight (Or a_is_a_knight c_is_a_knight)) ->
    -- c14: d \/ ~b \/ c
    (h14 : Or d_is_a_knight (Or (Not b_is_a_knight) c_is_a_knight)) ->
    -- c15: ~a \/ ~e \/ c
    (h15 : a_is_a_knight -> e_is_a_knight -> c_is_a_knight) ->
    -- c16: a \/ e
    (h16 : Or a_is_a_knight e_is_a_knight) ->
    -- c17: a \/ ~c
    (h17 : Or a_is_a_knight (Not c_is_a_knight)) ->
    -- c18: b (negated conjecture)
    (h18 : b_is_a_knight) ->
    False
:= by
  grind
