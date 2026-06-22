theorem pelletier_04 :
    (P : Prop) ->
    (Q : Prop) ->
    (Iff (Not P -> Q) (Not Q -> P)) :=
  by grind
