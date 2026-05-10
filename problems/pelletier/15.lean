-- this was wrong in the original paper
-- fixed according to errata

theorem pelletier_15 :
    (P : Prop) ->
    (Q : Prop) ->
    (Iff (P -> Q) (Or (Not P) Q)) :=
  by grind
