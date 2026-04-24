from core.eval import Globals, Reducer
from core.printer import print_term
from core.syntax import Term
from core.checker import Context


def grind(
    goal_type: Term, ctx: Context, _globals: Globals, _reducers: dict[str, Reducer]
) -> Term:
    """Simple `grind`: search the context for an exact match."""
    print(f"[GRIND.DEBUG] goal: {print_term(goal_type)}")
    print(f"[GRIND.DEBUG] ctx: {ctx}")

    raise RuntimeError(f"grind not implemented yet")
