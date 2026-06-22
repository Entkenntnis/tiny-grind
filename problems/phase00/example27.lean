def phase00_example27 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (f : A -> A -> A) ->
    @Eq A a b ->
    @Eq A (f c a) (f c b) :=
  by grind
