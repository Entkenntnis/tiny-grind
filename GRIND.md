# GRIND reverse engineering

## Example 1

When x = y, then from P x follows P y.

```
def basic_subst : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y: A) -> @Eq A x y -> P x -> P y := 
    by grind
```

Low-level kernel proof:

```
def basic_subst_proof : ∀ (A : Type) (P : A → Prop) (x y : A) (h : @Eq.{1} A x y) (h_1 : P x), P y :=
fun (A : Type) (P : A → Prop) (x y : A) (h : @Eq.{1} A x y) (h_1 : P x) =>
  @Classical.byContradiction (P y) fun (h_2 : Not (P y)) =>
    @id.{0} False
      (@Eq.mp.{0} True False
        (@Eq.trans.{1} Prop True (P y) False
          (@Eq.trans.{1} Prop True (P x) (P y) (@Eq.symm.{1} Prop (P x) True (@eq_true (P x) h_1))
            (@eq_of_heq.{1} Prop (P x) (P y)
              ((fun (a a' : A) (e_1 : @Eq.{1} A a a') =>
                  @Eq.ndrec.{0, 1} A a (fun (a' : A) => @HEq.{1} Prop (P a) Prop (P a')) (@HEq.refl.{1} Prop (P a)) a'
                    e_1)
                x y h)))
          (@eq_false (P y) h_2))
        True.intro)
```


## Example 2

Let'S go one step further, x = y, y = z and z = w, now from P x follows P w.

```
def chaining : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> (z : A) -> (w : A) -> @Eq A x y -> @Eq A y z -> @Eq A z w -> P x -> P w :=
    by grind
```

Low-level kernel proof:

```
def chaining_proof : ∀ (A : Type) (P : A → Prop) (x y z w : A) (h : @Eq.{1} A x y) (h_1 : @Eq.{1} A y z)
  (h_2 : @Eq.{1} A z w) (h_3 : P x), P w :=
fun (A : Type) (P : A → Prop) (x y z w : A) (h : @Eq.{1} A x y) (h_1 : @Eq.{1} A y z) (h_2 : @Eq.{1} A z w)
    (h_3 : P x) =>
  @Classical.byContradiction (P w) fun (h_4 : Not (P w)) =>
    @id.{0} False
      (@Eq.mp.{0} True False
        (@Eq.trans.{1} Prop True (P w) False
          (@Eq.trans.{1} Prop True (P x) (P w) (@Eq.symm.{1} Prop (P x) True (@eq_true (P x) h_3))
            (@eq_of_heq.{1} Prop (P x) (P w)
              ((fun (a a' : A) (e_1 : @Eq.{1} A a a') =>
                  @Eq.ndrec.{0, 1} A a (fun (a' : A) => @HEq.{1} Prop (P a) Prop (P a')) (@HEq.refl.{1} Prop (P a)) a'
                    e_1)
                x w (@Eq.trans.{1} A x z w (@Eq.trans.{1} A x y z h h_1) h_2))))
          (@eq_false (P w) h_4))
        True.intro)
```

## Example 3

Pass the equality a = b through double application of f.

```
def congruence_on_functions : (A: Type) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a b -> f (f a) = f (f b) :=
    by grind
```

Low-level kernel proof:

