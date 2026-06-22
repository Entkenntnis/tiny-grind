def phase00_example12 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (f : A -> A) ->
    (g : A -> A) ->
    (h : A -> A) ->
    @Eq A (f a) b ->
    @Eq A b (g c) ->
    @Eq A (g c) (h a) ->
    @Eq A (f a) (h a) :=
  by grind
