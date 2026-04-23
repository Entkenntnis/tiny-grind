# pyright: reportUnknownMemberType=false
# pyright: reportExplicitAny=false
# pyright: reportAny=false

from functools import reduce
from typing import Any, Final, cast

from lark import Lark, Token, Transformer
from lark.exceptions import LarkError

from core.syntax import Ann, App, Axiom, Definition, Lam, Let, Pi, Sort, Term, Var

# Pre-compile the grammar for performance
_GRAMMAR = r"""
start: (definition | axiom)*

definition: "def" NAME ":" term ":=" term             -> definition
axiom: "axiom" NAME ":" term                          -> axiom

?term: let_term

?let_term: "let" NAME ":" term ":=" term ";" term     -> let_term
         | lambda_term

?lambda_term: ("fun" | "λ") typed_binder+ "=>" term   -> lambda_term
            | forall_term

?forall_term: ("forall" | "∀") typed_binder+ "," term  -> forall_term
            | arrow_term

?arrow_term: typed_binder "->" arrow_term          -> dependent_arrow
           | app_term "->" arrow_term              -> simple_arrow
           | app_term

?app_term: atom+                                   -> app_chain

?atom: NAME                                        -> var
     | "Prop"                                      -> prop_sort
     | "Type"                                      -> type_sort
     | "Sort" INT                                  -> sort_n
     | "(" term ":" term ")"                       -> ann_term
     | "(" term ")"

typed_binder: "(" NAME ":" term ")"

NAME: /[a-zA-Z_α-ωΑ-Ω@][a-zA-Z0-9_'.α-ωΑ-Ω]*/

%import common.INT
%import common.WS
%ignore WS
%ignore /--[^\n]*/
"""


class _ToAst(Transformer[Token, Any]):
    """
    Transforms the Lark CST into the Syntax AST.
    The 'Any' type argument covers the heterogeneous nature of the nodes
    during the bottom-up transformation process.
    """

    def NAME(self, token: Token) -> str:
        return str(token)

    def INT(self, token: Token) -> int:
        return int(str(token))

    def var(self, children: list[str]) -> Var:
        return Var(name=children[0])

    def prop_sort(self, _: list[Any]) -> Sort:
        return Sort(level=0)

    def type_sort(self, _: list[Any]) -> Sort:
        return Sort(level=1)

    def sort_n(self, children: list[int]) -> Sort:
        return Sort(level=children[0])

    def typed_binder(self, children: list[Any]) -> tuple[str, Term]:
        # Matches: "(" NAME ":" term ")"
        return (cast(str, children[0]), cast(Term, children[1]))

    def app_chain(self, children: list[Term]) -> Term:
        # Left-fold: [f, x, y] -> App(App(f, x), y)
        return reduce(lambda m, n: App(m=m, n=n), children)

    def lambda_term(self, children: list[Any]) -> Term:
        # children: [ (name, type), (name, type), ..., body ]
        body: Term = cast(Term, children[-1])
        binders: list[tuple[str, Term]] = cast(list[tuple[str, Term]], children[:-1])

        result: Term = body
        for name, var_type in reversed(binders):
            result = Lam(var=name, var_type=var_type, body=result)
        return result

    def forall_term(self, children: list[Any]) -> Term:
        # children: [ (name, type), (name, type), ..., body ]
        body: Term = cast(Term, children[-1])
        binders: list[tuple[str, Term]] = cast(list[tuple[str, Term]], children[:-1])

        result: Term = body
        for name, var_type in reversed(binders):
            result = Pi(var=name, var_type=var_type, body=result)
        return result

    def dependent_arrow(self, children: list[Any]) -> Term:
        # Matches: typed_binder "->" arrow_term
        binder: tuple[str, Term] = children[0]
        body: Term = children[1]
        return Pi(var=binder[0], var_type=binder[1], body=body)

    def simple_arrow(self, children: list[Term]) -> Term:
        # Matches: pre_arrow "->" arrow_term
        var_type: Term = children[0]
        body: Term = children[1]
        return Pi(var=None, var_type=var_type, body=body)

    def ann_term(self, children: list[Term]) -> Term:
        return Ann(term=children[0], type=children[1])

    def let_term(self, children: list[Any]) -> Term:
        return Let(
            var=cast(str, children[0]),
            var_type=cast(Term, children[1]),
            value=cast(Term, children[2]),
            body=cast(Term, children[3]),
        )

    def definition(self, children: list[Any]) -> Definition:
        return Definition(
            name=cast(str, children[0]),
            type=cast(Term, children[1]),
            value=cast(Term, children[2]),
        )

    def axiom(self, children: list[Any]) -> Axiom:
        return Axiom(name=cast(str, children[0]), type=cast(Term, children[1]))

    def start(self, children: list[Definition]) -> list[Definition]:
        return children


# Global instances for reuse
_PARSER: Final[Lark] = Lark(_GRAMMAR, start="start", parser="lalr")
_TRANSFORMER: Final[_ToAst] = _ToAst()


def parse_declarations(source: str) -> list[Definition | Axiom]:
    """
    Parses a source string into a list of Syntax Definition objects.

    Args:
        source: The raw string containing Lean-like definitions.

    Returns:
        A list of Definition AST nodes.

    Raises:
        ValueError: If the source is syntactically incorrect.
    """
    try:
        tree = _PARSER.parse(source)
        result = _TRANSFORMER.transform(tree)
        return result
    except LarkError as e:
        raise ValueError(f"Parse error: {e}") from e
