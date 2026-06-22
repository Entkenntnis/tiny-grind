def phase00_example24_f :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (f : A -> A) ->
    @Eq A a b ->
    @Eq A (f a) (f c) :=
  by grind
