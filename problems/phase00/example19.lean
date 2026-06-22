def phase00_example19 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (e : A) ->
    @Eq A a b ->
    @Eq A b c ->
    @Eq A d e ->
    @Eq A e c ->
    @Eq A a d :=
  by grind
