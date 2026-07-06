def phase10_example19 :
    (A : Prop) ->
    (B : Prop) ->
    (C : Prop) ->
    (And A B -> C) ->
    A ->
    B ->
    C :=
  by grind
