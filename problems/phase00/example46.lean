def phase00_example46 :
    (A : Type) ->
    (P : A -> A -> A -> A -> Prop) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (e : A) ->
    (f : A) ->
    (g : A) ->
    (h : A) ->
    @Eq A a e ->
    @Eq A b f ->
    @Eq A c g ->
    @Eq A d h ->
    P a b c d ->
    P e f g h :=
  by grind
