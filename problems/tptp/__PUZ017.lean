-- Another typical "5 people, 5 houses, etc." puzzle

set_option maxHeartbeats 10000000

def houses_puzzle :
    (Entity : Type) ->
    (n1 : Entity) -> (n2 : Entity) -> (n3 : Entity) -> (n4 : Entity) -> (n5 : Entity) ->
    (englishman : Entity) -> (italian : Entity) -> (swede : Entity) -> (russian : Entity) -> (american : Entity) ->
    (red : Entity) -> (white : Entity) -> (green : Entity) -> (yellow : Entity) -> (blue : Entity) ->
    (lemonade : Entity) -> (coffee : Entity) -> (milk : Entity) -> (vodka : Entity) -> (unknown_drink : Entity) ->
    (backgammon : Entity) -> (racquetball : Entity) -> (quoits : Entity) -> (solitaire : Entity) -> (charades : Entity) ->
    (guppy : Entity) -> (toad : Entity) -> (camel : Entity) -> (rat : Entity) -> (no_pet : Entity) ->
    (samehouse : Entity -> Entity -> Prop) ->
    (sameperson : Entity -> Entity -> Prop) ->
    (samecolor : Entity -> Entity -> Prop) ->
    (samedrink : Entity -> Entity -> Prop) ->
    (samegame : Entity -> Entity -> Prop) ->
    (samepet : Entity -> Entity -> Prop) ->
    (left : Entity -> Entity -> Prop) ->
    (nextto : Entity -> Entity -> Prop) ->
    (hasperson : Entity -> Entity -> Prop) ->
    (hascolor : Entity -> Entity -> Prop) ->
    (hasdrink : Entity -> Entity -> Prop) ->
    (hasgame : Entity -> Entity -> Prop) ->
    (haspet : Entity -> Entity -> Prop) ->
    (h_reflexivity_for_samehouse : forall (X : Entity), samehouse X X) ->
    (h_house_1_not_2 : Not (samehouse n1 n2)) ->
    (h_house_1_not_3 : Not (samehouse n1 n3)) ->
    (h_house_1_not_4 : Not (samehouse n1 n4)) ->
    (h_house_1_not_5 : Not (samehouse n1 n5)) ->
    (h_house_2_not_3 : Not (samehouse n2 n3)) ->
    (h_house_2_not_4 : Not (samehouse n2 n4)) ->
    (h_house_2_not_5 : Not (samehouse n2 n5)) ->
    (h_house_3_not_4 : Not (samehouse n3 n4)) ->
    (h_house_3_not_5 : Not (samehouse n3 n5)) ->
    (h_house_4_not_5 : Not (samehouse n4 n5)) ->
    (h_reflexivity_for_sameperson : forall (X : Entity), sameperson X X) ->
    (h_englishman_not_italian : Not (sameperson englishman italian)) ->
    (h_englishman_not_swede : Not (sameperson englishman swede)) ->
    (h_englishman_not_russian : Not (sameperson englishman russian)) ->
    (h_englishman_not_american : Not (sameperson englishman american)) ->
    (h_italian_not_swede : Not (sameperson italian swede)) ->
    (h_italian_not_russian : Not (sameperson italian russian)) ->
    (h_italian_not_american : Not (sameperson italian american)) ->
    (h_swede_not_russian : Not (sameperson swede russian)) ->
    (h_swede_not_american : Not (sameperson swede american)) ->
    (h_russian_not_american : Not (sameperson russian american)) ->
    (h_reflexivity_for_samecolor : forall (X : Entity), samecolor X X) ->
    (h_red_not_white : Not (samecolor red white)) ->
    (h_red_not_green : Not (samecolor red green)) ->
    (h_red_not_yellow : Not (samecolor red yellow)) ->
    (h_red_not_blue : Not (samecolor red blue)) ->
    (h_white_not_green : Not (samecolor white green)) ->
    (h_white_not_yellow : Not (samecolor white yellow)) ->
    (h_white_not_blue : Not (samecolor white blue)) ->
    (h_green_not_yellow : Not (samecolor green yellow)) ->
    (h_green_not_blue : Not (samecolor green blue)) ->
    (h_yellow_not_blue : Not (samecolor yellow blue)) ->
    (h_reflexivity_for_samedrink : forall (X : Entity), samedrink X X) ->
    (h_lemonade_not_coffee : Not (samedrink lemonade coffee)) ->
    (h_lemonade_not_milk : Not (samedrink lemonade milk)) ->
    (h_lemonade_not_vodka : Not (samedrink lemonade vodka)) ->
    (h_lemonade_not_unknown : Not (samedrink lemonade unknown_drink)) ->
    (h_coffee_not_milk : Not (samedrink coffee milk)) ->
    (h_coffee_not_vodka : Not (samedrink coffee vodka)) ->
    (h_coffee_not_known : Not (samedrink coffee unknown_drink)) ->
    (h_milk_not_vodka : Not (samedrink milk vodka)) ->
    (h_milk_not_unknown : Not (samedrink milk unknown_drink)) ->
    (h_vodka_not_unknown : Not (samedrink vodka unknown_drink)) ->
    (h_reflexivity_for_samegame : forall (X : Entity), samegame X X) ->
    (h_backgammon_not_recquetball : Not (samegame backgammon racquetball)) ->
    (h_backgammon_not_quoits : Not (samegame backgammon quoits)) ->
    (h_backgammon_not_solitaire : Not (samegame backgammon solitaire)) ->
    (h_backgammon_not_charades : Not (samegame backgammon charades)) ->
    (h_racquetball_not_quoits : Not (samegame racquetball quoits)) ->
    (h_racquetball_not_solitaire : Not (samegame racquetball solitaire)) ->
    (h_racquetball_not_charades : Not (samegame racquetball charades)) ->
    (h_quoits_not_solitaire : Not (samegame quoits solitaire)) ->
    (h_quoits_not_charades : Not (samegame quoits charades)) ->
    (h_solitaire_not_charades : Not (samegame solitaire charades)) ->
    (h_reflexivity_for_samepet : forall (X : Entity), samepet X X) ->
    (h_guppy_not_toad : Not (samepet guppy toad)) ->
    (h_guppy_not_camel : Not (samepet guppy camel)) ->
    (h_guppy_not_rat : Not (samepet guppy rat)) ->
    (h_guppy_is_pet : Not (samepet guppy no_pet)) ->
    (h_toad_not_camel : Not (samepet toad camel)) ->
    (h_toad_not_rat : Not (samepet toad rat)) ->
    (h_toad_is_pet : Not (samepet toad no_pet)) ->
    (h_camel_not_rat : Not (samepet camel rat)) ->
    (h_camel_is_pet : Not (samepet camel no_pet)) ->
    (h_rat_is_pet : Not (samepet rat no_pet)) ->
    (h_symmetry_of_nextto : forall (X Y : Entity), nextto X Y -> nextto Y X) ->
    (h_non_symmetry_of_left : forall (X Y : Entity), left X Y -> left Y X -> False) ->
    (h_nextto_means_left : forall (X Y : Entity), nextto X Y -> Or (left X Y) (left Y X)) ->
    (h_left_means_nextto : forall (X Y : Entity), left X Y -> nextto X Y) ->
    (h_house_not_nextto_itself : forall (X Y : Entity), samehouse X Y -> nextto X Y -> False) ->
    (h_nothing_left_of_itself : forall (X : Entity), Not (left X X)) ->
    (h_nothing_nextto_itself : forall (X : Entity), Not (nextto X X)) ->
    (h_every_house_has_a_national : forall (X : Entity), Or (hasperson X englishman) (Or (hasperson X italian) (Or (hasperson X swede) (Or (hasperson X russian) (hasperson X american))))) ->
    (h_every_nationality_is_used : forall (Y : Entity), Or (hasperson n1 Y) (Or (hasperson n2 Y) (Or (hasperson n3 Y) (Or (hasperson n4 Y) (hasperson n5 Y))))) ->
    (h_every_house_has_color : forall (X : Entity), Or (hascolor X red) (Or (hascolor X white) (Or (hascolor X green) (Or (hascolor X yellow) (hascolor X blue))))) ->
    (h_every_color_is_used : forall (Y : Entity), Or (hascolor n1 Y) (Or (hascolor n2 Y) (Or (hascolor n3 Y) (Or (hascolor n4 Y) (hascolor n5 Y))))) ->
    (h_every_house_has_a_drink : forall (X : Entity), Or (hasdrink X lemonade) (Or (hasdrink X coffee) (Or (hasdrink X milk) (Or (hasdrink X vodka) (hasdrink X unknown_drink))))) ->
    (h_every_drink_is_used : forall (Y : Entity), Or (hasdrink n1 Y) (Or (hasdrink n2 Y) (Or (hasdrink n3 Y) (Or (hasdrink n4 Y) (hasdrink n5 Y))))) ->
    (h_every_house_has_a_game : forall (X : Entity), Or (hasgame X backgammon) (Or (hasgame X racquetball) (Or (hasgame X quoits) (Or (hasgame X solitaire) (hasgame X charades))))) ->
    (h_every_game_is_used : forall (Y : Entity), Or (hasgame n1 Y) (Or (hasgame n2 Y) (Or (hasgame n3 Y) (Or (hasgame n4 Y) (hasgame n5 Y))))) ->
    (h_every_house_has_a_pet : forall (X : Entity), Or (haspet X guppy) (Or (haspet X toad) (Or (haspet X camel) (Or (haspet X rat) (haspet X no_pet))))) ->
    (h_every_pet_is_used : forall (Y : Entity), Or (haspet n1 Y) (Or (haspet n2 Y) (Or (haspet n3 Y) (Or (haspet n4 Y) (haspet n5 Y))))) ->
    (h_houses_have_unique_colors : forall (X1 X2 Y : Entity), hascolor X1 Y -> hascolor X2 Y -> samehouse X1 X2) ->
    (h_nationals_have_unique_houses : forall (X1 X2 Y : Entity), hasperson X1 Y -> hasperson X2 Y -> samehouse X1 X2) ->
    (h_drinks_have_unique_houses : forall (X1 X2 Y : Entity), hasdrink X1 Y -> hasdrink X2 Y -> samehouse X1 X2) ->
    (h_games_have_unique_houses : forall (X1 X2 Y : Entity), hasgame X1 Y -> hasgame X2 Y -> samehouse X1 X2) ->
    (h_pets_have_unique_houses : forall (X1 X2 Y : Entity), haspet X1 Y -> haspet X2 Y -> samehouse X1 X2) ->
    (h_houses_have_unique_nationals : forall (Y X1 X2 : Entity), hasperson Y X1 -> hasperson Y X2 -> sameperson X1 X2) ->
    (h_colours_are_unique : forall (Y X1 X2 : Entity), hascolor Y X1 -> hascolor Y X2 -> samecolor X1 X2) ->
    (h_houses_have_unique_drinks : forall (Y X1 X2 : Entity), hasdrink Y X1 -> hasdrink Y X2 -> samedrink X1 X2) ->
    (h_houses_have_unique_games : forall (Y X1 X2 : Entity), hasgame Y X1 -> hasgame Y X2 -> samegame X1 X2) ->
    (h_houses_have_unique_pets : forall (Y X1 X2 : Entity), haspet Y X1 -> haspet Y X2 -> samepet X1 X2) ->
    (h_englishman_lives_in_red_house1 : forall (X : Entity), hasperson X englishman -> hascolor X red) ->
    (h_englishman_lives_in_red_house2 : forall (X : Entity), hascolor X red -> hasperson X englishman) ->
    (h_white_house_left_of_green1 : forall (X Y : Entity), hascolor X white -> hascolor Y green -> left X Y) ->
    (h_white_house_left_of_green2 : forall (X Y : Entity), hascolor X white -> left X Y -> hascolor Y green) ->
    (h_white_house_left_of_green3 : forall (X Y : Entity), hascolor Y green -> left X Y -> hascolor X white) ->
    (h_italian_has_guppy1 : forall (X : Entity), hasperson X italian -> haspet X guppy) ->
    (h_italian_has_guppy2 : forall (X : Entity), haspet X guppy -> hasperson X italian) ->
    (h_lemonade_in_green_house1 : forall (X : Entity), hasdrink X lemonade -> hascolor X green) ->
    (h_lemonade_in_green_house2 : forall (X : Entity), hascolor X green -> hasdrink X lemonade) ->
    (h_swede_drinks_coffee1 : forall (X : Entity), hasperson X swede -> hasdrink X coffee) ->
    (h_swede_drinks_coffee2 : forall (X : Entity), hasdrink X coffee -> hasperson X swede) ->
    (h_toad_lives_with_backgammon1 : forall (X : Entity), haspet X toad -> hasgame X backgammon) ->
    (h_toad_lives_with_backgammon2 : forall (X : Entity), hasgame X backgammon -> haspet X toad) ->
    (h_racquetball_played_in_yellow_house1 : forall (X : Entity), hasgame X racquetball -> hascolor X yellow) ->
    (h_racquetball_played_in_yellow_house2 : forall (X : Entity), hascolor X yellow -> hasgame X racquetball) ->
    (h_c1 : forall (X Y Z : Entity), haspet X camel -> nextto X Y -> nextto X Z -> Or (samehouse Y Z) (Or (hasgame Y quoits) (hasgame Z quoits))) ->
    (h_c2 : forall (X Y : Entity), haspet X camel -> samehouse n1 X -> nextto X Y -> hasgame Y quoits) ->
    (h_c3 : forall (X Y : Entity), haspet X camel -> samehouse X n5 -> nextto X Y -> hasgame Y quoits) ->
    (h_c4 : forall (X Y : Entity), haspet X camel -> hasgame Y quoits -> nextto X Y) ->
    (h_c5 : forall (X Y Z : Entity), nextto X Y -> nextto X Z -> hasgame X quoits -> Or (samehouse Y Z) (Or (haspet Y camel) (haspet Z camel))) ->
    (h_c6 : forall (X Y : Entity), samehouse n1 X -> nextto X Y -> hasgame X quoits -> haspet Y camel) ->
    (h_c7 : forall (X Y : Entity), samehouse X n5 -> nextto X Y -> hasgame X quoits -> haspet Y camel) ->
    (h_c8 : forall (X Y Z : Entity), haspet X rat -> nextto X Y -> nextto X Z -> Or (samehouse Y Z) (Or (hasgame Y racquetball) (hasgame Z racquetball))) ->
    (h_c9 : forall (X Y : Entity), haspet X rat -> nextto X Y -> samehouse n1 X -> hasgame Y racquetball) ->
    (h_c10 : forall (X Y : Entity), haspet X rat -> nextto X Y -> samehouse X n5 -> hasgame Y racquetball) ->
    (h_c11 : forall (X Y : Entity), haspet X rat -> hasgame Y racquetball -> nextto X Y) ->
    (h_c12 : forall (X Y Z : Entity), nextto X Y -> nextto X Z -> hasgame X racquetball -> Or (samehouse Y Z) (Or (haspet Y rat) (haspet Z rat))) ->
    (h_c13 : forall (X Y : Entity), nextto X Y -> samehouse n1 X -> hasgame X racquetball -> haspet Y rat) ->
    (h_c14 : forall (X Y : Entity), nextto X Y -> samehouse X n5 -> hasgame X racquetball -> haspet Y rat) ->
    (h_c15 : forall (X : Entity), hasgame X solitaire -> hasdrink X vodka) ->
    (h_c16 : forall (X : Entity), hasdrink X vodka -> hasgame X solitaire) ->
    (h_c17 : forall (X : Entity), hasperson X american -> hasgame X charades) ->
    (h_c18 : forall (X : Entity), hasgame X charades -> hasperson X american) ->
    (h_c19 : forall (X Y Z : Entity), hasperson X russian -> nextto X Y -> nextto X Z -> Or (samehouse Y Z) (Or (hascolor Y blue) (hascolor Z blue))) ->
    (h_c20 : forall (X Y : Entity), hasperson X russian -> samehouse n1 X -> nextto X Y -> hascolor Y blue) ->
    (h_c21 : forall (X Y : Entity), hasperson X russian -> samehouse X n5 -> nextto X Y -> hascolor Y blue) ->
    (h_c22 : forall (X Y : Entity), hasperson X russian -> hascolor Y blue -> nextto X Y) ->
    (h_c23 : forall (X Y Z : Entity), nextto X Y -> nextto X Z -> hascolor X blue -> Or (samehouse Y Z) (Or (hasperson Y russian) (hasperson Z russian))) ->
    (h_c24 : forall (X Y : Entity), nextto X Y -> hascolor X blue -> samehouse n1 X -> hasperson Y russian) ->
    (h_c25 : forall (X Y : Entity), nextto X Y -> hascolor X blue -> samehouse X n5 -> hasperson Y russian) ->
    (h_house1_at_left : forall (X : Entity), Not (left X n1)) ->
    (h_house5_at_right : forall (X : Entity), Not (left n5 X)) ->
    (h_house_1_left_of_2 : left n1 n2) ->
    (h_house_2_left_of_3 : left n2 n3) ->
    (h_house_3_left_of_4 : left n3 n4) ->
    (h_house_4_left_of_5 : left n4 n5) ->
    (h_house_1_not_nextto_3 : Not (nextto n1 n3)) ->
    (h_house_1_not_nextto_4 : Not (nextto n1 n4)) ->
    (h_house_1_not_nextto_5 : Not (nextto n1 n5)) ->
    (h_house_2_not_nextto_4 : Not (nextto n2 n4)) ->
    (h_house_2_not_nextto_5 : Not (nextto n2 n5)) ->
    (h_house_3_not_nextto_5 : Not (nextto n3 n5)) ->
    (h_house_3_has_milk : hasdrink n3 milk) ->
    (h_house_1_has_russian : hasperson n1 russian) ->
    (h_neg_conjecture : forall (X0 X1 X2 X3 X4 X5 X6 X7 X8 X9 X10 X11 X11a X12 X13 X14 X15 X16 X17 X18 X19 X20 X21 X22 X23 : Entity),
        Or (Not (hasperson n1 X0)) (Or (Not (hasperson n2 X1)) (Or (Not (hasperson n3 X2)) (Or (Not (hasperson n4 X3)) (Or (Not (hasperson n5 X4)) (Or (Not (hascolor n1 X5)) (Or (Not (hascolor n2 X6)) (Or (Not (hascolor n3 X7)) (Or (Not (hascolor n4 X8)) (Or (Not (hascolor n5 X9)) (Or (Not (hasdrink n1 X10)) (Or (Not (hasdrink n2 X11)) (Or (Not (hasdrink n3 X11a)) (Or (Not (hasdrink n4 X12)) (Or (Not (hasdrink n5 X13)) (Or (Not (hasgame n1 X14)) (Or (Not (hasgame n2 X15)) (Or (Not (hasgame n3 X16)) (Or (Not (hasgame n4 X17)) (Or (Not (hasgame n5 X18)) (Or (Not (haspet n1 X19)) (Or (Not (haspet n2 X20)) (Or (Not (haspet n3 X21)) (Or (Not (haspet n4 X22)) (Not (haspet n5 X23)))))))))))))))))))))))))) ->
    False
:= by
    decide_cbv
