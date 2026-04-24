from core.eval import Globals, Reducer, whnf
from core.syntax import App, Var, Sort, Term
from core.checker import TypeError, TypeChecker, Context


def sorry(
    goal_type: Term, ctx: Context, globals: Globals, reducers: dict[str, Reducer]
) -> Term:
    """Uses the generic `sorryAx` axiom to close a goal of type `Prop`."""
    # Infer the *type* of the goal – this must be Prop.
    checker = TypeChecker(globals, reducers, ctx)
    try:
        goal_type_type = checker.infer(goal_type)
    except TypeError as e:
        raise RuntimeError(
            f"sorry cannot infer the type of the goal {goal_type}: {e}"
        ) from e

    goal_type_type_whnf = whnf(goal_type_type, globals, reducers)
    if not isinstance(goal_type_type_whnf, Sort) or goal_type_type_whnf.level != 0:
        raise RuntimeError(
            f"sorry can only close goals of type Prop. Goal {goal_type} has type {goal_type_type}"
        )

    # sorryAx : (A : Prop) -> A
    return App(Var("sorryAx"), goal_type)
