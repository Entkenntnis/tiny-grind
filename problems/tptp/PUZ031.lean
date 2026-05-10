theorem schubert_steamroller :
    (Entity : Type) ->
    (wolf : Entity -> Prop) ->
    (fox : Entity -> Prop) ->
    (bird : Entity -> Prop) ->
    (caterpillar : Entity -> Prop) ->
    (snail : Entity -> Prop) ->
    (grain : Entity -> Prop) ->
    (plant : Entity -> Prop) ->
    (animal : Entity -> Prop) ->
    (eats : Entity -> Entity -> Prop) ->
    (much_smaller : Entity -> Entity -> Prop) ->
    (a_wolf : Entity) ->
    (a_fox : Entity) ->
    (a_bird : Entity) ->
    (a_caterpillar : Entity) ->
    (a_snail : Entity) ->
    (a_grain : Entity) ->
    -- Axioms: wolf
    (h_wolf_is_animal : forall (x : Entity), wolf x -> animal x) ->
    (h_wolf_exists : wolf a_wolf) ->
    -- Axioms: fox
    (h_fox_is_animal : forall (x : Entity), fox x -> animal x) ->
    (h_fox_exists : fox a_fox) ->
    -- Axioms: bird
    (h_bird_is_animal : forall (x : Entity), bird x -> animal x) ->
    (h_bird_exists : bird a_bird) ->
    -- Axioms: caterpillar
    (h_caterpillar_is_animal : forall (x : Entity), caterpillar x -> animal x) ->
    (h_caterpillar_exists : caterpillar a_caterpillar) ->
    -- Axioms: snail
    (h_snail_is_animal : forall (x : Entity), snail x -> animal x) ->
    (h_snail_exists : snail a_snail) ->
    -- Axioms: grain
    (h_grain_exists : grain a_grain) ->
    (h_grain_is_plant : forall (x : Entity), grain x -> plant x) ->
    -- Axiom: diet of animals
    (h_animal_diet : forall (x : Entity), animal x ->
      Or
        (forall (y : Entity), plant y -> eats x y)
        (forall (y' : Entity), (And (animal y') (And (much_smaller y' x) (@Exists Entity (fun (z : Entity) => And (plant z)  (eats y' z))))) -> eats x y')) ->
    -- Axioms: much_smaller relations
    (h_much_smaller_bird_snail_caterpillar : forall (x : Entity), forall (y : Entity), bird y -> (Or (snail x) (caterpillar x)) -> much_smaller x y) ->
    (h_much_smaller_bird_fox : forall (x : Entity), forall (y : Entity), bird x -> fox y -> much_smaller x y) ->
    (h_much_smaller_fox_wolf : forall (x : Entity), forall (y : Entity), fox x -> wolf y -> much_smaller x y) ->
    -- Axioms: eating habits
    (h_wolf_doesnt_eat_fox_grain : forall (x : Entity), forall (y : Entity), wolf x -> (Or (fox y) (grain y)) -> Not (eats x y)) ->
    (h_bird_eats_caterpillar : forall (x : Entity), forall (y : Entity), bird x -> caterpillar y -> eats x y) ->
    (h_bird_doesnt_eat_snail : forall (x : Entity), forall (y : Entity), bird x -> snail y -> Not (eats x y)) ->
    (h_caterpillar_snail_eat_plant : forall (x : Entity), Or (caterpillar x) (snail x -> @Exists Entity (fun (y : Entity) => And (plant y) (eats x y)))) ->
    -- Conjecture: there exist animals X, Y and a grain Z such that Y eats Z and X eats Y
    @Exists Entity (fun (x : Entity) => @Exists Entity (fun (y : Entity) =>
      And (animal x) (And (animal y) (@Exists Entity (fun (z : Entity) => And (grain z) (And (eats y z) (eats x y)))))))
:= by
  grind
