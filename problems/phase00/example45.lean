def phase00_example45 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (e : A) ->
    (f : A) ->
    (g : A) ->
    (h : A) ->
    (F : A -> A -> A -> A -> A) ->
    @Eq A a e ->
    @Eq A b f ->
    @Eq A c g ->
    @Eq A d h ->
    @Eq A (F a b c d) (F e f g h) :=
  by grind
