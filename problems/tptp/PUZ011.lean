def common_ocean :
    (Entity : Type) ->
    (ocean : Entity -> Prop) ->
    (borders : Entity -> Entity -> Prop) ->
    (african : Entity -> Prop) ->
    (asian : Entity -> Prop) ->
    (south_american : Entity -> Prop) ->
    (atlantic : Entity) ->
    (indian : Entity) ->
    (brazil : Entity) ->
    (uruguay : Entity) ->
    (venesuela : Entity) ->
    (zaire : Entity) ->
    (nigeria : Entity) ->
    (angola : Entity) ->
    (india : Entity) ->
    (pakistan : Entity) ->
    (iran : Entity) ->
    (somalia : Entity) ->
    (kenya : Entity) ->
    (tanzania : Entity) ->
    (h_ocean_atlantic : ocean atlantic) ->
    (h_ocean_indian : ocean indian) ->
    (h_borders_atlantic_brazil : borders atlantic brazil) ->
    (h_borders_atlantic_uruguay : borders atlantic uruguay) ->
    (h_borders_atlantic_venesuela : borders atlantic venesuela) ->
    (h_borders_atlantic_zaire : borders atlantic zaire) ->
    (h_borders_atlantic_nigeria : borders atlantic nigeria) ->
    (h_borders_atlantic_angola : borders atlantic angola) ->
    (h_borders_indian_india : borders indian india) ->
    (h_borders_indian_pakistan : borders indian pakistan) ->
    (h_borders_indian_iran : borders indian iran) ->
    (h_borders_indian_somalia : borders indian somalia) ->
    (h_borders_indian_kenya : borders indian kenya) ->
    (h_borders_indian_tanzania : borders indian tanzania) ->
    (h_south_american_brazil : south_american brazil) ->
    (h_south_american_uruguay : south_american uruguay) ->
    (h_south_american_venesuela : south_american venesuela) ->
    (h_african_zaire : african zaire) ->
    (h_african_nigeria : african nigeria) ->
    (h_african_angola : african angola) ->
    (h_african_somalia : african somalia) ->
    (h_african_kenya : african kenya) ->
    (h_african_tanzania : african tanzania) ->
    (h_asian_india : asian india) ->
    (h_asian_pakistan : asian pakistan) ->
    (h_asian_iran : asian iran) ->
    @Exists Entity (fun (O : Entity) => @Exists Entity (fun (C1 : Entity) => @Exists Entity (fun (C2 : Entity) =>
      And (ocean O) (And (borders O C1) (And (african C1) (And (borders O C2) (asian C2)))))))
:= by
  grind
