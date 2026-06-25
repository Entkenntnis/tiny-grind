def phase00_example65_f :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (f : A -> A) ->
    @Eq A b c ->
    @Eq A (f a) (f b) :=
  by grind
