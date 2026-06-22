def phase00_example22_f :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (e : A) ->
    @Eq A a b ->
    @Eq A b c ->
    @Eq A d e ->
    @Eq A a d :=
  by grind
