
-- The puzzle:

-- If everyone likes Bruce, and Lyle likes everyone who likes someone,
-- then someone likes everyone.

theorem puzzle :
    (People : Type) ->
    (Likes : People -> People -> Prop) ->
    (bruce : People) ->
    (lyle : People) ->
    (forall (x : People), Likes x bruce) ->
    (wl : People) ->
    (wb : People) ->
    (Not (Likes lyle wl)) ->
    (Not (Likes bruce wb)) ->
    (forall (y : People), forall (z : People), (Likes y z -> Likes lyle y)) ->
    -- pre-instantiate the above statement with bruce/lyle and the witnesses
    -- as grind is not able to do this automatically
    -- let's say this is part of a "preprocessing" step
    (Likes bruce bruce -> Likes lyle bruce) ->
    (Likes bruce lyle -> Likes lyle bruce) ->
    (Likes bruce wb -> Likes lyle bruce) ->
    (Likes bruce wl -> Likes lyle bruce) ->
    (Likes lyle bruce -> Likes lyle lyle) ->
    (Likes lyle lyle -> Likes lyle lyle) ->
    (Likes lyle wb -> Likes lyle lyle) ->
    (Likes lyle wl -> Likes lyle lyle) ->
    (Likes wb bruce -> Likes lyle wb) ->
    (Likes wb lyle -> Likes lyle wb) ->
    (Likes wb wb -> Likes lyle wb) ->
    (Likes wb wl -> Likes lyle wb) ->
    (Likes wl bruce -> Likes lyle wl) ->
    (Likes wl lyle -> Likes lyle wl) ->
    (Likes wl wb -> Likes lyle wl) ->
    (Likes wl wl -> Likes lyle wl) ->
    False := by
  grind
