import sys
from pathlib import Path


# make sure that python can find our packages
ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "src"))

# =====================================================

from dataclasses import dataclass
from typing import cast
from scaffolding.syntax import (
    App,
    Axiom,
    Definition,
    ElabTactic,
    Lam,
    Pi,
    Sort,
    Term,
    Var,
)
from scaffolding.printer import print_definition
from lark import Lark, ParseTree, Token, Tree
import re

grammar = r"""

start: fof_entry*

fof_entry: "fof" "(" NAME "," NAME "," formula  ")" "."

?formula: iff_formula

?iff_formula: impl_formula ("<=>" impl_formula)*
?impl_formula: or_formula ("=>" or_formula)*
?or_formula: and_formula ("|" and_formula)*
?and_formula: unary_formula ("&" unary_formula)*
?unary_formula: "~" unary_formula -> negation
    | quant_formula
    | atomic_formula

quant_formula: "!" "[" VARIABLE ("," VARIABLE)* "]" ":" formula -> forall
    | "?" "[" VARIABLE ("," VARIABLE)* "]" ":" formula -> exists

?atomic_formula: "(" formula ")"
    | atom

?atom: NAME "(" term ("," term)* ")"          -> pred_app
     | NAME                       -> zero_arity_pred
     | term "=" term          -> eq_atom
     | term "!=" term          -> neq_atom
     | "$true"                                 -> true_const
     | "$false"                                -> false_const

term: VARIABLE -> var
    | NAME "(" term ("," term)* ")" -> func
    | NAME -> constant

VARIABLE: /[A-Z][A-Za-z0-9_]*/
NAME: /[a-z][A-Za-z0-9_]*/

COMMENT: /%[^\n]*/

%import common.WS
%ignore WS
%ignore COMMENT

"""

# ignore axiom imports (this excluded most), ignore other exotic syntax, focus on the main stuff
# 1970 problems are passing, I'm happy with this

parser = Lark(grammar, start="start", parser="lalr")


# # ======= Intermediate represenation
@dataclass(frozen=True)
class FunctionDecl:
    original_name: str
    arity: int

    @property
    def full_name(self) -> str:
        return f"f_{self.original_name}_{self.arity}"


@dataclass(frozen=True)
class PredicateDecl:
    original_name: str
    arity: int

    @property
    def full_name(self) -> str:
        return f"p_{self.original_name}_{self.arity}"


@dataclass
class TptpFofProblem:
    functions: list[FunctionDecl]
    predicates: list[PredicateDecl]
    axioms: list[Axiom]
    conjecture: Term


# Transformer


def extractName(tree: ParseTree, position: int) -> str:
    name = "<?>"
    if len(tree.children) > position:
        child = tree.children[position]
        if isinstance(child, Token):
            name = child.value  # pyright: ignore
    return name


def extractChild(tree: ParseTree, position: int) -> ParseTree:
    return tree.children[position]  # pyright: ignore


class TptpFofTransformer:
    def __init__(self, parse_tree: ParseTree):
        self.tree: ParseTree = parse_tree
        self.func_map: dict[tuple[str, int], str] = {}  # (name, arity) -> full name
        self.pred_map: dict[tuple[str, int], str] = {}
        self.var_order: list[str] = []  # within clause

    def transform(self) -> TptpFofProblem:
        self._collect_symbols(self.tree)

        functions = [FunctionDecl(name, ar) for (name, ar) in self.func_map]
        predicates = [PredicateDecl(name, ar) for (name, ar) in self.pred_map]

        for f in functions:
            self.func_map[(f.original_name, f.arity)] = f.full_name

        for p in predicates:
            self.pred_map[(p.original_name, p.arity)] = p.full_name

        axioms: list[Axiom] = []
        conjecture: Term | None = None

        for child in self.tree.children:
            if isinstance(child, Tree) and child.data == "fof_entry":
                name = extractName(child, 0)
                role = extractName(child, 1)
                formula_tree = extractChild(child, 2)
                formula_term = self._translate_formula(formula_tree)

                if role == "conjecture":
                    if not conjecture == None:
                        raise RuntimeError("Multiple conjectures!")
                    conjecture = formula_term
                else:
                    axioms.append(Axiom(name, formula_term))
        if conjecture == None:
            raise RuntimeError("No conjecture!")

        return TptpFofProblem(functions, predicates, axioms, conjecture)

    def _collect_symbols(self, tree: ParseTree):
        if isinstance(tree, Token):
            return
        name = extractName(tree, 0)
        if tree.data == "func":
            arity = len(tree.children) - 1
            self.func_map[(name, arity)] = ""  # placeholder
        elif tree.data == "constant":
            self.func_map[(name, 0)] = ""
        elif tree.data == "pred_app":
            arity = len(tree.children) - 1
            self.pred_map[(name, arity)] = ""  # placeholder
        elif tree.data == "zero_arity_pred":
            self.pred_map[(name, 0)] = ""

        for child in tree.children:
            if isinstance(child, Tree):
                self._collect_symbols(child)

    def _translate_formula(self, tree: ParseTree) -> Term:
        data = tree.data
        if data == "iff_formula":
            left = self._translate_formula(extractChild(tree, 0))
            right = self._translate_formula(extractChild(tree, 1))
            return App(App(Var("Iff"), left), right)
        elif data == "impl_formula":
            left = self._translate_formula(extractChild(tree, 0))
            right = self._translate_formula(extractChild(tree, 1))
            return Pi(None, left, right)
        elif data == "or_formula":
            left = self._translate_formula(extractChild(tree, 0))
            right = self._translate_formula(extractChild(tree, 1))
            return App(App(Var("Or"), left), right)
        elif data == "and_formula":
            left = self._translate_formula(extractChild(tree, 0))
            right = self._translate_formula(extractChild(tree, 1))
            return App(App(Var("And"), left), right)
        elif data == "negation":
            sub = self._translate_formula(extractChild(tree, 0))
            return App(Var("Not"), sub)
        elif data == "forall":
            vars_ = [extractName(tree, i) for i in range(len(tree.children) - 1)]
            body = self._translate_formula(extractChild(tree, len(tree.children) - 1))
            for v in reversed(vars_):
                body = Pi(v, Var("_U"), body)
            return body
        elif data == "exists":
            vars_ = [extractName(tree, i) for i in range(len(tree.children) - 1)]
            body = self._translate_formula(extractChild(tree, len(tree.children) - 1))
            for v in reversed(vars_):
                body = App(App(Var("@Exists"), Var("_U")), Lam(v, Var("_U"), body))
            return body
        elif data == "pred_app":
            name = extractName(tree, 0)
            args = tree.children[1:]
            full = self.pred_map[name, len(args)]
            head = Var(full)
            for a in args:
                head = App(head, self._transform_term(a))  # pyright: ignore
            return head
        elif data == "zero_arity_pred":
            name = extractName(tree, 0)
            return Var(self.pred_map[(name, 0)])
        elif data == "eq_atom":
            left = self._transform_term(extractChild(tree, 0))
            right = self._transform_term(extractChild(tree, 1))
            return App(App(App(Var("@Eq"), Var("_U")), left), right)
        elif data == "neq_atom":
            left = self._transform_term(extractChild(tree, 0))
            right = self._transform_term(extractChild(tree, 1))
            eq = App(App(App(Var("@Eq"), Var("_U")), left), right)
            return App(Var("Not"), eq)
        elif data == "true_const":
            return Var("True")
        elif data == "false_const":
            return Var("False")
        else:
            raise ValueError(f"Unknown atom type: {data} {tree}")

    def _transform_term(self, node: ParseTree) -> Term:
        data = node.data
        if data == "var":
            v = extractName(node, 0)
            if v not in self.var_order:
                self.var_order.append(v)
            return Var(v)
        elif data == "func":
            name = extractName(node, 0)
            args = node.children[1:]
            full = self.func_map[name, len(args)]
            head = Var(full)
            for a in args:
                head = App(head, self._transform_term(a))  # pyright: ignore
            return head
        elif data == "constant":
            name = extractName(node, 0)
            full = self.func_map[(name, 0)]
            return Var(full)
        else:
            raise ValueError(f"Unknown term node: {data}")


