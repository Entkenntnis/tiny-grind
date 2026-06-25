def phase00_example49 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (e : A) ->
    (f : A) ->
    (g : A) ->
    (h : A) ->
    (F : A -> A -> A) ->
    @Eq A a b ->
    @Eq A b c ->
    @Eq A c d ->
    @Eq A e f ->
    @Eq A f g ->
    @Eq A g h ->
    @Eq A (F a e) (F d h) :=
  by grind
