def phase00_example21_f :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (f : A -> A) ->
    (g : A -> A) ->
    (h : A -> A) ->
    @Eq A a b ->
    @Eq A (f (g a)) (f (h b)) :=
  by grind
