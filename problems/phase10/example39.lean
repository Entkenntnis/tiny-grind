def phase10_example39 :
    (A : Prop) ->
    (B : Prop) ->
    (A -> B) ->
    (Not A -> B) ->
    B :=
  by grind
