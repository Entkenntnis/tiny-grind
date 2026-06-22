def phase00_example16 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (e : A) ->
    @Eq A a b ->
    @Eq A a c ->
    @Eq A a d ->
    @Eq A e d ->
    @Eq A b e :=
  by grind
