def InvalidEqAlpha : @Eq (Prop -> Prop -> Prop) (fun (x : Prop) => fun (z : Prop) => x) (fun (y : Prop) => fun (w : Prop) => w) :=
  @Eq.refl (Prop -> Prop -> Prop) (fun (x : Prop) => fun (z : Prop) => x)
