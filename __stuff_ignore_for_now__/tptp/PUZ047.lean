theorem wolf_goat_cabbage :
    (Bank : Type) ->
    (south : Bank) ->
    (north : Bank) ->
    (Step : Type) ->
    (start : Step) ->
    (go_alone : Step -> Step) ->
    (take_wolf : Step -> Step) ->
    (take_goat : Step -> Step) ->
    (take_cabbage : Step -> Step) ->
    (p : Bank -> Bank -> Bank -> Bank -> Step -> Prop) ->
    -- initial state: everything on south
    (h_initial : p south south south south start) ->
    -- go_alone moves the boat when wolf, goat, cabbage positions are as given
    (h_go_alone1 : forall (T : Step), p south north south north T -> p north north south north (go_alone T)) ->
    (h_go_alone2 : forall (T1 : Step), p north north south north T1 -> p south north south north (go_alone T1)) ->
    (h_go_alone3 : forall (T2 : Step), p south south north south T2 -> p north south north south (go_alone T2)) ->
    (h_go_alone4 : forall (T3 : Step), p north south north south T3 -> p south south north south (go_alone T3)) ->
    -- take_wolf moves the boat together with the wolf
    (h_take_wolf1 : forall (T4 : Step), p south south south north T4 -> p north north south north (take_wolf T4)) ->
    (h_take_wolf2 : forall (T5 : Step), p north north south north T5 -> p south south south north (take_wolf T5)) ->
    (h_take_wolf3 : forall (T6 : Step), p south south north south T6 -> p north north north south (take_wolf T6)) ->
    (h_take_wolf4 : forall (T7 : Step), p north north north south T7 -> p south south north south (take_wolf T7)) ->
    -- take_goat moves the boat together with the goat
    (h_take_goat1 : forall (X : Bank), forall (Y : Bank), forall (U : Step),
        p south X south Y U -> p north X north Y (take_goat U)) ->
    (h_take_goat2 : forall (X1 : Bank), forall (Y1 : Bank), forall (V : Step),
        p north X1 north Y1 V -> p south X1 south Y1 (take_goat V)) ->
    -- take_cabbage moves the boat together with the cabbage
    (h_take_cabbage1 : forall (T8 : Step), p south north south south T8 -> p north north south north (take_cabbage T8)) ->
    (h_take_cabbage2 : forall (T9 : Step), p north north south north T9 -> p south north south south (take_cabbage T9)) ->
    (h_take_cabbage3 : forall (U1 : Step), p south south north south U1 -> p north south north north (take_cabbage U1)) ->
    (h_take_cabbage4 : forall (V1 : Step), p north south north north V1 -> p south south north south (take_cabbage V1)) ->
    -- conclusion: there exists a step where everything is on the north bank
    @Exists Step (fun (Z : Step) => p north north north north Z)
:= by
  grind (ematch := 10) (instances := 3000)
