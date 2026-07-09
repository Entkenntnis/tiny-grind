def phase10_example41 :
    (A : Prop) ->
    (B : Prop) ->
    (Not (Not A)) ->
    (Not (Not B)) ->
    Not (Not (And A B)) :=
  by grind
