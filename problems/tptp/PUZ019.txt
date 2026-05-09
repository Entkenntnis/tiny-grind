-- Exceeding Heartbearts

def jobs_puzzle :
  (People : Type) ->
  (Jobs : Type) ->
  (roberta : People) ->
  (thelma : People) ->
  (pete : People) ->
  (steve : People) ->
  (chef : Jobs) ->
  (guard : Jobs) ->
  (nurse : Jobs) ->
  (operator : Jobs) ->
  (police : Jobs) ->
  (teacher : Jobs) ->
  (actor : Jobs) ->
  (boxer : Jobs) ->
  (has_job : People -> Jobs -> Prop) ->
  (equal_people : People -> People -> Prop) ->
  (equal_jobs : Jobs -> Jobs -> Prop) ->
  (male : People -> Prop) ->
  (female : People -> Prop) ->
  (educated : People -> Prop) ->
  (husband : People -> People -> Prop) ->
  (h_eq_people_refl : forall (X : People), equal_people X X) ->
  (h_eq_jobs_refl : forall (X : Jobs), equal_jobs X X) ->
  (h_eq_people_sym : forall (X : People) (Y : People), equal_people X Y -> equal_people Y X) ->
  (h_eq_jobs_sym : forall (X : Jobs) (Y : Jobs), equal_jobs X Y -> equal_jobs Y X) ->
  (h_roberta_not_thelma : Not (equal_people roberta thelma)) ->
  (h_roberta_not_pete : Not (equal_people roberta pete)) ->
  (h_roberta_not_steve : Not (equal_people roberta steve)) ->
  (h_pete_not_thelma : Not (equal_people pete thelma)) ->
  (h_pete_not_steve : Not (equal_people pete steve)) ->
  (h_thelma_not_steve : Not (equal_people thelma steve)) ->
  (h_chef_not_guard : Not (equal_jobs chef guard)) ->
  (h_chef_not_nurse : Not (equal_jobs chef nurse)) ->
  (h_chef_not_operator : Not (equal_jobs chef operator)) ->
  (h_chef_not_police : Not (equal_jobs chef police)) ->
  (h_chef_not_actor : Not (equal_jobs chef actor)) ->
  (h_chef_not_boxer : Not (equal_jobs chef boxer)) ->
  (h_chef_not_teacher : Not (equal_jobs chef teacher)) ->
  (h_guard_not_nurse : Not (equal_jobs guard nurse)) ->
  (h_guard_not_operator : Not (equal_jobs guard operator)) ->
  (h_guard_not_police : Not (equal_jobs guard police)) ->
  (h_guard_not_actor : Not (equal_jobs guard actor)) ->
  (h_guard_not_boxer : Not (equal_jobs guard boxer)) ->
  (h_guard_not_teacher : Not (equal_jobs guard teacher)) ->
  (h_nurse_not_operator : Not (equal_jobs nurse operator)) ->
  (h_nurse_not_police : Not (equal_jobs nurse police)) ->
  (h_nurse_not_actor : Not (equal_jobs nurse actor)) ->
  (h_nurse_not_boxer : Not (equal_jobs nurse boxer)) ->
  (h_nurse_not_teacher : Not (equal_jobs nurse teacher)) ->
  (h_operator_not_police : Not (equal_jobs operator police)) ->
  (h_operator_not_actor : Not (equal_jobs operator actor)) ->
  (h_operator_not_boxer : Not (equal_jobs operator boxer)) ->
  (h_operator_not_teacher : Not (equal_jobs operator teacher)) ->
  (h_police_not_actor : Not (equal_jobs police actor)) ->
  (h_police_not_boxer : Not (equal_jobs police boxer)) ->
  (h_police_not_teacher : Not (equal_jobs police teacher)) ->
  (h_actor_not_boxer : Not (equal_jobs actor boxer)) ->
  (h_actor_not_teacher : Not (equal_jobs actor teacher)) ->
  (h_boxer_not_teacher : Not (equal_jobs boxer teacher)) ->
  (h_nurse_is_male : forall (X : People), has_job X nurse -> male X) ->
  (h_actor_is_male : forall (X : People), has_job X actor -> male X) ->
  (h_chef_is_female : forall (X : People), has_job X chef -> female X) ->
  (h_nurse_is_educated : forall (X : People), has_job X nurse -> educated X) ->
  (h_teacher_is_educated : forall (X : People), has_job X teacher -> educated X) ->
  (h_police_is_educated : forall (X : People), has_job X police -> educated X) ->
  (h_chef_not_police_mutex : forall (X : People), has_job X chef -> has_job X police -> False) ->
  (h_males_not_female : forall (X : People), male X -> female X -> False) ->
  (h_male_or_female : forall (X : People), Or (male X) (female X)) ->
  (h_husband_male : forall (X : People) (Y : People), husband X Y -> male Y) ->
  (h_wife_female : forall (X : People) (Y : People), husband X Y -> female X) ->
  (h_husband_of_chef_op1 : forall (X : People) (Y : People), has_job X chef -> has_job Y operator -> husband X Y) ->
  (h_husband_of_chef_op2 : forall (X : People) (Y : People), has_job X chef -> husband X Y -> has_job Y operator) ->
  (h_job_unique : forall (X : People) (Y : People) (Z : Jobs), has_job X Z -> has_job Y Z -> equal_people X Y) ->
  (h_max_two_jobs : forall (Z : People) (U : Jobs) (X : Jobs) (Y : Jobs), has_job Z U -> has_job Z X -> has_job Z Y -> Or (equal_jobs U X) (Or (equal_jobs U Y) (equal_jobs X Y))) ->
  (h_every_job_used : forall (X : Jobs), Or (has_job roberta X) (Or (has_job thelma X) (Or (has_job pete X) (has_job steve X)))) ->
  (h_everyone_works : forall (X : People), Or (has_job X chef) (Or (has_job X guard) (Or (has_job X nurse) (Or (has_job X operator) (Or (has_job X police) (Or (has_job X teacher) (Or (has_job X actor) (has_job X boxer)))))))) ->
  (h_pete_not_educated : Not (educated pete)) ->
  (h_roberta_not_chef : Not (has_job roberta chef)) ->
  (h_roberta_not_boxer : Not (has_job roberta boxer)) ->
  (h_roberta_not_police : Not (has_job roberta police)) ->
  (h_steve_male : male steve) ->
  (h_pete_male : male pete) ->
  (h_roberta_female : female roberta) ->
  (h_thelma_female : female thelma) ->
  (h_neg_conj : forall (X1 : People) (X2 : People) (X3 : People) (X4 : People) (X5 : People) (X6 : People) (X7 : People) (X8 : People), has_job X1 chef -> has_job X2 guard -> has_job X3 nurse -> has_job X4 operator -> has_job X5 police -> has_job X6 teacher -> has_job X7 actor -> has_job X8 boxer -> False) ->
  False
:= by
  grind (instances := 10000)
