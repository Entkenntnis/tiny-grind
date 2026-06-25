def phase00_example47 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (F : A -> A -> A) ->
    (g : A -> A) ->
    (h : A -> A) ->
    @Eq A a c ->
    @Eq A b d ->
    @Eq A (F (g a) (h b)) (F (g c) (h d)) :=
  by grind
