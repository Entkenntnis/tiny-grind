def phase10_example34 :
    (A : Prop) ->
    (B : Prop) ->
    Not (And A B) ->
    Or (Not A) (Not B) :=
  by grind
