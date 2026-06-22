def phase00_example34_f :
    (A : Type) ->
    (P : A -> A -> Prop) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    @Eq A a b ->
    P a c ->
    P b d :=
  by grind
