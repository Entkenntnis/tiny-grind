from core.eval import Globals, Reducer, collect_args, whnf
from core.kernel import Kernel
from core.parser import parse_declarations
from core.syntax import App, Axiom, Definition, Term, Var


PRELUDE = """
axiom True : Prop
axiom @True.intro : True
axiom @True.rec : (motive : True -> Prop) -> motive @True.intro -> (t : True) -> motive t

axiom False : Prop
axiom @False.rec : (motive : False -> Prop) -> (t : False) -> motive t

def Not : Prop -> Prop := fun (A : Prop) => A -> False

axiom And : Prop -> Prop -> Prop
axiom @And.intro : (A : Prop) -> (B : Prop) -> A -> B -> And A B
axiom @And.rec : (A : Prop) -> (B : Prop) -> (motive : And A B -> Prop) -> ((a : A) -> (b : B) -> motive (@And.intro A B a b)) -> (t : And A B) -> motive t

axiom Or : Prop -> Prop -> Prop
axiom @Or.inl : (A : Prop) -> (B : Prop) -> A -> Or A B
axiom @Or.inr : (A : Prop) -> (B : Prop) -> B -> Or A B
axiom @Or.rec : (A : Prop) -> (B : Prop) -> (motive : Or A B -> Prop) -> ((a : A) -> motive (@Or.inl A B a)) -> ((b : B) -> motive (@Or.inr A B b)) -> (t : Or A B) -> motive t

axiom @Eq : (A : Type) -> A -> A -> Prop
axiom @Eq.refl : (A : Type) -> (a : A) -> @Eq A a a
axiom @Eq.rec : (A : Type) -> (a : A) -> (motive : (x : A) -> @Eq A a x -> Prop) -> motive a (@Eq.refl A a) -> (b : A) -> (t : @Eq A a b) -> motive b t


"""


def reduce_true_rec(
    args: list[Term], globals: Globals, reducers: dict[str, Reducer]
) -> Term | None:
    if len(args) < 3:
        return None

    # args[0] = motive
    # args[1] = minor premise
    # args[2] = target

    proof = whnf(args[2], globals, reducers)
    head, p_args = collect_args(proof)

    # Rule: @True.rec motive minor @True.intro ==> minor
    if isinstance(head, Var) and head.name == "@True.intro" and len(p_args) == 0:
        result = args[1]

        # Apply any remaining arguments if the application was over-saturated
        for extra_arg in args[3:]:
            result = App(result, extra_arg)

        return result

    return None


def reduce_and_rec(
    args: list[Term], globals: Globals, reducers: dict[str, Reducer]
) -> Term | None:
    if len(args) < 5:
        return None

    # args[0] = A
    # args[1] = B
    # args[2] = motive
    # args[3] = "builder"
    # args[4] = proof

    proof = whnf(args[4], globals, reducers)
    head, p_args = collect_args(proof)

    # Rule: @And.rec A B motive builder (@And.intro A B a b) ==> builder a b
    if isinstance(head, Var) and head.name == "@And.intro" and len(p_args) == 4:
        a, b = p_args[2], p_args[3]

        result = App(App(args[3], a), b)

        # Apply any remaining arguments if the application was over-saturated
        for extra_arg in args[5:]:
            result = App(result, extra_arg)

        return result

    return None


def reduce_or_rec(
    args: list[Term], globals: Globals, reducers: dict[str, Reducer]
) -> Term | None:
    if len(args) < 6:
        return None

    # args[0] = A, args[1] = B, args[2] = motive
    # args[3] = minor_l, args[4] = minor_r, args[5] = target

    proof = whnf(args[5], globals, reducers)
    head, p_args = collect_args(proof)

    if isinstance(head, Var) and len(p_args) == 3:
        if head.name == "@Or.inl":
            result = App(args[3], p_args[2])
        elif head.name == "@Or.inr":
            result = App(args[4], p_args[2])
        else:
            return None

        for extra_arg in args[6:]:
            result = App(result, extra_arg)

        return result

    return None


def reduce_eq_rec(
    args: list[Term], globals: Globals, reducers: dict[str, Reducer]
) -> Term | None:
    if len(args) < 6:
        return None

    # args[0] = A
    # args[1] = a
    # args[2] = motive
    # args[3] = minor premise (the proof for the refl case)
    # args[4] = b
    # args[5] = target (the proof of @Eq A a b)

    proof = whnf(args[5], globals, reducers)
    head, p_args = collect_args(proof)

    # Rule: @Eq.rec A a motive minor b (@Eq.refl A' a') ==> minor
    if isinstance(head, Var) and head.name == "@Eq.refl" and len(p_args) == 2:
        result = args[3]

        # Apply any remaining arguments if the application was over-saturated
        for extra_arg in args[6:]:
            result = App(result, extra_arg)

        return result

    return None


def load_prelude(kernel: Kernel):
    kernel.register_reducer("@True.rec", reduce_true_rec)
    kernel.register_reducer("@And.rec", reduce_and_rec)
    kernel.register_reducer("@Or.rec", reduce_or_rec)
    kernel.register_reducer("@Eq.rec", reduce_eq_rec)

    decls = parse_declarations(PRELUDE)
    for d in decls:
        match d:
            case Axiom():
                kernel.add_axiom(d)
            case Definition():
                kernel.add_definition(d)
