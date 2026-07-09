def phase10_example42 :
    (A : Prop) ->
    (B : Prop) ->
    (C : Prop) ->
    (A -> (B -> C)) ->
    (Not A -> (B -> C)) ->
    (B -> C) :=
  by grind
