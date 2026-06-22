theorem interns_problem :
    (day : Type) ->
    (person : Type) ->
    (a : person) ->
    (b : person) ->
    (c : person) ->
    (monday : day) ->
    (tuesday : day) ->
    (wednesday : day) ->
    (thursday : day) ->
    (friday : day) ->
    (sunday : day) ->
    (saturday : day) ->
    (all_on : day -> Prop) ->
    (on : person -> day -> Prop) ->
    (consecutive : day -> day -> Prop) ->
    (same_day : day -> day -> Prop) ->
    (same_person : person -> person -> Prop) ->
    (h_all_on_a_on : forall (X : day), all_on X -> on a X) ->
    (h_all_on_b_on : forall (X : day), all_on X -> on b X) ->
    (h_all_on_c_on : forall (X : day), all_on X -> on c X) ->
    (h_all_on_cond : forall (X : day), And (on a X) (And (on b X) (on c X)) -> all_on X) ->
    (h_all_on_well_defined : forall (X : day) (Y : day), And (all_on X) (all_on Y) -> same_day X Y) ->
    (h_consecutive_sunday_monday : consecutive sunday monday) ->
    (h_consecutive_monday_tuesday : consecutive monday tuesday) ->
    (h_consecutive_tuesday_wednesday : consecutive tuesday wednesday) ->
    (h_consecutive_wednesday_thursday : consecutive wednesday thursday) ->
    (h_consecutive_thursday_friday : consecutive thursday friday) ->
    (h_consecutive_friday_saturday : consecutive friday saturday) ->
    (h_consecutive_saturday_sunday : consecutive saturday sunday) ->
    (h_same_person_refl : forall (X : person), same_person X X) ->
    (h_a_not_b : Not (same_person a b)) ->
    (h_a_not_c : Not (same_person a c)) ->
    (h_b_not_c : Not (same_person b c)) ->
    (h_same_day_refl : forall (X : day), same_day X X) ->
    (h_sunday_not_monday : Not (same_day sunday monday)) ->
    (h_sunday_not_tuesday : Not (same_day sunday tuesday)) ->
    (h_sunday_not_wednesday : Not (same_day sunday wednesday)) ->
    (h_sunday_not_thursday : Not (same_day sunday thursday)) ->
    (h_sunday_not_friday : Not (same_day sunday friday)) ->
    (h_sunday_not_saturday : Not (same_day sunday saturday)) ->
    (h_monday_not_tuesday : Not (same_day monday tuesday)) ->
    (h_monday_not_wednesday : Not (same_day monday wednesday)) ->
    (h_monday_not_thursday : Not (same_day monday thursday)) ->
    (h_monday_not_friday : Not (same_day monday friday)) ->
    (h_monday_not_saturday : Not (same_day monday saturday)) ->
    (h_tuesday_not_wednesday : Not (same_day tuesday wednesday)) ->
    (h_tuesday_not_thursday : Not (same_day tuesday thursday)) ->
    (h_tuesday_not_friday : Not (same_day tuesday friday)) ->
    (h_tuesday_not_saturday : Not (same_day tuesday saturday)) ->
    (h_wednesday_not_thursday : Not (same_day wednesday thursday)) ->
    (h_wednesday_not_friday : Not (same_day wednesday friday)) ->
    (h_wednesday_not_saturday : Not (same_day wednesday saturday)) ->
    (h_thursday_not_friday : Not (same_day thursday friday)) ->
    (h_thursday_not_saturday : Not (same_day thursday saturday)) ->
    (h_friday_not_saturday : Not (same_day friday saturday)) ->
    (h_all_on_one_day : Or (all_on sunday) (Or (all_on monday) (Or (all_on tuesday) (Or (all_on wednesday) (Or (all_on thursday) (Or (all_on friday) (all_on saturday))))))) ->
    (h_not_on_for_3_days : forall (X : day) (Y : day) (Z : day) (W : day) (U : person),
        Not (And (consecutive X Y) (And (consecutive Y Z) (And (consecutive Z W) (And (on U X) (And (on U Y) (on U Z))))))) ->
    (h_no_two_off_twice_together : forall (X : person) (Y : day) (Z : day) (W : person),
        Or (on X Y) (Or (on X Z) (Or (on W Y) (Or (on W Z) (Or (same_person X W) (same_day Y Z)))))) ->
    (h_a_off_sunday : Not (on a sunday)) ->
    (h_a_off_tuesday : Not (on a tuesday)) ->
    (h_a_off_thursday : Not (on a thursday)) ->
    (h_b_off_thursday : Not (on b thursday)) ->
    (h_b_off_saturday : Not (on b saturday)) ->
    (h_c_off_sunday : Not (on c sunday)) ->
    all_on friday
:= by
  grind (instances := 4000)
