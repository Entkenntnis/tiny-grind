def phase00_example46_f :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (f : A -> A) ->
    @Eq A a b ->
    @Eq A b (f c) ->
    @Eq A a c :=
  by grind
