def phase00_example07 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    @Eq A a b ->
    @Eq A b a :=
  by grind
