def phase10_example06 :
    (P : Prop) ->
    (Q : Prop) ->
    (P -> Q) ->
    (Q -> False) ->
    P -> False :=
  by grind
