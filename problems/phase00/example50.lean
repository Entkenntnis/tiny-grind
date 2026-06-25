def phase00_example50 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (f : A -> A) ->
    @Eq A a b ->
    @Eq A (f (f (f a))) (f (f (f b))) :=
  by grind
