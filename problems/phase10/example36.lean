def phase10_example36 :
    (A : Prop) ->
    (B : Prop) ->
    (C : Prop) ->
    (A -> (B -> C)) -> ((A -> B) -> (A -> C)) :=
  by grind
