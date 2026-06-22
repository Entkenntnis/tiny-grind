def phase00_example26 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (f : A -> A -> A) ->
    @Eq A a b ->
    @Eq A (f a c) (f b c) :=
  by grind
