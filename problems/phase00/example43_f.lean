def phase00_example43_f :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (e : A) ->
    (f : A) ->
    (g : A) ->
    (F : A -> A -> A -> A -> A) ->
    @Eq A a e ->
    @Eq A b f ->
    @Eq A (F a b c d) (F e f g d) :=
  by grind
