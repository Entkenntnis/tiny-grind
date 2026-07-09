def phase10_example43 :
    (A : Prop) ->
    (B : Prop) ->
    (C : Prop) ->
    (A -> B) ->
    (Not A -> C) ->
    Or B C :=
  by grind
