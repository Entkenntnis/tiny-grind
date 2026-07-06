def phase10_example04_f :
    (A: Prop) ->
    (B: Prop) ->
    A ->
    (B -> A) ->
    B :=
  by grind
