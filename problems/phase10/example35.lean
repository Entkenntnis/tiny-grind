def phase10_example35 :
    (A : Prop) ->
    (B : Prop) ->
    (A -> B) ->
    Or (Not A) B :=
  by grind
