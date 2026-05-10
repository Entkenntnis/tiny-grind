theorem pelletier_3 :
    (P : Prop) ->
    (Q : Prop) ->
    Not (P -> Q) ->
    Q -> P :=
  by grind
