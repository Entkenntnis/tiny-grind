theorem letters_puzzle :
    (dated : Prop) ->
    (on_blue_paper : Prop) ->
    (in_third_person : Prop) ->
    (in_black_ink : Prop) ->
    (can_be_read : Prop) ->
    (filed : Prop) ->
    (on_one_sheet : Prop) ->
    (crossed : Prop) ->
    (by_brown : Prop) ->
    (begins_with_dear_sir : Prop) ->
    -- (1) All the dated letters in this room are written on blue paper.
    (h1 : dated -> on_blue_paper) ->
    -- (2) None of them are in black ink except those that are written in the third person.
    (h2 : in_third_person -> in_black_ink) ->
    (h3 : in_black_ink -> in_third_person) ->
    -- (3) I have not filed any of them that I can read.
    (h4 : can_be_read -> Not filed) ->
    -- (4) None of them that are written on one sheet are undated.
    (h5 : on_one_sheet -> dated) ->
    -- (5) All of them that are not crossed are in black ink.
    (h6 : Or crossed in_black_ink) ->
    -- (6) All of them written by Brown begin with "Dear Sir"
    (h7 : by_brown -> begins_with_dear_sir) ->
    -- (7) All of them written on blue paper are filed.
    (h8 : on_blue_paper -> filed) ->
    -- (8) None of them written on more than one sheet are crossed.
    (h9 : Or on_one_sheet (Not crossed)) ->
    -- (9) None of them that begin with "Dear Sir" are written in third person.
    (h10 : begins_with_dear_sir -> Not in_third_person) ->
    -- (hypothesis) There is a letter written by Brown.
    (h_by_brown : by_brown) ->
    -- Conclusion: Letters by Brown cannot be read.
    Not can_be_read
:= by
  grind
