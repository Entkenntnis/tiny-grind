theorem pelletier_8 :
    (P : Prop) ->
    (Q : Prop) ->
    ((P -> Q) -> P) ->
    P :=
  by grind
