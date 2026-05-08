-- grind failed to find a pattern for
--    h_noone_hates_everyone : ∀ x, ∃ y, ¬ hates x y
-- we pre-specialize the hypothesis to each of the suspects, this should not change the difficulty 

def dreadbury_mansion : (D : Type) -> (agatha : D) -> (butler : D) -> (charles : D) -> 
    (lives : D -> Prop) -> (killed : D -> D -> Prop) -> (hates : D -> D -> Prop) -> (richer : D -> D -> Prop) ->
    (h_exists : @Exists D (fun (x : D) => And (lives x) (killed x agatha))) ->
    (h_only_residents : forall (x : D), lives x -> Or (@Eq D x agatha) (Or (@Eq D x butler) (@Eq D x charles))) ->
    (h_killer_hates : forall (x : D), forall (y : D), killed x y -> hates x y) ->
    (h_killer_not_richer : forall (x : D), forall (y : D), killed x y -> Not (richer x y)) ->
    (h_charles_hates_no_one_agatha_hates : forall (x : D), hates agatha x -> Not (hates charles x)) ->
    (h_agatha_hates_except_butler : forall (x : D), Not (@Eq D x butler) -> hates agatha x) ->
    (h_butler_hates_non_richer_than_agatha : forall (x : D), Not (richer x agatha) -> hates butler x) ->
    (h_butler_hates_agatha_hates : forall (x : D), hates agatha x -> hates butler x) ->
    (h_noone_hates_everyone : forall (x : D), @Exists D (fun (y : D) => Not (hates x y))) ->
    (h_noone_hates_everyone_agatha : @Exists D (fun (y : D) => Not (hates agatha y))) ->
    (h_noone_hates_everyone_butler : @Exists D (fun (y : D) => Not (hates butler y))) ->
    (h_noone_hates_everyone_charles : @Exists D (fun (y : D) => Not (hates charles y))) ->
    (h_agatha_not_butler : Not (@Eq D agatha butler)) ->
    killed agatha agatha :=
  by grind