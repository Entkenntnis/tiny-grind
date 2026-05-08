def mislabeled_boxes :
    (Box : Type) ->
    (Fruit : Type) ->
    (boxa : Box) ->
    (boxb : Box) ->
    (boxc : Box) ->
    (apples : Fruit) ->
    (bananas : Fruit) ->
    (oranges : Fruit) ->
    (equal_fruits : Fruit -> Fruit -> Prop) ->
    (equal_boxes : Box -> Box -> Prop) ->
    (contains : Box -> Fruit -> Prop) ->
    (label : Box -> Fruit -> Prop) ->
    -- reflexivity
    (h_refl_fruits : forall (X : Fruit), equal_fruits X X) ->
    (h_refl_boxes : forall (X : Box), equal_boxes X X) ->
    -- label is wrong
    (h_label_wrong : forall (X : Box), forall (Y : Fruit), Not (And (label X Y) (contains X Y))) ->
    -- each fruit is in some box
    (h_each_fruit : forall (X : Fruit), Or (contains boxa X) (Or (contains boxb X) (contains boxc X))) ->
    -- each box contains something
    (h_each_box : forall (X : Box), Or (contains X apples) (Or (contains X bananas) (contains X oranges))) ->
    -- functional: a box contains at most one fruit
    (h_contains_unique_fruit : forall (X : Box), forall (Y : Fruit), forall (Z: Fruit), And (contains X Y) (contains X Z) -> equal_fruits Y Z) ->
    -- functional: a fruit is in at most one box
    (h_contains_unique_box : forall (X : Box), forall (Z : Box), forall (Y : Fruit), And (contains X Y) (contains Z Y) -> equal_boxes X Z) ->
    -- distinct boxes
    (h_boxa_not_boxb : Not (equal_boxes boxa boxb)) ->
    (h_boxb_not_boxc : Not (equal_boxes boxb boxc)) ->
    (h_boxa_not_boxc : Not (equal_boxes boxa boxc)) ->
    -- distinct fruits
    (h_apples_not_bananas : Not (equal_fruits apples bananas)) ->
    (h_bananas_not_oranges : Not (equal_fruits bananas oranges)) ->
    (h_apples_not_oranges : Not (equal_fruits apples oranges)) ->
    -- given labels
    (h_label_a : label boxa apples) ->
    (h_label_b : label boxb oranges) ->
    (h_label_c : label boxc bananas) ->
    -- b contains apples
    (h_b_contains_apples : contains boxb apples) ->
    -- conclusion: a contains bananas and c contains oranges
    And (contains boxa bananas) (contains boxc oranges)
:= by
  grind
