def z : Prop := True
def z_1 : Prop := True

-- Accepts an invalid proof because 'x' is renamed to 'z_1' during alpha-equivalence, 
-- and whnf blithely evaluates the local 'z_1' into the global 'True'.
def GlobalShadowingHole : @Eq (Prop -> Prop) (fun (x : Prop) => x) (fun (y : Prop) => z) :=
  @Eq.refl (Prop -> Prop) (fun (x : Prop) => x)