def animals_puzzle :
    (Entity : Type) ->
    (in_house : Entity -> Prop) ->
    (cat : Entity -> Prop) ->
    (gazer : Entity -> Prop) ->
    (suitable_pet : Entity -> Prop) ->
    (detested : Entity -> Prop) ->
    (avoided : Entity -> Prop) ->
    (carnivore : Entity -> Prop) ->
    (prowler : Entity -> Prop) ->
    (mouse_killer : Entity -> Prop) ->
    (takes_to_me : Entity -> Prop) ->
    (kangaroo : Entity -> Prop) ->
    (the_kangaroo : Entity) ->
    -- Only cats in house
    (h1 : forall (x : Entity), in_house x -> cat x) ->
    -- Gazing animals are suitable pets
    (h2 : forall (x : Entity), gazer x -> suitable_pet x) ->
    -- Detested animals are avoided
    (h3 : forall (x : Entity), detested x -> avoided x) ->
    -- Carnivores are prowlers
    (h4 : forall (x : Entity), carnivore x -> prowler x) ->
    -- Cats kill mice
    (h5 : forall (x : Entity), cat x -> mouse_killer x) ->
    -- If an animal takes to me, it is in the house
    (h6 : forall (x : Entity), takes_to_me x -> in_house x) ->
    -- Kangaroos are not suitable pets
    (h7 : forall (x : Entity), kangaroo x -> Not (suitable_pet x)) ->
    -- Mouse killers are carnivores
    (h8 : forall (x : Entity), mouse_killer x -> carnivore x) ->
    -- Every animal either takes to me or is detested
    (h9 : forall (x : Entity), Or (takes_to_me x) (detested x)) ->
    -- Prowlers are gazers
    (h10 : forall (x : Entity), prowler x -> gazer x) ->
    -- The kangaroo is a kangaroo
    (h_kangaroo : kangaroo the_kangaroo) ->
    -- Conclusion: I always avoid a kangaroo
    avoided the_kangaroo
:= by
  grind
