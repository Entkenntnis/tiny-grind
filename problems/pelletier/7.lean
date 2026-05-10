theorem pelletier_7 :
    (P : Prop) ->
    Or P (Not (Not (Not P))) :=
  by grind
