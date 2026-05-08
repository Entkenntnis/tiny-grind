-- Checker-board puzzle, I don't really get the argument here, so skip

def checkerboard_dominoes :
    (Square : Type) ->
    (Row : Type) ->
    (o : Square) ->
    (d : Square) ->
    (row : Square -> Square -> Square -> Square -> Square -> Square -> Square -> Square -> Row) ->
    (state : Row -> Row -> Row -> Row -> Row -> Row -> Row -> Row -> Prop) ->
    (horizontal : Row -> Row -> Prop) ->
    (vertical : Row -> Row -> Row -> Row -> Prop) ->
    (h_initial : state
        (row d o o o o o o o)
        (row o o o o o o o o)
        (row o o o o o o o o)
        (row o o o o o o o o)
        (row o o o o o o o o)
        (row o o o o o o o o)
        (row o o o o o o o o)
        (row o o o o o o o d)) ->
    (h_final_state : Not (state
        (row d d d d d d d d)
        (row d d d d d d d d)
        (row d d d d d d d d)
        (row d d d d d d d d)
        (row d d d d d d d d)
        (row d d d d d d d d)
        (row d d d d d d d d)
        (row d d d d d d d d))) ->
    (h_hori_1 : forall (C3 C4 C5 C6 C7 C8 : Square),
        horizontal (row o o C3 C4 C5 C6 C7 C8) (row d d C3 C4 C5 C6 C7 C8)) ->
    (h_hori_2 : forall (C1 C4 C5 C6 C7 C8 : Square),
        horizontal (row C1 o o C4 C5 C6 C7 C8) (row C1 d d C4 C5 C6 C7 C8)) ->
    (h_hori_3 : forall (C1 C2 C5 C6 C7 C8 : Square),
        horizontal (row C1 C2 o o C5 C6 C7 C8) (row C1 C2 d d C5 C6 C7 C8)) ->
    (h_hori_4 : forall (C1 C2 C3 C6 C7 C8 : Square),
        horizontal (row C1 C2 C3 o o C6 C7 C8) (row C1 C2 C3 d d C6 C7 C8)) ->
    (h_hori_5 : forall (C1 C2 C3 C4 C7 C8 : Square),
        horizontal (row C1 C2 C3 C4 o o C7 C8) (row C1 C2 C3 C4 d d C7 C8)) ->
    (h_hori_6 : forall (C1 C2 C3 C4 C5 C8 : Square),
        horizontal (row C1 C2 C3 C4 C5 o o C8) (row C1 C2 C3 C4 C5 d d C8)) ->
    (h_hori_7 : forall (C1 C2 C3 C4 C5 C6 : Square),
        horizontal (row C1 C2 C3 C4 C5 C6 o o) (row C1 C2 C3 C4 C5 C6 d d)) ->
    (h_hori_move_1 : forall (RA RB R2 R3 R4 R5 R6 R7 R8 : Row),
        state RA R2 R3 R4 R5 R6 R7 R8 -> horizontal RA RB -> state RB R2 R3 R4 R5 R6 R7 R8) ->
    (h_hori_move_2 : forall (R1 RA RB R3 R4 R5 R6 R7 R8 : Row),
        state R1 RA R3 R4 R5 R6 R7 R8 -> horizontal RA RB -> state R1 RB R3 R4 R5 R6 R7 R8) ->
    (h_hori_move_3 : forall (R1 R2 RA RB R4 R5 R6 R7 R8 : Row),
        state R1 R2 RA R4 R5 R6 R7 R8 -> horizontal RA RB -> state R1 R2 RB R4 R5 R6 R7 R8) ->
    (h_hori_move_4 : forall (R1 R2 R3 RA RB R5 R6 R7 R8 : Row),
        state R1 R2 R3 RA R5 R6 R7 R8 -> horizontal RA RB -> state R1 R2 R3 RB R5 R6 R7 R8) ->
    (h_hori_move_5 : forall (R1 R2 R3 R4 RA RB R6 R7 R8 : Row),
        state R1 R2 R3 R4 RA R6 R7 R8 -> horizontal RA RB -> state R1 R2 R3 R4 RB R6 R7 R8) ->
    (h_hori_move_6 : forall (R1 R2 R3 R4 R5 RA RB R7 R8 : Row),
        state R1 R2 R3 R4 R5 RA R7 R8 -> horizontal RA RB -> state R1 R2 R3 R4 R5 RB R7 R8) ->
    (h_hori_move_7 : forall (R1 R2 R3 R4 R5 R6 RA RB R8 : Row),
        state R1 R2 R3 R4 R5 R6 RA R8 -> horizontal RA RB -> state R1 R2 R3 R4 R5 R6 RB R8) ->
    (h_hori_move_8 : forall (R1 R2 R3 R4 R5 R6 R7 RA RB : Row),
        state R1 R2 R3 R4 R5 R6 R7 RA -> horizontal RA RB -> state R1 R2 R3 R4 R5 R6 R7 RB) ->
    (h_verti_1 : forall (C2 C3 C4 C5 C6 C7 C8 D2 D3 D4 D5 D6 D7 D8 : Square),
        vertical (row o C2 C3 C4 C5 C6 C7 C8) (row o D2 D3 D4 D5 D6 D7 D8)
                 (row d C2 C3 C4 C5 C6 C7 C8) (row d D2 D3 D4 D5 D6 D7 D8)) ->
    (h_verti_2 : forall (C1 C3 C4 C5 C6 C7 C8 D1 D3 D4 D5 D6 D7 D8 : Square),
        vertical (row C1 o C3 C4 C5 C6 C7 C8) (row D1 o D3 D4 D5 D6 D7 D8)
                 (row C1 d C3 C4 C5 C6 C7 C8) (row D1 d D3 D4 D5 D6 D7 D8)) ->
    (h_verti_3 : forall (C1 C2 C4 C5 C6 C7 C8 D1 D2 D4 D5 D6 D7 D8 : Square),
        vertical (row C1 C2 o C4 C5 C6 C7 C8) (row D1 D2 o D4 D5 D6 D7 D8)
                 (row C1 C2 d C4 C5 C6 C7 C8) (row D1 D2 d D4 D5 D6 D7 D8)) ->
    (h_verti_4 : forall (C1 C2 C3 C5 C6 C7 C8 D1 D2 D3 D5 D6 D7 D8 : Square),
        vertical (row C1 C2 C3 o C5 C6 C7 C8) (row D1 D2 D3 o D5 D6 D7 D8)
                 (row C1 C2 C3 d C5 C6 C7 C8) (row D1 D2 D3 d D5 D6 D7 D8)) ->
    (h_verti_5 : forall (C1 C2 C3 C4 C6 C7 C8 D1 D2 D3 D4 D6 D7 D8 : Square),
        vertical (row C1 C2 C3 C4 o C6 C7 C8) (row D1 D2 D3 D4 o D6 D7 D8)
                 (row C1 C2 C3 C4 d C6 C7 C8) (row D1 D2 D3 D4 d D6 D7 D8)) ->
    (h_verti_6 : forall (C1 C2 C3 C4 C5 C7 C8 D1 D2 D3 D4 D5 D7 D8 : Square),
        vertical (row C1 C2 C3 C4 C5 o C7 C8) (row D1 D2 D3 D4 D5 o D7 D8)
                 (row C1 C2 C3 C4 C5 d C7 C8) (row D1 D2 D3 D4 D5 d D7 D8)) ->
    (h_verti_7 : forall (C1 C2 C3 C4 C5 C6 C8 D1 D2 D3 D4 D5 D6 D8 : Square),
        vertical (row C1 C2 C3 C4 C5 C6 o C8) (row D1 D2 D3 D4 D5 D6 o D8)
                 (row C1 C2 C3 C4 C5 C6 d C8) (row D1 D2 D3 D4 D5 D6 d D8)) ->
    (h_verti_8 : forall (C1 C2 C3 C4 C5 C6 C7 D1 D2 D3 D4 D5 D6 D7 : Square),
        vertical (row C1 C2 C3 C4 C5 C6 C7 o) (row D1 D2 D3 D4 D5 D6 D7 o)
                 (row C1 C2 C3 C4 C5 C6 C7 d) (row D1 D2 D3 D4 D5 D6 D7 d)) ->
    (h_verti_move_1_2 : forall (RA RB RC RD R3 R4 R5 R6 R7 R8 : Row),
        state RA RB R3 R4 R5 R6 R7 R8 -> vertical RA RB RC RD -> state RC RD R3 R4 R5 R6 R7 R8) ->
    (h_verti_move_2_3 : forall (R1 RA RB RC RD R4 R5 R6 R7 R8 : Row),
        state R1 RA RB R4 R5 R6 R7 R8 -> vertical RA RB RC RD -> state R1 RC RD R4 R5 R6 R7 R8) ->
    (h_verti_move_3_4 : forall (R1 R2 RA RB RC RD R5 R6 R7 R8 : Row),
        state R1 R2 RA RB R5 R6 R7 R8 -> vertical RA RB RC RD -> state R1 R2 RC RD R5 R6 R7 R8) ->
    (h_verti_move_4_5 : forall (R1 R2 R3 RA RB RC RD R6 R7 R8 : Row),
        state R1 R2 R3 RA RB R6 R7 R8 -> vertical RA RB RC RD -> state R1 R2 R3 RC RD R6 R7 R8) ->
    (h_verti_move_5_6 : forall (R1 R2 R3 R4 RA RB RC RD R7 R8 : Row),
        state R1 R2 R3 R4 RA RB R7 R8 -> vertical RA RB RC RD -> state R1 R2 R3 R4 RC RD R7 R8) ->
    (h_verti_move_6_7 : forall (R1 R2 R3 R4 R5 RA RB RC RD R8 : Row),
        state R1 R2 R3 R4 R5 RA RB R8 -> vertical RA RB RC RD -> state R1 R2 R3 R4 R5 RC RD R8) ->
    (h_verti_move_7_8 : forall (R1 R2 R3 R4 R5 R6 RA RB RC RD : Row),
        state R1 R2 R3 R4 R5 R6 RA RB -> vertical RA RB RC RD -> state R1 R2 R3 R4 R5 R6 RC RD) ->
    False
:= by
  grind (instances := 10000)
