theorem pelletier_08 :
    (P : Prop) ->
    (Q : Prop) ->
    ((P -> Q) -> P) ->
    P :=
  by grind
