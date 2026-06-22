def phase00_example17 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (f : A -> A) ->
    (g : A -> A) ->
    (h : A -> A) ->
    @Eq A a b ->
    @Eq A (f (g (h a))) (f (g (h b))) :=
  by grind
