def school_boys_all_monitors_awake :
    (some_english_sing : Prop) ->
    (some_english_sing_not : Prop) ->
    (some_germans_play : Prop) ->
    (some_germans_play_not : Prop) ->
    (some_irish_fight : Prop) ->
    (some_irish_fight_not : Prop) ->
    (some_monitors_are_awake : Prop) ->
    (some_monitors_are_not_awake : Prop) ->
    (some_of_the_eleven_are_not_oiling : Prop) ->
    (some_scotch_dance : Prop) ->
    (some_scotch_dance_not : Prop) ->
    (some_welsh_eat : Prop) ->
    (some_welsh_eat_not : Prop) ->
    (h_c1 : some_english_sing -> some_english_sing_not -> some_monitors_are_awake) ->
    (h_c2 : some_scotch_dance -> some_irish_fight -> some_welsh_eat) ->
    (h_c3 : some_germans_play -> Or some_germans_play_not some_of_the_eleven_are_not_oiling) ->
    (h_c4 : some_monitors_are_awake -> some_monitors_are_not_awake -> some_irish_fight) ->
    (h_c5 : some_germans_play -> Or some_scotch_dance some_welsh_eat_not) ->
    (h_c6 : some_scotch_dance_not -> some_irish_fight_not -> some_germans_play) ->
    (h_c7 : some_monitors_are_awake -> some_welsh_eat -> some_scotch_dance -> False) ->
    (h_c8 : some_germans_play_not -> some_welsh_eat_not -> some_irish_fight -> False) ->
    (h_c9 : some_english_sing -> some_scotch_dance_not -> some_germans_play -> some_english_sing_not) ->
    (h_c10 : some_english_sing -> some_monitors_are_not_awake -> some_irish_fight_not) ->
    (h_c11 : some_monitors_are_awake -> some_of_the_eleven_are_not_oiling -> some_scotch_dance) ->
    (h_c12 : Or some_english_sing_not some_english_sing) ->
    (h_c13 : Or some_monitors_are_not_awake some_monitors_are_awake) ->
    (h_c14 : Or some_scotch_dance some_scotch_dance_not) ->
    (h_c15 : Or some_irish_fight some_irish_fight_not) ->
    (h_c16 : Or some_welsh_eat some_welsh_eat_not) ->
    (h_c17 : Or some_germans_play some_germans_play_not) ->
    (h_c18 : some_english_sing) ->
    (h_c19 : some_scotch_dance_not) ->
    (h_neg_conjecture : some_monitors_are_not_awake) ->
    False
:= by
  grind
