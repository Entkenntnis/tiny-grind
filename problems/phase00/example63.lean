def phase00_example63 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (f : A -> A) ->
    @Eq A a b ->
    @Eq A (f a) (f b) :=
  by grind
