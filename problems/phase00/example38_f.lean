def phase00_example38_f :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (f : A -> A) ->
    (g : A -> A) ->
    @Eq A a b ->
    @Eq A (f a) (g b) :=
  by grind
