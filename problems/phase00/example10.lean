def phase00_example10 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    @Eq A a b ->
    @Eq A a c ->
    @Eq A b d ->
    @Eq A c d :=
  by grind
