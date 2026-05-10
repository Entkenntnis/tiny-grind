theorem pelletier_4 :
    (P : Prop) ->
    (Q : Prop) ->
    (Iff (Not P -> Q) (Not Q -> P)) :=
  by grind
