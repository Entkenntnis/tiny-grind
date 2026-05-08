set_option diagnostics true
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
    (a_lion a_unicorn : Day) ->
    -- function and predicates
    (yesterday : Day → Day) ->
    (day monday tuesday wednesday thursday friday saturday sunday : Day → Prop) ->
    (lion_lies unicorn_lies : Day → Prop) ->
    (lies_on_one_of : Day → Day → Day → Prop) ->
    -- Axioms: day constants
    (h_monday : monday a_monday) ->
    (h_tuesday : tuesday a_tuesday) ->
    (h_wednesday : wednesday a_wednesday) ->
    (h_thursday : thursday a_thursday) ->
    (h_friday : friday a_friday) ->
    (h_saturday : saturday a_saturday) ->
    (h_sunday : sunday a_sunday) ->
    -- Axioms: day classification
    (h_monday_is_day : forall (x : Day), monday x → day x) ->
    (h_tuesday_is_day : forall (x : Day), tuesday x → day x) ->
    (h_wednesday_is_day : forall (x : Day), wednesday x → day x) ->
    (h_thursday_is_day : forall (x : Day), thursday x → day x) ->
    (h_friday_is_day : forall (x : Day), friday x → day x) ->
    (h_saturday_is_day : forall (x : Day), saturday x → day x) ->
    (h_sunday_is_day : forall (x : Day), sunday x → day x) ->
    -- Axioms: yesterday follows
    (h_monday_follows_sunday : forall (x : Day), monday x → sunday (yesterday x)) ->
    (h_tuesday_follows_monday : forall (x : Day), tuesday x → monday (yesterday x)) ->
    (h_wednesday_follows_tuesday : forall (x : Day), wednesday x → tuesday (yesterday x)) ->
    (h_thursday_follows_wednesday : forall (x : Day), thursday x → wednesday (yesterday x)) ->
    (h_friday_follows_thursday : forall (x : Day), friday x → thursday (yesterday x)) ->
    (h_saturday_follows_friday : forall (x : Day), saturday x → friday (yesterday x)) ->
    (h_sunday_follows_saturday : forall (x : Day), sunday x → saturday (yesterday x)) ->
    -- Axioms: lion lies / does not lie
    (h_lion_lies_monday : forall (x : Day), monday x → lion_lies x) ->
    (h_lion_lies_tuesday : forall (x : Day), tuesday x → lion_lies x) ->
    (h_lion_lies_wednesday : forall (x : Day), wednesday x → lion_lies x) ->
    (h_lion_not_lies_thursday : forall (x : Day), thursday x → ¬ lion_lies x) ->
    (h_lion_not_lies_friday : forall (x : Day), friday x → ¬ lion_lies x) ->
    (h_lion_not_lies_saturday : forall (x : Day), saturday x → ¬ lion_lies x) ->
    (h_lion_not_lies_sunday : forall (x : Day), sunday x → ¬ lion_lies x) ->
    -- Axioms: unicorn lies / does not lie
    (h_unicorn_not_lies_monday : forall (x : Day), monday x → ¬ unicorn_lies x) ->
    (h_unicorn_not_lies_tuesday : forall (x : Day), tuesday x → ¬ unicorn_lies x) ->
    (h_unicorn_not_lies_wednesday : forall (x : Day), wednesday x → ¬ unicorn_lies x) ->
    (h_unicorn_lies_thursday : forall (x : Day), thursday x → unicorn_lies x) ->
    (h_unicorn_lies_friday : forall (x : Day), friday x → unicorn_lies x) ->
    (h_unicorn_lies_saturday : forall (x : Day), saturday x → unicorn_lies x) ->
    (h_unicorn_not_lies_sunday : forall (x : Day), sunday x → ¬ unicorn_lies x) ->
    -- Axioms: lying implies day
    (h_lion_lies_day : forall (x : Day), lion_lies x → day x) ->
    (h_unicorn_lies_day : forall (x : Day), unicorn_lies x → day x) ->
    -- Axioms: lion and "lies on one of"
    (h_lion_lies_on_this_day : forall (x : Day) Y, day X → day Y → (lion_lies X → lies_on_one_of a_lion X Y → ¬ lion_lies Y)) ->
    (h_lion_lies_on_other_day : forall (x : Day) Y, day X → day Y → (¬ lion_lies X → lies_on_one_of a_lion X Y → lion_lies Y)) ->
    (h_lion_lies_on_neither : forall (x : Day) Y, day X → day Y → (¬ lion_lies X → ¬ lies_on_one_of a_lion X Y → ¬ lion_lies Y)) ->
    (h_lion_lies_on_both : forall (x : Day) Y, day X → day Y → (lion_lies X → ¬ lies_on_one_of a_lion X Y → lion_lies Y)) ->
    -- Axioms: unicorn and "lies on one of"
    (h_unicorn_lies_on_this_day : forall (x : Day) Y, day X → day Y → (unicorn_lies X → lies_on_one_of a_unicorn X Y → ¬ unicorn_lies Y)) ->
    (h_unicorn_lies_on_other_day : forall (x : Day) Y, day X → day Y → (¬ unicorn_lies X → lies_on_one_of a_unicorn X Y → unicorn_lies Y)) ->
    (h_unicorn_lies_on_neither : forall (x : Day) Y, day X → day Y → (¬ unicorn_lies X → ¬ lies_on_one_of a_unicorn X Y → ¬ unicorn_lies Y)) ->
    (h_unicorn_lies_on_both : forall (x : Day) Y, day X → day Y → (unicorn_lies X → ¬ lies_on_one_of a_unicorn X Y → unicorn_lies Y)) ->
    -- Conjecture: there is a day where both lion and unicorn lie about "today or yesterday"
    ∃ x, day x ∧ lies_on_one_of a_lion x (yesterday x) ∧ lies_on_one_of a_unicorn x (yesterday x) := by
  grind? (instances := 2000)
