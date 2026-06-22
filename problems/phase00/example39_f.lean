def phase00_example39_f :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    @Eq A a b ->
    @Eq A c d ->
    @Eq A a c :=
  by grind
