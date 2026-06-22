def phase00_example36_f :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (f : A -> A -> A) ->
    @Eq A (f a b) c ->
    @Eq A a c :=
  by grind
