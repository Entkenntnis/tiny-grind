def phase10_example01 :
    (A : Type) ->
    (P : A -> Prop) ->
    (x : A) ->
    (y : A) ->
    And (P x) (@Eq A x y)->
    P y :=
  by grind
