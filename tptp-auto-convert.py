import sys
from pathlib import Path


# make sure that python can find our packages
ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "src"))

# =====================================================

from dataclasses import dataclass
from scaffolding.syntax import Term
from lark import Lark, Token, Tree
import re

grammar = r"""

start: cnf_entry*

cnf_entry: "cnf" "(" NAME "," NAME "," formula ")" "."

formula: disjunction
disjunction: literal
    | "(" literal ("|" literal)* ")"
literal: "~"? atom                   -> literal
atom: NAME "(" term ("," term)* ")"          -> pred_app
     | NAME                       -> zero_arity_pred
     | term "=" term           -> eq_atom
     | term "!=" term          -> neq_atom

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

# ignore axiom imports, ignore $true/$false (rarely used), ignore quoted names (also rarely used)
# 1995 problems are passing, I'm happy with this

parser = Lark(grammar, start="start", parser="lalr")


# ======= Intermediate represenation
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
class Clause:
    role: str
    name: str
    free_vars: list[str]
    literals: list[Term]


@dataclass
class TptpCnfProblem:
    functions: list[FunctionDecl]
    predicates: list[PredicateDecl]
    clauses: list[Clause]


# Transformer


class TptpTransformer:
    def __init__(self, parse_tree: Tree[Token]):
        self.tree: Tree[Token] = parse_tree
        self.func_map: dict[tuple[str, int], str] = {}  # (name, arity) -> full name
        self.pred_map: dict[tuple[str, int], str] = {}
        self.var_oder: list[str] = []  # within clause

    def transform(self) -> TptpCnfProblem:
        problem = TptpCnfProblem([], [], [])

        self._collect_symbols(self.tree)

        problem.functions = [FunctionDecl(name, ar) for (name, ar) in self.func_map]
        problem.predicates = [PredicateDecl(name, ar) for (name, ar) in self.pred_map]

        for f in problem.functions:
            self.func_map[(f.original_name, f.arity)] = f.full_name

        for p in problem.predicates:
            self.pred_map[(p.original_name, p.arity)] = p.full_name

        # TODO: second pass

        return problem

    def _collect_symbols(self, tree: Tree[Token]):
        if isinstance(tree, Token):
            return
        name = "<?>"
        if len(tree.children) > 0:
            child = tree.children[0]
            if isinstance(tree.children[0], Token):
                name = child.value  # pyright: ignore
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


# main program

okCounter = 0


directory = Path("_tptp_raw/TPTP-v9.2.1/Problems")
for path in directory.rglob("*.p"):
    # print(path)
    try:
        with open(path, "r", encoding="utf-8") as f:
            content = f.read()
        # print(content)
        if len(content) > 10000:  # this should be a solid subset
            # print("skip due to length")
            continue
        if not re.search(r"% SPC\s+: CNF_UNS_", content):
            # print(f"skip due to not being CNF UNSAT {path}")
            continue

        tree = parser.parse(content)  # pyright: ignore
        transformer = TptpTransformer(tree)
        problem = transformer.transform()

        okCounter += 1
        print(content)
        print(tree)
        print(problem)
        if okCounter > 5:
            sys.exit()
    except Exception as e:
        # print(f"-> failed to parse: {e}")
        pass

print(f"{okCounter} parsed correctly")
