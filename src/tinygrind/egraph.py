# pyright: reportUnusedCallResult=false
from collections import deque
from dataclasses import dataclass
from scaffolding import syntax

# This is the public API
# use this to create terms and add to the egraph


@dataclass(frozen=True)
class TrueTerm:
    pass


@dataclass(frozen=True)
class FalseTerm:
    pass


@dataclass(frozen=True)
class Equals:
    left: Term
    right: Term


@dataclass(frozen=True)
class Application:
    head: Term
    arg: Term


@dataclass(frozen=True)
class Symbol:
    name: str


type Term = TrueTerm | FalseTerm | Equals | Application | Symbol


type Node = int


def termToLean(term: Term) -> syntax.Term:
    match term:
        case Symbol():
            return syntax.Var(term.name)
        case Application():
            return syntax.App(termToLean(term.head), termToLean(term.arg))
        case _:
            raise RuntimeError(f"Conversion failed for {term}")


class EGraph:

    def __init__(self):
        # Node directly indexes into these data structures
        self._parents: list[Node] = []
        self._node_to_term: list[Term] = []
        self._sizes: list[int] = []

        # store proofs between nodes
        self._nodes_to_proof: dict[Node, dict[Node, syntax.Term]] = {}

        # "structual sharing" happens here
        self._term_to_node: dict[Term, Node] = {}
        self._True: Node = self._add_term(TrueTerm())
        self._False: Node = self._add_term(FalseTerm())

    # not really "elegant", but this is our current approach for case splitting
    def _clone(self) -> "EGraph":
        # create new EGraph instance without calling init
        clone = EGraph.__new__(EGraph)
        clone._parents = self._parents.copy()
        clone._node_to_term = self._node_to_term.copy()
        clone._term_to_node = self._term_to_node.copy()
        clone._sizes = self._sizes.copy()

        clone._nodes_to_proof = {}
        for k, v in self._nodes_to_proof.items():
            clone._nodes_to_proof[k] = v.copy()
        clone._True = self._True
        clone._False = self._False
        return clone

    def addSymbol(self, symbol: Symbol):
        self._add_term(symbol)
        self._rebuild()

    def addProp(self, prop: Term, proof: syntax.Term):
        """
        Adding a Prop needs a proof
        """
        node = self._add_term(prop)
        self._union(node, self._True, syntax.App(syntax.Var("eq_true"), proof))
        self._rebuild()

    def addGoal(
        self, goal: Term, proof: syntax.Term
    ):  # everything else does need an proof
        node = self._add_term(goal)

        self._union(
            node,
            self._False,
            syntax.App(syntax.Var("eq_false_intro"), proof),
        )
        self._rebuild(case_split_levels=5)

    def findProof(self, a: Term, b: Term) -> syntax.Term:
        return self._find_proof(self._node(a), self._node(b))

    def isBottom(self) -> bool:
        a = self._True
        b = self._False
        return self._equals(a, b)

    def _equals(self, a: Node, b: Node) -> bool:
        return self._find(a) == self._find(b)

    def _add_term(self, term: Term) -> Node:
        existing = self._term_to_node.get(term)
        if existing is not None:
            return existing

        # recursively add children
        if isinstance(term, Application):
            _ = self._add_term(term.head)
            _ = self._add_term(term.arg)
        elif isinstance(term, Equals):
            _ = self._add_term(term.left)
            _ = self._add_term(term.right)

        node = len(self._parents)  # it really is just a continuous int id
        self._parents.append(node)
        self._node_to_term.append(term)
        self._sizes.append(1)

        self._term_to_node[term] = node
        return node

    def _node(self, term: Term) -> Node:
        return self._term_to_node[term]

    def _find(self, node: Node) -> Node:
        # returns the representant
        root = node
        while self._parents[root] != root:
            root = self._parents[root]

        # path compresion
        while self._parents[node] != root:
            nxt = self._parents[node]
            self._parents[node] = root
            node = nxt

        return root

    def _union(self, a: Node, b: Node, proof: syntax.Term) -> bool:
        ra = self._find(a)
        rb = self._find(b)
        if ra == rb:
            return False
        if self._sizes[ra] < self._sizes[rb]:
            ra, rb = rb, ra  # ra is always the larger tree
        self._parents[rb] = ra
        self._sizes[ra] += self._sizes[rb]

        self._nodes_to_proof.setdefault(a, {})[b] = proof
        self._nodes_to_proof.setdefault(b, {})[a] = syntax.App(
            syntax.Var("Eq.symm"), proof
        )

        return True

    def _find_proof(self, a: Node, b: Node) -> syntax.Term:
        if a == b:
            return syntax.App(
                syntax.App(syntax.Var("@rfl"), syntax.Var("_")),
                termToLean(self._node_to_term[a]),
            )

        queue: deque[Node] = deque([a])
        visited: set[Node] = {a}
        parent: dict[Node, tuple[Node, syntax.Term]] = {}

        while queue:
            current = queue.popleft()
            if current == b:
                output = parent[current][1]  # this is the proof from parent to me
                node = parent[current][0]
                while node != a:
                    # extend the proof to include new node in chain
                    (prev, proof) = parent[node]
                    output = syntax.App(
                        syntax.App(syntax.Var("Eq.trans"), proof), output
                    )
                    node = prev
                return output

            for neighbor, proof in self._nodes_to_proof.get(current, {}).items():
                if neighbor not in visited:
                    visited.add(neighbor)
                    parent[neighbor] = (current, proof)
                    queue.append(neighbor)

        raise RuntimeError(f"No proof found between {a} and {b}")

    def _rebuild(self, case_split_levels: int = 0):
        while not self.isBottom() and (
            self._do_true_equality_elimination()
            or self._do_equality_reflection()
            or self._do_congrunce_closure()
            or self._do_propositional_constraint_propagation()
            or self._do_push_not()
            or self._do_modus_ponens()
        ):
            pass
        if case_split_levels > 0 and not self.isBottom():
            if self._try_case_split(case_split_levels):
                self._rebuild(case_split_levels=case_split_levels - 1)

    def _try_case_split(self, case_split_levels: int = 0) -> bool:
        for node in range(len(self._node_to_term)):
            if not self._equals(node, self._True):
                continue
            term = self._node_to_term[node]
            if not isinstance(term, Application):
                continue
            outer_app = term
            inner_app = outer_app.head
            if not isinstance(inner_app, Application):
                continue
            if inner_app.head != Symbol("Or"):
                continue

            A = inner_app.arg
            hypA = f"h_case_{node}_left"

            cloneA = self._clone()
            cloneA.addProp(A, syntax.Var(hypA))
            cloneA._rebuild(case_split_levels=case_split_levels - 1)
            if not cloneA.isBottom():
                continue  # no proof found

            B = outer_app.arg
            hypB = f"h_case_{node}_right"
            cloneB = self._clone()
            cloneB.addProp(B, syntax.Var(hypB))
            cloneB._rebuild(case_split_levels=case_split_levels - 1)
            if not cloneB.isBottom():
                continue

            # now there are contradictions found for A and B
            lam_A = syntax.Lam(
                hypA, syntax.Var("_"), cloneA._find_proof(self._True, self._False)
            )
            lam_B = syntax.Lam(
                hypB, syntax.Var("_"), cloneB._find_proof(self._True, self._False)
            )

            proof = syntax.App(
                syntax.App(
                    syntax.App(
                        syntax.Var("or_elim"), self._find_proof(node, self._True)
                    ),
                    lam_A,
                ),
                lam_B,
            )

            return self._union(self._True, self._False, proof)

        return False

    def _do_congrunce_closure(self) -> bool:
        seen: dict[tuple[Node, Node], Node] = {}
        for node in range(len(self._node_to_term)):
            term = self._node_to_term[node]
            if not isinstance(term, (Application)):
                continue

            repr_head = self._find(self._node(term.head))
            repr_arg = self._find(self._node(term.arg))
            key = (repr_head, repr_arg)

            previous = seen.get(key)
            if previous is None:
                seen[key] = node
            elif not self._equals(previous, node):
                # build proof
                prev_term = self._node_to_term[previous]
                node_term = self._node_to_term[node]

                if not isinstance(prev_term, (Application)) or not isinstance(
                    node_term, Application
                ):
                    raise RuntimeError("Application expected in congruence closure")

                head_proof = self.findProof(prev_term.head, node_term.head)
                arg_proof = self.findProof(prev_term.arg, node_term.arg)
                proof = syntax.App(
                    syntax.App(syntax.Var("congr"), head_proof), arg_proof
                )
                return self._union(previous, node, proof)
        return False

    def _do_equality_reflection(self) -> bool:
        for node in range(len(self._node_to_term)):
            term = self._node_to_term[node]
            if isinstance(term, Equals):
                left_node = self._node(term.left)
                right_node = self._node(term.right)
                if self._equals(left_node, right_node) and not self._equals(
                    node, self._True
                ):
                    return self._union(
                        node,
                        self._True,
                        proof=syntax.App(
                            syntax.Var("eq_true"),
                            self._find_proof(left_node, right_node),
                        ),
                    )
        return False

    def _binary_connective_args(
        self, term: Term, name: str
    ) -> tuple[Term, Term] | None:
        if not isinstance(term, Application):
            return None

        inner = term.head
        if not isinstance(inner, Application):
            return None

        if inner.head != Symbol(name):
            return None

        return (inner.arg, term.arg)

    def _unary_connective_args(self, term: Term, name: str) -> Term | None:
        if not isinstance(term, Application):
            return None

        if term.head != Symbol(name):
            return None

        return term.arg

    def _do_propositional_constraint_propagation(self) -> bool:
        for node in range(len(self._node_to_term)):
            term = self._node_to_term[node]

            and_args = self._binary_connective_args(term, "And")
            if and_args is not None:
                if self._propagate_and(node, and_args[0], and_args[1]):
                    return True

            or_args = self._binary_connective_args(term, "Or")
            if or_args is not None:
                if self._propagate_or(node, or_args[0], or_args[1]):
                    return True

            not_arg = self._unary_connective_args(term, "Not")
            if not_arg is not None:
                if self._propagate_not(node, not_arg):
                    return True
        return False

    def _is_eq_true(self, node: Node) -> bool:
        return self._equals(node, self._True)

    def _is_eq_false(self, node: Node) -> bool:
        return self._equals(node, self._False)

    def _propagate_and(self, node: int, left_term: Term, right_term: Term) -> bool:
        left = self._node(left_term)
        right = self._node(right_term)

        # a = False => (a ∧ b) = False
        if self._is_eq_false(left) and not self._is_eq_false(node):
            proof_left_false = self._find_proof(left, self._False)
            proof = syntax.App(
                syntax.Var("and_eq_false_of_left_false"), proof_left_false
            )
            return self._union(node, self._False, proof)

        # b = False => (a ∧ b) = False
        if self._is_eq_false(right) and not self._is_eq_false(node):
            proof_right_false = self._find_proof(right, self._False)
            proof = syntax.App(
                syntax.Var("and_eq_false_of_right_false"), proof_right_false
            )
            return self._union(node, self._False, proof)

        # a = True => (a ∧ b) = b
        if self._is_eq_true(left) and not self._equals(node, right):
            proof_left_true = self._find_proof(left, self._True)
            proof = syntax.App(syntax.Var("and_eq_right_of_left_true"), proof_left_true)
            return self._union(node, right, proof)

        # b = True => (a ∧ b) = a
        if self._is_eq_true(right) and not self._equals(node, left):
            proof_right_true = self._find_proof(right, self._True)
            proof = syntax.App(
                syntax.Var("and_eq_left_of_right_true"), proof_right_true
            )
            return self._union(node, left, proof)

        # (a ∧ b) = True => a = True
        if self._is_eq_true(node) and not self._is_eq_true(left):
            proof_and_true = self._find_proof(node, self._True)
            proof_left = syntax.App(syntax.Var("and_elim_left"), proof_and_true)
            return self._union(left, self._True, proof_left)

        # (a ∧ b) = True => b = True
        if self._is_eq_true(node) and not self._is_eq_true(right):
            proof_and_true = self._find_proof(node, self._True)
            proof_right = syntax.App(syntax.Var("and_elim_right"), proof_and_true)
            return self._union(right, self._True, proof_right)

        return False

    def _propagate_or(self, node: int, left_term: Term, right_term: Term) -> bool:
        left = self._node(left_term)
        right = self._node(right_term)

        # a = True        => (a ∨ b) = True
        if self._is_eq_true(left) and not self._is_eq_true(node):
            proof_left_true = self._find_proof(left, self._True)
            proof = syntax.App(syntax.Var("or_eq_true_of_left_true"), proof_left_true)
            return self._union(node, self._True, proof)

        # b = True        => (a ∨ b) = True
        if self._is_eq_true(right) and not self._is_eq_true(node):
            proof_right_true = self._find_proof(right, self._True)
            proof = syntax.App(syntax.Var("or_eq_true_of_right_true"), proof_right_true)
            return self._union(node, self._True, proof)

        # a = False       => (a ∨ b) = b
        if self._is_eq_false(left) and not self._equals(node, right):
            proof_left_false = self._find_proof(left, self._False)
            proof = syntax.App(syntax.Var("or_eq_of_left_false"), proof_left_false)
            return self._union(node, right, proof)

        # b = False       => (a ∨ b) = a
        if self._is_eq_false(right) and not self._equals(node, left):
            proof_right_false = self._find_proof(right, self._False)
            proof = syntax.App(syntax.Var("or_eq_of_right_false"), proof_right_false)
            return self._union(node, left, proof)

        # (a ∨ b) = False => a = False
        if self._is_eq_false(node) and not self._is_eq_false(left):
            proof_false = self._find_proof(node, self._False)
            proof_left_false = syntax.App(syntax.Var("or_elim_left_false"), proof_false)
            return self._union(left, self._False, proof_left_false)

        # (a ∨ b) = False => b = False
        if self._is_eq_false(node) and not self._is_eq_false(right):
            proof_false = self._find_proof(node, self._False)
            proof_right_false = syntax.App(
                syntax.Var("or_elim_right_false"), proof_false
            )
            return self._union(right, self._False, proof_right_false)

        return False

    def _propagate_not(self, node: int, inner_term: Term) -> bool:
        term = self._node(inner_term)

        # A = True      => ¬A = False
        if self._is_eq_true(term) and not self._is_eq_false(node):
            proof_true = self._find_proof(term, self._True)
            proof = syntax.App(syntax.Var("not_eq_false_of_arg_true"), proof_true)
            return self._union(node, self._False, proof)

        # A = False     => ¬A = True
        if self._is_eq_false(term) and not self._is_eq_true(node):
            proof_false = self._find_proof(term, self._False)
            proof = syntax.App(syntax.Var("not_eq_true_of_arg_false"), proof_false)
            return self._union(node, self._True, proof)

        # ¬A = True     => A = False
        if self._is_eq_true(node) and not self._is_eq_false(term):
            proof_true = self._find_proof(node, self._True)
            proof = syntax.App(syntax.Var("eq_false_of_not_eq_true"), proof_true)
            return self._union(term, self._False, proof)

        # ¬A = False    => A = True
        if self._is_eq_false(node) and not self._is_eq_true(term):
            proof_false = self._find_proof(node, self._False)
            proof = syntax.App(syntax.Var("eq_true_of_not_eq_false"), proof_false)
            return self._union(term, self._True, proof)

        return False

    def _do_push_not(self) -> bool:
        for node in range(len(self._node_to_term)):
            if self._is_eq_false(node) and not self._is_eq_true(
                node
            ):  # guarantee that we have not found Bottom yet
                term = self._node_to_term[node]

                and_args = self._binary_connective_args(term, "And")
                if and_args is not None:
                    if self._push_not_and(node, and_args[0], and_args[1]):
                        return True

                or_args = self._binary_connective_args(term, "Or")
                if or_args is not None:
                    if self._push_not_or(node, or_args[0], or_args[1]):
                        return True

                imp_args = self._binary_connective_args(term, "Imp")
                if imp_args is not None:
                    if self._push_not_imp(node, imp_args[0], imp_args[1]):
                        return True
        return False

    def _push_not_and(self, node: int, a_term: Term, b_term: Term) -> bool:

        not_a = Application(Symbol("Not"), a_term)
        not_b = Application(Symbol("Not"), b_term)

        result_term = Application(Application(Symbol("Or"), not_a), not_b)

        result_node = self._add_term(result_term)
        if not self._is_eq_true(result_node):
            false_proof = self._find_proof(node, self._False)
            proof = syntax.App(syntax.Var("push_not_and"), false_proof)
            return self._union(result_node, self._True, proof)

        return False

    def _push_not_or(self, node: int, a_term: Term, b_term: Term) -> bool:

        not_a = Application(Symbol("Not"), a_term)
        not_b = Application(Symbol("Not"), b_term)

        result_term = Application(Application(Symbol("And"), not_a), not_b)

        result_node = self._add_term(result_term)
        if not self._is_eq_true(result_node):
            false_proof = self._find_proof(node, self._False)
            proof = syntax.App(syntax.Var("push_not_or"), false_proof)
            return self._union(result_node, self._True, proof)

        return False

    def _push_not_imp(self, node: int, a_term: Term, b_term: Term) -> bool:

        not_b = Application(Symbol("Not"), b_term)

        result_term = Application(Application(Symbol("And"), a_term), not_b)

        result_node = self._add_term(result_term)
        if not self._is_eq_true(result_node):
            false_proof = self._find_proof(node, self._False)
            proof = syntax.App(syntax.Var("push_not_imp"), false_proof)
            return self._union(result_node, self._True, proof)

        return False

    def _do_true_equality_elimination(self) -> bool:
        for node in range(len(self._node_to_term)):
            if self._find(node) != self._find(self._True):
                continue
            term = self._node_to_term[node]
            if not isinstance(term, Equals):
                continue

            left_node = self._node(term.left)
            right_node = self._node(term.right)

            if not self._equals(left_node, right_node):
                proof_eq_true = self._find_proof(node, self._True)
                proof_eq = syntax.App(syntax.Var("of_eq_true"), proof_eq_true)
                if self._union(left_node, right_node, proof_eq):
                    return True

        return False

    def _do_modus_ponens(self) -> bool:
        for node in range(len(self._node_to_term)):
            if not self._equals(node, self._True):
                continue

            term = self._node_to_term[node]
            if not isinstance(term, Application):
                continue
            outer_app = term
            inner_app = outer_app.head
            if not isinstance(inner_app, Application):
                continue
            if inner_app.head != Symbol("Imp"):
                continue

            # (Imp A) B
            a_term = inner_app.arg
            b_term = outer_app.arg
            a_node = self._node(a_term)
            b_node = self._node(b_term)

            if self._equals(a_node, self._True):
                # Build proof
                proof_imp_true = self._find_proof(node, self._True)
                proof_a_true = self._find_proof(a_node, self._True)
                proof_b_true = syntax.App(
                    syntax.App(syntax.Var("modus_ponens"), proof_imp_true), proof_a_true
                )

                if not self._equals(b_node, self._True):
                    self._union(b_node, self._True, proof_b_true)
                    return True

        return False
