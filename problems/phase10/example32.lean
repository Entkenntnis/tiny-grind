def phase10_example32 :
    (A : Prop) ->
    (B : Prop) ->
    ((A -> B) -> A) -> A :=
  by grind
