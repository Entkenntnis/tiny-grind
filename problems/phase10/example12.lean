def phase10_example12 :
    (A : Prop) ->
    (B : Prop) ->
    (C : Prop) ->
    (A -> B) ->
    (B -> C) ->
    A ->
    C :=
  by grind
