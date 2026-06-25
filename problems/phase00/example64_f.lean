def phase00_example64_f :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (f : A -> A) ->
    @Eq A (f a) (f b) :=
  by grind
