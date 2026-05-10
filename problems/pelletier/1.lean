theorem pelletier_1 :
    (P: Prop) ->
    (Q : Prop) ->
    (Iff (P -> Q) (Not Q -> Not P)) :=
  by grind
