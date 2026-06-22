theorem pelletier_16 :
    (P : Prop) ->
    (Q : Prop) ->
    (Or (P -> Q) (Q -> P)) :=
  by grind
