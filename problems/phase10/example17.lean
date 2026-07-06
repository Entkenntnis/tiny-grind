def phase10_example17 :
    (A : Prop) ->
    (B : Prop) ->
    (C : Prop) ->
    And A (And B C) ->
    And (And A B) C :=
  by grind
