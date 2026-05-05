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













