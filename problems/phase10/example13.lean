def phase10_example13 :
    (A : Prop) ->
    (B : Prop) ->
    And A B ->
    And B A :=
  by grind
