def phase00_example48 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (e : A) ->
    (f : A) ->
    (g : A) ->
    @Eq A a b ->
    @Eq A b c ->
    @Eq A c d ->
    @Eq A d e ->
    @Eq A e f ->
    @Eq A f g ->
    @Eq A a g :=
  by grind
