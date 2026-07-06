def phase10_example03 :
    (A: Prop) ->
    (B: Prop) ->
    A ->
    (A -> B) ->
    B :=
  by grind
