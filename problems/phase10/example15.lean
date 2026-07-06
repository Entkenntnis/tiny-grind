def phase10_example15 :
    (A : Prop) ->
    (B : Prop) ->
    (C : Prop) ->
    (A -> B -> C) ->
    B ->
    A ->
    C :=
  by grind
