from core.eval import Globals, Reducer, whnf
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
from frontend.grind import grind
from frontend.sorry import sorry


class ElaborationError(Exception):
    pass


# The elaborator is not completely clever yet, but should be "good enough" for the start
class Elaborator:
    def __init__(self, globals: Globals, reducers: dict[str, Reducer]) -> None:
        self.globals: Globals = globals
        self.reducers: dict[str, Reducer] = reducers

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
                    return sorry(expected_type, ctx, self.globals, self.reducers)
                if name == "grind":
                    return grind(expected_type, ctx, self.globals, self.reducers)
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
                    checker = TypeChecker(self.globals, self.reducers, ctx)
                    m_type = checker.infer(new_m)
                    m_whnf = whnf(m_type, self.globals, self.reducers)
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
                    exp_whnf = whnf(expected_type, self.globals, self.reducers)
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

    @staticmethod
    def _extend_ctx(ctx: Context, name: str, var_type: Term) -> Context:
        return ctx + [(name, var_type)]
