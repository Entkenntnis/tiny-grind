def phase00_example33_f :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (f : A -> A -> A) ->
    @Eq A a b ->
    @Eq A (f a c) (f c b) :=
  by grind
