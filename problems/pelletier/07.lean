theorem pelletier_07 :
    (P : Prop) ->
    Or P (Not (Not (Not P))) :=
  by grind
