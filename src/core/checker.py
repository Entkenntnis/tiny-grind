from core.eval import Globals, Reducer, whnf
from core.logic import fresh_name, get_free_vars, substitute
from core.syntax import Ann, App, Lam, Let, Pi, Sort, Term, Var

# mapping of variables and their types
type Context = list[tuple[str, Term]]


class TypeError(Exception):
    pass


class TypeChecker:
    def __init__(
        self, globals: Globals, reducers: dict[str, Reducer], ctx: Context | None = None
    ) -> None:
        self.globals = globals
        self.reducers = reducers
        self.ctx: Context = [] if ctx is None else list(ctx)

    def infer(self, term: Term) -> Term:
        return self._infer(term, self.ctx)

    def check(self, term: Term, expected_type: Term) -> None:
        self._check(term, expected_type, self.ctx)

    def is_equivalent(self, t1: Term, t2: Term) -> bool:
        return self._is_equivalent(t1, t2, self.ctx)

    def _whnf(self, term: Term) -> Term:
        return whnf(term, self.globals, self.reducers)

    def _proof_term_type(self, term: Term, ctx: Context) -> Term | None:
        try:
            term_type = self._whnf(self._infer(term, ctx))
            type_of_term_type = self._whnf(self._infer(term_type, ctx))
        except TypeError:
            return None

        if isinstance(type_of_term_type, Sort) and type_of_term_type.level == 0:
            return term_type
        return None

    def _infer_function_type(self, term: Term, ctx: Context) -> Pi | None:
        try:
            match term:
                case Lam(var, var_type, body):
                    body_type = self._infer(body, self._extend_ctx(ctx, var, var_type))
                    return Pi(var, var_type, body_type)
                case _:
                    inferred = self._whnf(self._infer(term, ctx))
                    if isinstance(inferred, Pi):
                        return inferred
        except TypeError:
            return None
        return None

    def _is_eta_equivalent(self, t1: Term, t2: Term, ctx: Context) -> bool:
        pi1 = self._infer_function_type(t1, ctx)
        pi2 = self._infer_function_type(t2, ctx)
        if pi1 is None or pi2 is None:
            return False

        if not self._is_equivalent(pi1, pi2, ctx):
            return False

        z = self._fresh_name_for(
            "eta", ctx, t1, t2, pi1.var_type, pi1.body, pi2.var_type, pi2.body
        )
        body_ctx = self._extend_ctx(ctx, z, pi1.var_type)
        z_var = Var(z)
        return self._is_equivalent(App(t1, z_var), App(t2, z_var), body_ctx)

    @staticmethod
    def _extend_ctx(ctx: Context, name: str, var_type: Term) -> Context:
        return ctx + [(name, var_type)]

    def _fresh_name_for(self, base: str, ctx: Context, *terms: Term) -> str:
        forbidden = {name for name, _ in ctx} | set(self.globals)
        for term in terms:
            forbidden |= get_free_vars(term)
        return fresh_name(base, forbidden)

    def _infer(self, term: Term, ctx: Context) -> Term:
        match term:
            case Var(name):
                # 1. Search local context (most recent first)
                for var_name, var_type in reversed(ctx):
                    if var_name == name:
                        return var_type
                # 2. search global definitions
                if name in self.globals:
                    return self.globals[name][0]

                raise TypeError(f"Unknown variable {name}")

            case Sort(level):
                return Sort(level + 1)

            case App(m, n):
                # Infer the type of the function
                m_type = self._whnf(self._infer(m, ctx))
                match m_type:
                    case Pi(var, var_type, body):
                        # Check that the argument matches the expected input type
                        self._check(n, var_type, ctx)
                        # If the Pi is dependant, substitute the argument into the body
                        if var is not None:
                            return substitute(body, var, n)
                        return body
                    case _:
                        raise TypeError(
                            f"Expected a function type for {m}, got {m_type}"
                        )

            case Pi(var, var_type, body):
                t1 = self._whnf(self._infer(var_type, ctx))
                if not isinstance(t1, Sort):
                    raise TypeError(f"Domain of Pi must be a Sort, got {t1}")

                new_ctx = ctx + ([(var, var_type)] if var else [])
                t2 = self._whnf(self._infer(body, new_ctx))
                if not isinstance(t2, Sort):
                    raise TypeError(f"Body of Pi must be a Sort, got {t2}")

                if t2.level == 0:
                    return Sort(0)  # Prop is impredicative!
                return Sort(max(t1.level, t2.level))

            case Ann(term, type):
                type_of_type = self._whnf(self._infer(type, ctx))
                if not isinstance(type_of_type, Sort):
                    raise TypeError(
                        f"Annotation type must have a Sort kind, got {type_of_type}"
                    )
                self._check(term, type, ctx)
                return type

            case Let(var, var_type, value, body):
                type_of_type = self._whnf(self._infer(var_type, ctx))
                if not isinstance(type_of_type, Sort):
                    raise TypeError(
                        f"Let binder type must have a Sort kind, got {type_of_type}"
                    )
                self._check(value, var_type, ctx)
                body_type = self._infer(body, self._extend_ctx(ctx, var, var_type))
                return substitute(body_type, var, value)

            case Lam():
                raise TypeError(
                    "Cannot infer type of lambda. Use an annotation or check it against a Pi."
                )

    def _check(self, term: Term, expected_type: Term, ctx: Context) -> None:
        match (term, self._whnf(expected_type)):
            case (Lam(v1, vt1, body), Pi(v2, vt2, pi_body)):
                if not self._is_equivalent(vt1, vt2, ctx):
                    raise TypeError(f"Lambda param type {vt1} doesn't match Pi {vt2}")

                # The name in the Pi might be different from the name in the Lambda.
                # Substitute the lambda's variable into the Pi's body to unify names.
                target_body = pi_body
                if v2 is not None:
                    target_body = substitute(pi_body, v2, Var(v1))

                self._check(body, target_body, ctx + [(v1, vt1)])
                return
            case _:
                pass

        inferred_type = self._infer(term, ctx)
        if not self._is_equivalent(inferred_type, expected_type, ctx):
            raise TypeError(
                f"Type mismatch, Term: {term}, Expected: {expected_type}, Inferred: {inferred_type}"
            )

    def _is_equivalent(self, t1: Term, t2: Term, ctx: Context) -> bool:
        """
        Checks if two terms are 'definitionally equal'
        Handles alpha-equivalence (renaming) automatically using fresh vars
        """
        t1 = self._whnf(t1)
        t2 = self._whnf(t2)

        if t1 == t2:
            return True

        t1_proof_type = self._proof_term_type(t1, ctx)
        if t1_proof_type is not None:
            t2_proof_type = self._proof_term_type(t2, ctx)
            if t2_proof_type is not None and self._is_equivalent(
                t1_proof_type, t2_proof_type, ctx
            ):
                return True

        if isinstance(t1, Lam) != isinstance(t2, Lam) and self._is_eta_equivalent(
            t1, t2, ctx
        ):
            return True

        match (t1, t2):
            case (Var(n1), Var(n2)):
                return n1 == n2
            case (Sort(l1), Sort(l2)):
                return l1 == l2
            case (App(m1, n1), App(m2, n2)):
                return self._is_equivalent(m1, m2, ctx) and self._is_equivalent(
                    n1, n2, ctx
                )
            case (Lam(v1, vt1, b1), Lam(v2, vt2, b2)):
                if not self._is_equivalent(vt1, vt2, ctx):
                    return False  # mismatching domain types
                z = self._fresh_name_for("z", ctx, vt1, vt2, b1, b2)
                body_ctx = self._extend_ctx(ctx, z, vt1)
                z_var = Var(z)
                return self._is_equivalent(
                    substitute(b1, v1, z_var),
                    substitute(b2, v2, z_var),
                    body_ctx,
                )
            case (Pi(v1, vt1, b1), Pi(v2, vt2, b2)):
                if not self._is_equivalent(vt1, vt2, ctx):
                    return False

                # difference between -> and dependent Pis
                match (v1, v2):
                    case (None, None):
                        return self._is_equivalent(b1, b2, ctx)
                    case (str(), str()):
                        z = self._fresh_name_for("z", ctx, vt1, vt2, b1, b2)
                        body_ctx = self._extend_ctx(ctx, z, vt1)
                        z_var = Var(z)
                        return self._is_equivalent(
                            substitute(b1, v1, z_var),
                            substitute(b2, v2, z_var),
                            body_ctx,
                        )
                    case (None, str()):
                        if v2 in get_free_vars(b2):
                            return False
                        return self._is_equivalent(b1, b2, ctx)
                    case (str(), None):
                        if v1 in get_free_vars(b1):
                            return False
                        return self._is_equivalent(b1, b2, ctx)
            case _:
                return False
