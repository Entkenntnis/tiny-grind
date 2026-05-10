def mixed_couple_puzzle :
    (Person : Type) ->
    (Statement : Type) ->
    (from_mars : Person -> Prop) ->
    (from_venus : Person -> Prop) ->
    (male : Person -> Prop) ->
    (female : Person -> Prop) ->
    (truthteller : Person -> Prop) ->
    (liar : Person -> Prop) ->
    (says : Person -> Statement -> Prop) ->
    (a_truth : Statement -> Prop) ->
    (statement_by : Person -> Statement) ->
    (a : Person) ->
    (b : Person) ->
    (a_from_mars : Statement) ->
    (a_has_lied : Statement) ->
    -- Base axioms from PUZ001-0.ax
    (h_from_mars_or_venus : forall (X : Person), Or (from_mars X) (from_venus X)) ->
    (h_not_both_mars_venus : forall (X : Person), Not (And (from_mars X) (from_venus X))) ->
    (h_male_or_female : forall (X : Person), Or (male X) (female X)) ->
    (h_not_both_male_female : forall (X : Person), Not (And (male X) (female X))) ->
    (h_truthteller_or_liar : forall (X : Person), Or (truthteller X) (liar X)) ->
    (h_not_both_truthteller_liar : forall (X : Person), Not (And (truthteller X) (liar X))) ->
    (h_taut : forall (X : Person) (Y : Statement), Or (Not (says X Y)) (Or (a_truth Y) (Not (a_truth Y)))) ->
    (h_says_implies_eq : forall (X : Person) (Y : Statement), says X Y -> @Eq Statement Y (statement_by X)) ->
    (h_false_statement_made_by_liar : forall (X : Person), a_truth (statement_by X) -> liar X) ->
    (h_true_statement_made_by_truthteller : forall (X : Person), Not (a_truth (statement_by X)) -> truthteller X) ->
    (h_venus_female_truthteller : forall (X : Person), And (from_venus X) (female X) -> truthteller X) ->
    (h_venus_male_liar : forall (X : Person), And (from_venus X) (male X) -> liar X) ->
    (h_mars_male_truthteller : forall (X : Person), And (from_mars X) (male X) -> truthteller X) ->
    (h_mars_female_liar : forall (X : Person), And (from_mars X) (female X) -> liar X) ->
    (h_truthteller_says_true : forall (X : Person) (Y : Statement), And (truthteller X) (says X Y) -> a_truth Y) ->
    (h_liar_says_false : forall (X : Person) (Y : Statement), And (liar X) (says X Y) -> Not (a_truth Y)) ->
    -- Puzzle specific hypotheses
    (h_a_says_a_from_mars : says a a_from_mars) ->
    (h_b_says_a_has_lied : says b a_has_lied) ->
    (h_a_from_mars1 : Not (from_mars a) -> a_truth a_from_mars) ->
    (h_a_from_mars2 : Not (a_truth a_from_mars) -> from_mars a) ->
    (h_a_from_mars3 : Not (a_truth a_from_mars) -> Not (a_truth (statement_by b))) ->
    (h_a_states : @Eq Statement (statement_by a) a_from_mars) ->
    (h_b_states : @Eq Statement (statement_by b) a_has_lied) ->
    (h_truth_bs_statement : Or (a_truth a_from_mars) (a_truth (statement_by b))) ->
    (h_different_sex1 : Or (from_mars b) (from_mars a)) ->
    (h_different_sex2 : Or (from_venus a) (from_venus b)) ->
    (h_diff_sex_male_female1 : Or (Not (female a)) (male b)) ->
    (h_diff_sex_male_female2 : Or (Not (male a)) (female b)) ->
    -- Conclusion: contradiction (the mixed‑couple assumption is impossible)
    False
:= by
  grind
