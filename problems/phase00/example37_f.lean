def phase00_example37_f :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (f : A -> A -> A) ->
    (g : A -> A -> A) ->
    (h : A -> A) ->
    (k : A -> A) ->
    @Eq A a b ->
    @Eq A (f (g a c) (h d)) (f (g b c) (k d)) :=
  by grind
