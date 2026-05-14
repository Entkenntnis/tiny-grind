import sys
from pathlib import Path


# make sure that python can find our packages
ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "src"))

# =====================================================

from dataclasses import dataclass
from scaffolding.syntax import App, Definition, ElabTactic, Pi, Sort, Term, Var
from scaffolding.printer import print_definition
from lark import Lark, ParseTree, Token, Tree
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


def extractName(tree: ParseTree, position: int) -> str:
    name = "<?>"
    if len(tree.children) > position:
        child = tree.children[position]
        if isinstance(child, Token):
            name = child.value  # pyright: ignore
    return name


class TptpTransformer:
    def __init__(self, parse_tree: Tree[Token]):
        self.tree: Tree[Token] = parse_tree
        self.func_map: dict[tuple[str, int], str] = {}  # (name, arity) -> full name
        self.pred_map: dict[tuple[str, int], str] = {}
        self.var_order: list[str] = []  # within clause

    def transform(self) -> TptpCnfProblem:
        problem = TptpCnfProblem([], [], [])

        self._collect_symbols(self.tree)

        problem.functions = [FunctionDecl(name, ar) for (name, ar) in self.func_map]
        problem.predicates = [PredicateDecl(name, ar) for (name, ar) in self.pred_map]

        for f in problem.functions:
            self.func_map[(f.original_name, f.arity)] = f.full_name

        for p in problem.predicates:
            self.pred_map[(p.original_name, p.arity)] = p.full_name

        for child in self.tree.children:
            if isinstance(child, Tree) and child.data == "cnf_entry":
                clause = self._build_clause(child)
                problem.clauses.append(clause)

        return problem

    def _collect_symbols(self, tree: Tree[Token]):
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

    def _build_clause(self, cnf_entry: ParseTree) -> Clause:
        role = extractName(cnf_entry, 1)
        name = extractName(cnf_entry, 0)
        formula = cnf_entry.children[2]

        lit_trees = self._extract_literals(formula.children[0])  # pyright: ignore
        self.var_order.clear()
        lit_terms = [self._transform_literal(lt) for lt in lit_trees]

        return Clause(role, name, list(self.var_order), lit_terms)

    def _extract_literals(self, disj: ParseTree) -> list[ParseTree]:
        if disj.data == "literal":
            return [disj]
        return [c for c in disj.children if isinstance(c, Tree) and c.data == "literal"]

    def _transform_literal(self, lit: ParseTree) -> Term:
        negated = lit.children[0] == "~"  # pyright: ignore
        atom_tree = lit.children[-1]
        atom = self._transform_atom(atom_tree)  # pyright: ignore
        return App(Var("Not"), atom) if negated else atom

    def _transform_atom(self, atom: ParseTree) -> Term:
        data = atom.data
        if data == "pred_app":
            name = extractName(atom, 0)
            args = atom.children[1:]
            full = self.pred_map[name, len(args)]
            head = Var(full)
            for a in args:
                head = App(head, self._transform_term(a))  # pyright: ignore
            return head
        elif data == "zero_arity_pred":
            name = extractName(atom, 0)
            return Var(self.pred_map[(name, 0)])
        elif data == "eq_atom":
            left = self._transform_term(atom.children[0])  # pyright: ignore
            right = self._transform_term(atom.children[1])  # pyright: ignore
            return App(App(App(Var("@Eq"), Var("_U")), left), right)
        elif data == "neq_atom":
            left = self._transform_term(atom.children[0])  # pyright: ignore
            right = self._transform_term(atom.children[1])  # pyright: ignore
            eq = App(App(App(Var("@Eq"), Var("_U")), left), right)
            return App(Var("Not"), eq)
        else:
            raise ValueError(f"Unknown atom type: {data}")

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


def mk_or(lits: list[Term]) -> Term:
    if not lits:
        return Var("False")
    if len(lits) == 1:
        return lits[0]
    return App(App(Var("Or"), lits[0]), mk_or(lits[1:]))


def clause_to_hyp_type(clause: Clause) -> Term:
    body = mk_or(clause.literals)
    for v in reversed(clause.free_vars):
        body = Pi(v, Var("_U"), body)
    return body


def mk_pred_type(arity: int) -> Term:
    body = Sort(0)
    for _ in range(arity):
        body = Pi(None, Var("_U"), body)
    return body


def mk_func_type(arity: int) -> Term:
    body = Var("_U")
    for _ in range(arity):
        body = Pi(None, Var("_U"), body)
    return body


def build_theorem_type(problem: TptpCnfProblem) -> Term:
    ty = Var("False")

    for clause in reversed(problem.clauses):
        hyp_name = f"h_{clause.name}"
        hyp_type = clause_to_hyp_type(clause)
        ty = Pi(hyp_name, hyp_type, ty)

    for pred in reversed(problem.predicates):
        ty = Pi(pred.full_name, mk_pred_type(pred.arity), ty)
    for func in reversed(problem.functions):
        ty = Pi(func.full_name, mk_func_type(func.arity), ty)

    ty = Pi("_U", Sort(1), ty)
    return ty


def problem_to_lean_definition(
    problem: TptpCnfProblem, theorem_name: str
) -> Definition:
    return Definition(theorem_name, build_theorem_type(problem), ElabTactic("grind"))


# main program

okCounter = 0


directory = Path("_tptp_raw/TPTP-v9.2.1/Problems")
for path in directory.rglob("*.p"):
    # print(path)
    # try:
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()
    # print(content)
    if len(content) > 10000:  # this should be a solid subset
        # print("skip due to length")
        continue
    if not re.search(r"% SPC\s+: CNF_UNS_", content):
        # print(f"skip due to not being CNF UNSAT {path}")
        continue

    try:
        tree = parser.parse(content)  # pyright: ignore
    except:
        continue
    # print(tree)

    transformer = TptpTransformer(tree)
    problem = transformer.transform()

    okCounter += 1
    # print(content)
    # print(tree)
    # print(problem)
    # print("intermediate structure:")
    # for clause in problem.clauses:
    #     print(f"  clause: {clause.name} ({clause.free_vars})")
    #     for lit in clause.literals:
    #         print(f"    {print_term(lit)}")

    theorem_name = path.stem
    theorem_name = (
        theorem_name.replace("-", "_minus_")
        .replace("^", "_caret_")
        .replace("+", "_plus_")
        .replace(".", "_dot_")
    )
    definition = problem_to_lean_definition(problem, theorem_name)
    print(print_definition(definition))

    print("\n\n")

    # if okCounter > 100:
    #     sys.exit()

print(f"{okCounter} parsed correctly")
