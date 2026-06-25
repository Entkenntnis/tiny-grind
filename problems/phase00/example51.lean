def phase00_example51 :
    (A : Type) ->
    (P : A -> Prop) ->
    (Q : A -> Prop) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (f : A -> A) ->
    (g : A -> A) ->
    @Eq A a b ->
    @Eq A c (f b) ->
    P (g a) ->
    Q c ->
    P (g b) :=
  by grind
