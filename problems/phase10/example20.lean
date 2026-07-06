def phase10_example20 :
    (A : Prop) ->
    (B : Prop) ->
    (C : Prop) ->
    (A -> And B C) ->
    And (A -> B) (A -> C) :=
  by grind
