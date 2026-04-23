def MkType : Prop -> Type := fun (p : Prop) => Prop
axiom F : (p : Prop) -> MkType True
axiom f_arg : Prop
axiom f_val : F f_arg

-- Kernel evaluation of 'test2':
-- defn.type is App(F, f_arg)
-- infer(App(F, f_arg)) substitutes 'f_arg' into the Pi body 'MkType True'.
-- The result is the unreduced App(MkType, True).
-- isinstance(App(MkType, True), Sort) evaluates to False.
-- REJECTED.
def test2 : F f_arg := f_val