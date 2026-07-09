def phase10_example31 :
    (T : Type) ->
    (P : T -> Prop) ->
    (f : T -> T) ->
    (x : T) ->
    (y : T) ->
    @Eq T x y ->
    ((@Eq T (f x) (f y) -> P x) -> (Not (P y) -> Not (@Eq T (f x) (f y)))) :=
  by grind
