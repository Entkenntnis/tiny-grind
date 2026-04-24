from core.eval import whnf
from core.logic import substitute
from core.syntax import (
    Ann,
    App,
    ElabTactic,
    Lam,
    Let,
    Pi,
    Sort,
    Term,
    Var,
)
from core.checker import TypeError, TypeChecker, Context

from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from core.kernel import Kernel


class ElaborationError(Exception):
    pass


# The elaborator is not completely clever yet, but should be "good enough" for the start
class Elaborator:
    def __init__(self, kernel: Kernel) -> None:
        self.kernel: Kernel = kernel

    def elaborate(self, term: Term, ctx: Context, expected_type: Term | None) -> Term:
        """
        Recursively elaborate `term` in context `ctx`.
        `expected_type` is the type that the surrounding program expects for this term
        (if known). Tactics need this information.
        """
        match term:
            case ElabTactic(name):
                if expected_type is None:
                    raise ElaborationError(
                        f"Cannot use '{name}' here: no expected type available"
                    )
                if name == "sorry":
                    return self._sorry(expected_type, ctx)
                if name == "grind":
                    return self._grind(expected_type, ctx)
                raise ElaborationError(f"Unknown tactci '{name}'")

            case Var(_) | Sort(_):
                return term

            case Ann(inner, ann_type):
                new_ann_type = self.elaborate(ann_type, ctx, None)
                new_inner = self.elaborate(inner, ctx, new_ann_type)
                return Ann(new_inner, new_ann_type)

            case App(m, n):
                new_m = self.elaborate(m, ctx, None)
                # Try to infer the argument type from the function part.
                arg_type: Term | None = None
                try:
                    checker = TypeChecker(
                        self.kernel.globals, self.kernel.reducers, ctx
                    )
                    m_type = checker.infer(new_m)
                    m_whnf = whnf(m_type, self.kernel.globals, self.kernel.reducers)
                    if isinstance(m_whnf, Pi):
                        arg_type = m_whnf.var_type
                except TypeError:
                    pass
                new_n = self.elaborate(n, ctx, arg_type)
                return App(new_m, new_n)

            case Lam(var, var_type, body):
                new_var_type = self.elaborate(var_type, ctx, None)
                body_expected: Term | None = None
                if expected_type is not None:
                    exp_whnf = whnf(
                        expected_type, self.kernel.globals, self.kernel.reducers
                    )
                    if isinstance(exp_whnf, Pi):
                        body_expected = (
                            substitute(exp_whnf.body, exp_whnf.var, Var(var))
                            if exp_whnf.var is not None
                            else exp_whnf.body
                        )
                new_ctx = self._extend_ctx(ctx, var, new_var_type)
                new_body = self.elaborate(body, new_ctx, body_expected)
                return Lam(var, new_var_type, new_body)

            case Pi(var, var_type, body):
                new_var_type = self.elaborate(var_type, ctx, None)
                new_ctx = self._extend_ctx(ctx, var, new_var_type) if var else ctx
                new_body = self.elaborate(body, new_ctx, None)
                return Pi(var, new_var_type, new_body)

            case Let(var, var_type, value, body):
                new_var_type = self.elaborate(var_type, ctx, None)
                new_value = self.elaborate(value, ctx, new_var_type)
                new_ctx = self._extend_ctx(ctx, var, new_var_type)
                new_body = self.elaborate(body, new_ctx, None)
                return Let(var, new_var_type, new_value, new_body)

    def _sorry(self, goal_type: Term, ctx: Context) -> Term:
        """Uses the generic `sorryAx` axiom to close a goal of type `Prop`."""
        # Infer the *type* of the goal – this must be Prop.
        checker = TypeChecker(self.kernel.globals, self.kernel.reducers, ctx)
        try:
            goal_type_type = checker.infer(goal_type)
        except TypeError as e:
            raise ElaborationError(
                f"sorry cannot infer the type of the goal {goal_type}: {e}"
            ) from e

        goal_type_type_whnf = whnf(
            goal_type_type, self.kernel.globals, self.kernel.reducers
        )
        if not isinstance(goal_type_type_whnf, Sort) or goal_type_type_whnf.level != 0:
            raise ElaborationError(
                f"sorry can only close goals of type Prop. Goal {goal_type} has type {goal_type_type}"
            )

        # sorryAx : (A : Prop) -> A
        return App(Var("sorryAx"), goal_type)

    def _grind(self, goal_type: Term, ctx: Context) -> Var:
        """Simple `grind`: search the context for an exact match."""
        checker = TypeChecker(self.kernel.globals, self.kernel.reducers, ctx)
        for var_name, var_type in reversed(ctx):
            if checker.is_equivalent(var_type, goal_type):
                return Var(var_name)
        raise ElaborationError(f"grind could not solve goal: {goal_type}")

    @staticmethod
    def _extend_ctx(ctx: Context, name: str, var_type: Term) -> Context:
        return ctx + [(name, var_type)]
