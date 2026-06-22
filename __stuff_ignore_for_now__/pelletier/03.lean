theorem pelletier_03 :
    (P : Prop) ->
    (Q : Prop) ->
    Not (P -> Q) ->
    Q -> P :=
  by grind