# def mk_or(lits: list[Term]) -> Term:
#     if not lits:
#         return Var("False")
#     if len(lits) == 1:
#         return lits[0]
#     return App(App(Var("Or"), lits[0]), mk_or(lits[1:]))


# def clause_to_hyp_type(clause: Clause) -> Term:
#     body = mk_or(clause.literals)
#     for v in reversed(clause.free_vars):
#         body = Pi(v, Var("_U"), body)
#     return body


# def mk_pred_type(arity: int) -> Term:
#     body = Sort(0)
#     for _ in range(arity):
#         body = Pi(None, Var("_U"), body)
#     return body


# def mk_func_type(arity: int) -> Term:
#     body = Var("_U")
#     for _ in range(arity):
#         body = Pi(None, Var("_U"), body)
#     return body


# def build_theorem_type(problem: TptpCnfProblem) -> Term:
#     ty = Var("False")

#     for clause in reversed(problem.clauses):
#         hyp_name = f"h_{clause.name}"
#         hyp_type = clause_to_hyp_type(clause)
#         ty = Pi(hyp_name, hyp_type, ty)

#     for pred in reversed(problem.predicates):
#         ty = Pi(pred.full_name, mk_pred_type(pred.arity), ty)
#     for func in reversed(problem.functions):
#         ty = Pi(func.full_name, mk_func_type(func.arity), ty)

#     ty = Pi("_U", Sort(1), ty)
#     return ty


# def problem_to_lean_definition(
#     problem: TptpCnfProblem, theorem_name: str
# ) -> Definition:
#     return Definition(theorem_name, build_theorem_type(problem), ElabTactic("grind"))


# main program

okCounter = 0

directory = Path("_tptp_raw/TPTP-v9.2.1/Problems")
for path in directory.rglob("*.p"):
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()
    if len(content) > 15000:  # this should be a solid subset
        continue
    if not re.search(r"% SPC\s+: FOF_THM_", content):
        continue
    if "include('Axioms/" in content:
        continue

    try:
        tree = parser.parse(content)  # pyright: ignore
    except:
        continue

    okCounter += 1

    print(content)
    print(tree)

    transformer = TptpFofTransformer(tree)
    problem = transformer.transform()

    print(problem)

    # print(content)
    # print(tree)
    # print(problem)
    # print("intermediate structure:")
    # for clause in problem.clauses:
    #     print(f"  clause: {clause.name} ({clause.free_vars})")
    #     for lit in clause.literals:
    #         print(f"    {print_term(lit)}")

    # theorem_name = path.stem
    # theorem_name = (
    #     theorem_name.replace("-", "_minus_")
    #     .replace("^", "_caret_")
    #     .replace("+", "_plus_")
    #     .replace(".", "_dot_")
    # )
    # definition = problem_to_lean_definition(problem, theorem_name)
    # print(print_definition(definition))

    # print("\n\n")

    # if okCounter > 100:
    #     sys.exit()

print(f"{okCounter} parsed correctly")
