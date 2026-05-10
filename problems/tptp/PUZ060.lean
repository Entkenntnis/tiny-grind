def food_problem :
    (Entity : Type) ->
    (food : Entity -> Prop) ->
    (likes : Entity -> Entity -> Prop) ->
    (eats : Entity -> Entity -> Prop) ->
    (not_killed_by : Entity -> Entity -> Prop) ->
    (alive : Entity -> Prop) ->
    (Peanuts : Entity) ->
    (John : Entity) ->
    (Bill : Entity) ->
    (Sue : Entity) ->
    (Apples : Entity) ->
    (Chicken : Entity) ->
    -- All food is liked by John
    (h1 : forall (X : Entity), food X -> likes John X) ->
    -- Apples and chicken are food
    (h2 : food Apples) ->
    (h3 : food Chicken) ->
    -- If something is eaten by someone not killed by it, it's food
    (h4 : forall (X : Entity), @Exists Entity (fun (Y : Entity) => And (eats Y X) (not_killed_by Y X)) -> food X) ->
    -- Bill eats peanuts and is alive
    (h5 : eats Bill Peanuts) ->
    (h6 : alive Bill) ->
    -- Sue eats everything Bill eats
    (h7 : forall (X : Entity), eats Bill X -> eats Sue X) ->
    -- Alive beings are not killed by anything
    (h8 : forall (Y : Entity), alive Y -> (forall (X : Entity), not_killed_by Y X)) ->
    -- Conclusion: John likes peanuts
    likes John Peanuts
:= by
  grind
