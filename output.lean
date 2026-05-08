-- Visit https://live.lean-lang.org to verify this file

-- problems/basic/example1.lean
def basic_subst : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> @Eq A x y -> P x -> P y :=
  by grind

def basic_subst_proof : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> @Eq A x y -> P x -> P y :=
  by sorry


-- problems/basic/example2.lean
def chaining : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> (z : A) -> (w : A) -> @Eq A x y -> @Eq A y z -> @Eq A z w -> P x -> P w :=
  by grind

def chaining_proof : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> (z : A) -> (w : A) -> @Eq A x y -> @Eq A y z -> @Eq A z w -> P x -> P w :=
  by sorry


-- problems/basic/example3.lean
def congruence_on_functions : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a b -> @Eq A (f (f a)) (f (f b)) :=
  by grind

def congruence_on_functions_proof : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a b -> @Eq A (f (f a)) (f (f b)) :=
  by sorry


-- problems/basic/example4.lean
def deeper : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A a (f b) -> @Eq A (f b) (g c) -> @Eq A (g c) (h d) -> @Eq A d a -> @Eq A (g (f (h a))) (g (f (g c))) :=
  by grind

def deeper_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A a (f b) -> @Eq A (f b) (g c) -> @Eq A (g c) (h d) -> @Eq A d a -> @Eq A (g (f (h a))) (g (f (g c))) :=
  by sorry


-- problems/tptp/PUZ001.lean
def dreadbury_mansion : (D : Type) -> (agatha : D) -> (butler : D) -> (charles : D) -> (lives : D -> Prop) -> (killed : D -> D -> Prop) -> (hates : D -> D -> Prop) -> (richer : D -> D -> Prop) -> (h_exists : @Exists D (fun (x : D) => And (lives x) (killed x agatha))) -> (h_only_residents : (x : D) -> lives x -> Or (@Eq D x agatha) (Or (@Eq D x butler) (@Eq D x charles))) -> (h_killer_hates : (x : D) -> (y : D) -> killed x y -> hates x y) -> (h_killer_not_richer : (x : D) -> (y : D) -> killed x y -> Not (richer x y)) -> (h_charles_hates_no_one_agatha_hates : (x : D) -> hates agatha x -> Not (hates charles x)) -> (h_agatha_hates_except_butler : (x : D) -> Not (@Eq D x butler) -> hates agatha x) -> (h_butler_hates_non_richer_than_agatha : (x : D) -> Not (richer x agatha) -> hates butler x) -> (h_butler_hates_agatha_hates : (x : D) -> hates agatha x -> hates butler x) -> (h_noone_hates_everyone : (x : D) -> @Exists D (fun (y : D) => Not (hates x y))) -> (h_noone_hates_everyone_agatha : @Exists D (fun (y : D) => Not (hates agatha y))) -> (h_noone_hates_everyone_butler : @Exists D (fun (y : D) => Not (hates butler y))) -> (h_noone_hates_everyone_charles : @Exists D (fun (y : D) => Not (hates charles y))) -> (h_agatha_not_butler : Not (@Eq D agatha butler)) -> killed agatha agatha :=
  by grind

def dreadbury_mansion_proof : (D : Type) -> (agatha : D) -> (butler : D) -> (charles : D) -> (lives : D -> Prop) -> (killed : D -> D -> Prop) -> (hates : D -> D -> Prop) -> (richer : D -> D -> Prop) -> (h_exists : @Exists D (fun (x : D) => And (lives x) (killed x agatha))) -> (h_only_residents : (x : D) -> lives x -> Or (@Eq D x agatha) (Or (@Eq D x butler) (@Eq D x charles))) -> (h_killer_hates : (x : D) -> (y : D) -> killed x y -> hates x y) -> (h_killer_not_richer : (x : D) -> (y : D) -> killed x y -> Not (richer x y)) -> (h_charles_hates_no_one_agatha_hates : (x : D) -> hates agatha x -> Not (hates charles x)) -> (h_agatha_hates_except_butler : (x : D) -> Not (@Eq D x butler) -> hates agatha x) -> (h_butler_hates_non_richer_than_agatha : (x : D) -> Not (richer x agatha) -> hates butler x) -> (h_butler_hates_agatha_hates : (x : D) -> hates agatha x -> hates butler x) -> (h_noone_hates_everyone : (x : D) -> @Exists D (fun (y : D) => Not (hates x y))) -> (h_noone_hates_everyone_agatha : @Exists D (fun (y : D) => Not (hates agatha y))) -> (h_noone_hates_everyone_butler : @Exists D (fun (y : D) => Not (hates butler y))) -> (h_noone_hates_everyone_charles : @Exists D (fun (y : D) => Not (hates charles y))) -> (h_agatha_not_butler : Not (@Eq D agatha butler)) -> killed agatha agatha :=
  by sorry


