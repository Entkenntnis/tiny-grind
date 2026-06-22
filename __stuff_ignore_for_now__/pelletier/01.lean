theorem pelletier_01 :
    (P: Prop) ->
    (Q : Prop) ->
    (Iff (P -> Q) (Not Q -> Not P)) :=
  by grind
