def MkType : Prop -> Type := fun (p : Prop) => Prop
axiom T : MkType True
axiom t_val : T

-- Kernel evaluation of 'test1':
-- defn.type is Var("T")
-- infer(Var("T")) fetches the type of T from globals, yielding App(MkType, True).
-- isinstance(App(MkType, True), Sort) evaluates to False.
-- REJECTED. (Proper WHNF would beta-reduce this to Prop, which is Sort(0)).
def test1 : T := t_val