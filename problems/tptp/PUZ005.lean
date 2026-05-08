def lion_and_unicorn :
    -- domain and constants
    (Day : Type) ->
    (a_monday : Day) ->
    (a_tuesday : Day) ->
    (a_wednesday : Day) ->
    (a_thursday : Day) ->
    (a_friday : Day) ->
    (a_saturday : Day) ->
    (a_sunday : Day) ->
    (a_lion : Day) ->
    (a_unicorn : Day) ->
    -- function and predicates
    (yesterday : Day -> Day) ->
    (day : Day -> Prop) ->
    (monday : Day -> Prop) ->
    (tuesday : Day -> Prop) ->
    (wednesday : Day -> Prop) ->
    (thursday : Day -> Prop) ->
    (friday : Day -> Prop) ->
    (saturday : Day -> Prop) ->
    (sunday : Day -> Prop) ->
    (lion_lies : Day -> Prop) ->
    (unicorn_lies : Day -> Prop) ->
    (lies_on_one_of : Day -> Day -> Day -> Prop) ->
    -- Axioms: day constants
    (h_monday : monday a_monday) ->
    (h_tuesday : tuesday a_tuesday) ->
    (h_wednesday : wednesday a_wednesday) ->
    (h_thursday : thursday a_thursday) ->
    (h_friday : friday a_friday) ->
    (h_saturday : saturday a_saturday) ->
    (h_sunday : sunday a_sunday) ->
    -- Axioms: day classification
    (h_monday_is_day : forall (x : Day), monday x -> day x) ->
    (h_tuesday_is_day : forall (x : Day), tuesday x -> day x) ->
    (h_wednesday_is_day : forall (x : Day), wednesday x -> day x) ->
    (h_thursday_is_day : forall (x : Day), thursday x -> day x) ->
    (h_friday_is_day : forall (x : Day), friday x -> day x) ->
    (h_saturday_is_day : forall (x : Day), saturday x -> day x) ->
    (h_sunday_is_day : forall (x : Day), sunday x -> day x) ->
    -- Axioms: yesterday follows
    (h_monday_follows_sunday : forall (x : Day), monday x -> sunday (yesterday x)) ->
    (h_tuesday_follows_monday : forall (x : Day), tuesday x -> monday (yesterday x)) ->
    (h_wednesday_follows_tuesday : forall (x : Day), wednesday x -> tuesday (yesterday x)) ->
    (h_thursday_follows_wednesday : forall (x : Day), thursday x -> wednesday (yesterday x)) ->
    (h_friday_follows_thursday : forall (x : Day), friday x -> thursday (yesterday x)) ->
    (h_saturday_follows_friday : forall (x : Day), saturday x -> friday (yesterday x)) ->
    (h_sunday_follows_saturday : forall (x : Day), sunday x -> saturday (yesterday x)) ->
    -- Axioms: lion lies / does not lie
    (h_lion_lies_monday : forall (x : Day), monday x -> lion_lies x) ->
    (h_lion_lies_tuesday : forall (x : Day), tuesday x -> lion_lies x) ->
    (h_lion_lies_wednesday : forall (x : Day), wednesday x -> lion_lies x) ->
    (h_lion_not_lies_thursday : forall (x : Day), thursday x -> Not (lion_lies x)) ->
    (h_lion_not_lies_friday : forall (x : Day), friday x -> Not (lion_lies x)) ->
    (h_lion_not_lies_saturday : forall (x : Day), saturday x -> Not (lion_lies x)) ->
    (h_lion_not_lies_sunday : forall (x : Day), sunday x -> Not (lion_lies x)) ->
    -- Axioms: unicorn lies / does not lie
    (h_unicorn_not_lies_monday : forall (x : Day), monday x -> Not (unicorn_lies x)) ->
    (h_unicorn_not_lies_tuesday : forall (x : Day), tuesday x -> Not (unicorn_lies x)) ->
    (h_unicorn_not_lies_wednesday : forall (x : Day), wednesday x -> Not (unicorn_lies x)) ->
    (h_unicorn_lies_thursday : forall (x : Day), thursday x -> unicorn_lies x) ->
    (h_unicorn_lies_friday : forall (x : Day), friday x -> unicorn_lies x) ->
    (h_unicorn_lies_saturday : forall (x : Day), saturday x -> unicorn_lies x) ->
    (h_unicorn_not_lies_sunday : forall (x : Day), sunday x -> Not (unicorn_lies x)) ->
    -- Axioms: lying implies day
    (h_lion_lies_day : forall (x : Day), lion_lies x -> day x) ->
    (h_unicorn_lies_day : forall (x : Day), unicorn_lies x -> day x) ->
    -- Axioms: lion and "lies on one of"
    (h_lion_lies_on_this_day : forall (X : Day) (Y : Day), day X -> day Y -> (lion_lies X -> lies_on_one_of a_lion X Y -> Not (lion_lies Y))) ->
    (h_lion_lies_on_other_day : forall (X : Day) (Y : Day), day X -> day Y -> (Not (lion_lies X) -> lies_on_one_of a_lion X Y -> lion_lies Y)) ->
    (h_lion_lies_on_neither : forall (X : Day) (Y : Day), day X -> day Y -> (Not (lion_lies X) -> Not (lies_on_one_of a_lion X Y) -> Not (lion_lies Y))) ->
    (h_lion_lies_on_both : forall (X : Day) (Y : Day), day X -> day Y -> (lion_lies X -> Not (lies_on_one_of a_lion X Y) -> lion_lies Y)) ->
    -- Axioms: unicorn and "lies on one of"
    (h_unicorn_lies_on_this_day : forall (X : Day) (Y : Day), day X -> day Y -> (unicorn_lies X -> lies_on_one_of a_unicorn X Y -> Not (unicorn_lies Y))) ->
    (h_unicorn_lies_on_other_day : forall (X : Day) (Y : Day), day X -> day Y -> (Not (unicorn_lies X) -> lies_on_one_of a_unicorn X Y -> unicorn_lies Y)) ->
    (h_unicorn_lies_on_neither : forall (X : Day) (Y : Day), day X -> day Y -> (Not (unicorn_lies X) -> Not (lies_on_one_of a_unicorn X Y) -> Not (unicorn_lies Y))) ->
    (h_unicorn_lies_on_both : forall (X : Day) (Y : Day), day X -> day Y -> (unicorn_lies X -> Not (lies_on_one_of a_unicorn X Y) -> unicorn_lies Y)) ->
    -- Conjecture: there is a day where both lion and unicorn lie about "today or yesterday"
    @Exists Day (fun (x : Day) => (And (day x) (And (lies_on_one_of a_lion x (yesterday x)) (lies_on_one_of a_unicorn x (yesterday x))))) := by
  grind (instances := 2000)
