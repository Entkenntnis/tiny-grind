def mars_venus_puzzle :
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
    (ork : Person) ->
    (bog : Person) ->
    (bog_is_from_venus : Statement) ->
    (ork_is_from_mars : Statement) ->
    (bog_is_male : Statement) ->
    (ork_is_female : Statement) ->
    -- Axioms from PUZ001-0.ax
    (h_from_mars_or_venus : forall (X : Person), Or (from_mars X) (from_venus X)) ->
    (h_not_both_mars_venus : forall (X : Person), Not (And (from_mars X) (from_venus X))) ->
    (h_male_or_female : forall (X : Person), Or (male X) (female X)) ->
    (h_not_both_male_female : forall (X : Person), Not (And (male X) (female X))) ->
    (h_truthteller_or_liar : forall (X : Person), Or (truthteller X) (liar X)) ->
    (h_not_both_truthteller_liar : forall (X : Person), Not (And (truthteller X) (liar X))) ->
    -- tautology (included for completeness)
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
    -- Problem-specific hypotheses
    (h_ork_says_bog_venus : says ork bog_is_from_venus) ->
    (h_bog_says_ork_mars : says bog ork_is_from_mars) ->
    (h_ork_says_bog_male : says ork bog_is_male) ->
    (h_bog_says_ork_female : says bog ork_is_female) ->
    (h_bog_venus1 : Not (a_truth bog_is_from_venus) -> from_venus bog) ->
    (h_ork_mars1 : Not (a_truth ork_is_from_mars) -> from_mars ork) ->
    (h_bog_male1 : Not (a_truth bog_is_male) -> male bog) ->
    (h_ork_female1 : Not (a_truth ork_is_female) -> female ork) ->
    (h_bog_venus2 : from_venus bog -> a_truth bog_is_from_venus) ->
    (h_ork_mars2 : from_mars ork -> a_truth ork_is_from_mars) ->
    (h_bog_male2 : male bog -> a_truth bog_is_male) ->
    (h_ork_female2 : female ork -> a_truth ork_is_female) ->
    -- Conclusion: Bog is not female
    Not (female bog)
:= by
  grind