```
def congruence_on_functions_proof : ∀ (A : Type) (a b : A) (f : A → A) (h : @Eq.{1} A a b),
  @Eq.{1} A (f (f a)) (f (f b)) :=
fun (A : Type) (a b : A) (f : A → A) (h : @Eq.{1} A a b) =>
  @Classical.byContradiction (@Eq.{1} A (f (f a)) (f (f b))) fun (h_1 : Not (@Eq.{1} A (f (f a)) (f (f b)))) =>
    @id.{0} False
      (@Eq.mp.{0} True False
        (@Eq.trans.{1} Prop True (@Eq.{1} A (f (f a)) (f (f b))) False
          (@Eq.symm.{1} Prop (@Eq.{1} A (f (f a)) (f (f b))) True
            (@eq_true (@Eq.{1} A (f (f a)) (f (f b)))
              (@eq_of_heq.{1} A (f (f a)) (f (f b))
                ((fun (a a' : A) (e_1 : @Eq.{1} A a a') =>
                    @Eq.ndrec.{0, 1} A a (fun (a' : A) => @HEq.{1} A (f a) A (f a')) (@HEq.refl.{1} A (f a)) a' e_1)
                  (f a) (f b)
                  (@eq_of_heq.{1} A (f a) (f b)
                    ((fun (a a' : A) (e_1 : @Eq.{1} A a a') =>
                        @Eq.ndrec.{0, 1} A a (fun (a' : A) => @HEq.{1} A (f a) A (f a')) (@HEq.refl.{1} A (f a)) a' e_1)
                      a b h))))))
          (@eq_false (@Eq.{1} A (f (f a)) (f (f b))) h_1))
        True.intro)
```

## Example 4

Deeper equality and function calls.

```
def deeper : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) ->
    @Eq A a (f b) -> @Eq A (f b) (g c) -> @Eq A (g c) (h d) -> @Eq A d a ->
    g (f (h a)) = g (f (g c)) :=
  by grind
```

Low-level kernel proof:

```
def deeper_proof : ∀ (A : Type) (a b c d : A) (f g h : A → A) (h_1 : @Eq.{1} A a (f b))
  (h_2 : @Eq.{1} A (f b) (g c)) (h_3 : @Eq.{1} A (g c) (h d)) (h_4 : @Eq.{1} A d a),
  @Eq.{1} A (g (f (h a))) (g (f (g c))) :=
fun (A : Type) (a b c d : A) (f g h : A → A) (h_1 : @Eq.{1} A a (f b)) (h_2 : @Eq.{1} A (f b) (g c))
    (h_3 : @Eq.{1} A (g c) (h d)) (h_4 : @Eq.{1} A d a) =>
  @Classical.byContradiction (@Eq.{1} A (g (f (h a))) (g (f (g c))))
    fun (h_5 : Not (@Eq.{1} A (g (f (h a))) (g (f (g c))))) =>
    @id.{0} False
      (@Eq.mp.{0} True False
        (@Eq.trans.{1} Prop True (@Eq.{1} A (g (f (h a))) (g (f (g c)))) False
          (@Eq.symm.{1} Prop (@Eq.{1} A (g (f (h a))) (g (f (g c)))) True
            (@eq_true (@Eq.{1} A (g (f (h a))) (g (f (g c))))
              (@eq_of_heq.{1} A (g (f (h a))) (g (f (g c)))
                ((fun (a a' : A) (e_1 : @Eq.{1} A a a') =>
                    @Eq.ndrec.{0, 1} A a (fun (a' : A) => @HEq.{1} A (g a) A (g a')) (@HEq.refl.{1} A (g a)) a' e_1)
                  (f (h a)) (f (g c))
                  (@eq_of_heq.{1} A (f (h a)) (f (g c))
                    ((fun (a a' : A) (e_1 : @Eq.{1} A a a') =>
                        @Eq.ndrec.{0, 1} A a (fun (a' : A) => @HEq.{1} A (f a) A (f a')) (@HEq.refl.{1} A (f a)) a' e_1)
                      (h a) (g c)
                      (@Eq.trans.{1} A (h a) (h d) (g c)
                        (@eq_of_heq.{1} A (h a) (h d)
                          ((fun (a a' : A) (e_1 : @Eq.{1} A a a') =>
                              @Eq.ndrec.{0, 1} A a (fun (a' : A) => @HEq.{1} A (h a) A (h a')) (@HEq.refl.{1} A (h a))
                                a' e_1)
                            a d (@Eq.symm.{1} A d a h_4)))
                        (@Eq.symm.{1} A (g c) (h d) h_3))))))))
          (@eq_false (@Eq.{1} A (g (f (h a))) (g (f (g c)))) h_5))
        True.intro)
```















