def phase00_example3 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (f : A -> A) ->
    @Eq A a b ->
    @Eq A (f (f a)) (f (f b)) :=
  by grind
