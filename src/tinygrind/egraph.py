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


class EGraph:

    def __init__(self):
        # Node directly indexes into these data structures
        self._parents: list[Node] = []
        self._node_to_term: list[Term] = []

        # store proofs between nodes
        self._nodes_to_proof: dict[Node, dict[Node, syntax.Term]] = {}

        # "structual sharing" happens here
        self._term_to_node: dict[Term, Node] = {}
        self._True: Node = self._add_term(TrueTerm())
        self._False: Node = self._add_term(FalseTerm())

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
        self._rebuild()

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

        self._term_to_node[term] = node
        return node

    def _node(self, term: Term) -> Node:
        return self._term_to_node[term]

    def _find(self, node: Node) -> Node:
        # returns the representant
        while self._parents[node] != node:
            node = self._parents[node]
        return node

    def _union(self, a: Node, b: Node, proof: syntax.Term) -> bool:
        ra = self._find(a)
        rb = self._find(b)
        if ra == rb:
            return False

        self._parents[rb] = ra
        self._nodes_to_proof.setdefault(a, {})[b] = proof
        self._nodes_to_proof.setdefault(b, {})[a] = syntax.App(
            syntax.Var("Eq.symm"), proof
        )

        return True

    def _find_proof(self, a: Node, b: Node) -> syntax.Term:
        if a == b:
            return syntax.Var("rfl")

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

    def _rebuild(self):
        while (
            self._do_congrunce_closure()
            or self._do_equality_reflection()
            or self._do_elimination_of_conjunction()
            or self._do_true_equality_elimination()
            or self._do_modus_ponens()
        ):
            pass

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

    def _do_elimination_of_conjunction(self) -> bool:
        for node in range(len(self._node_to_term)):
            if self._find(node) != self._find(self._True):
                continue

            term = self._node_to_term[node]

            if not isinstance(term, Application):
                continue

            outer = term
            inner = outer.head
            if not isinstance(inner, Application):
                continue
            if inner.head != Symbol("And"):
                continue

            # We have an true AND term
            left = self._node(inner.arg)
            right = self._node(outer.arg)

            if not self._equals(left, self._True):
                proof_and_true = self._find_proof(node, self._True)
                proof_left = syntax.App(syntax.Var("and_elim_left"), proof_and_true)
                if self._union(left, self._True, proof_left):
                    return True

            if not self._equals(right, self._True):
                proof_and_true = self._find_proof(node, self._True)
                proof_right = syntax.App(syntax.Var("and_elim_right"), proof_and_true)
                if self._union(right, self._True, proof_right):
                    return True

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
