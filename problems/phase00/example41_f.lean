def phase00_example41_f :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (f : A -> A) ->
    @Eq A (f a) b ->
    @Eq A a (f b) :=
  by grind
