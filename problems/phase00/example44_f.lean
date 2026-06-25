def phase00_example44_f :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (e : A) ->
    (f : A) ->
    (F : A -> A -> A -> A) ->
    @Eq A a d ->
    @Eq A b e ->
    @Eq A c f ->
    @Eq A (F a b d) (F c e f) :=
  by grind
