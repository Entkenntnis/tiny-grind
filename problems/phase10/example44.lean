def phase10_example44 :
    (A : Prop) ->
    (B : Prop) ->
    (C : Prop) ->
    (A -> Or B C) ->
    (Not A -> Or B C) ->
    Or B C :=
  by grind
