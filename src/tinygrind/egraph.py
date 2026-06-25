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
    arity: int  # all arguments are of type Sort for now


type Term = TrueTerm | FalseTerm | Equals | Application | Symbol


type Node = int


class EGraph:

    def __init__(self, debug: bool = False):
        # Node directly indexes into these data structures
        self._parents: list[Node] = []
        self._sizes: list[int] = []
        self._node_to_term: list[Term] = []

        # store proofs between nodes
        self._nodes_to_proof: dict[Node, dict[Node, syntax.Term]] = {}

        # Output detailed information about actions
        self._debug: bool = debug

        # "structual sharing" happens here
        self._term_to_node: dict[Term, Node] = {}

        # we start with 2 built-in nodes
        self._add_term(TrueTerm())
        self._true_node: Node = self._get_node(TrueTerm())

        self._add_term(FalseTerm())
        self._false_node: Node = self._get_node(FalseTerm())

    def addSymbol(self, symbol: Symbol):  # no proof obligation
        self._add_term(symbol)
        self._deb(f"insert symbol {symbol} as node #{self._get_node(symbol)}")
        self._rebuild()

    def addProp(
        self, prop: Term, proof: syntax.Term
    ):  # everything else does need an proof
        self._add_term(prop)
        # it should be fine to set the proof right?
        node = self._get_node(prop)
        self._deb(f"insert prop {prop} as node #{node}")

        _ = self._union(node, self._true_node, syntax.App(syntax.Var("eq_true"), proof))

        if isinstance(prop, Equals):
            # union now, so we don't need to do this later
            _ = self._union(
                self._get_node(prop.left), self._get_node(prop.right), proof
            )

        self._rebuild()

    def addGoal(
        self, goal: Term, proof: syntax.Term
    ):  # everything else does need an proof
        self._add_term(goal)
        # it should be fine to set the proof right?
        node = self._get_node(goal)
        self._deb(f"insert goal {goal} as node #{node}")

        _ = self._union(
            node, self._false_node, syntax.App(syntax.Var("eq_false_intro"), proof)
        )
        self._rebuild()

    def findProof(self, a: Term, b: Term) -> syntax.Term:
        return self._find_proof(self._get_node(a), self._get_node(b))

    def isBottom(self) -> bool:
        ra = self._find(self._true_node)
        rb = self._find(self._false_node)
        return ra == rb

    def _deb(self, msg: str):
        if self._debug:
            print(f"      ~ {msg}")

    def _add_term(self, term: Term) -> None:
        existing = self._term_to_node.get(term)
        if existing is not None:
            # nothing to do
            return

        # recursively add children
        if isinstance(term, Application):
            self._add_term(term.head)
            self._add_term(term.arg)
        elif isinstance(term, Equals):
            self._add_term(term.left)
            self._add_term(term.right)

        node = len(self._sizes)  # it really is just a continues int id
        self._sizes.append(1)
        self._parents.append(node)  # self parent, own eclass
        self._node_to_term.append(term)

        self._term_to_node[term] = node

    def _get_node(self, term: Term) -> Node:
        node = self._term_to_node.get(term)
        if node is None:
            raise RuntimeError(f"Expected node for term {term} to exist")
        return node

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

        if self._sizes[ra] < self._sizes[rb]:
            ra, rb = rb, ra

        self._parents[rb] = ra
        self._sizes[ra] += self._sizes[rb]

        self._nodes_to_proof.setdefault(a, {})[b] = proof
        self._nodes_to_proof.setdefault(b, {})[a] = syntax.App(
            syntax.Var("Eq.symm"), proof
        )

        self._deb(f"union #{a} and #{b} with proof {proof}")

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
                output = parent[current][1]  # this is the proof from parent to my
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
        while self._do_congrunce_closure() or self._do_equality_reflection():
            pass

    def _do_congrunce_closure(self) -> bool:
        # if self._debug:
        #     print(f"      ~ Doing congruence closure now")

        seen: dict[tuple[Node, Node], Node] = {}
        for node in range(len(self._node_to_term)):
            term = self._node_to_term[node]
            if not isinstance(term, (Application)):
                continue  # not relevant here

            # define a key
            repr_head = self._find(self._get_node(term.head))
            repr_arg = self._find(self._get_node(term.arg))
            key = (repr_head, repr_arg)

            previous = seen.get(key)
            if previous is None:
                seen[key] = node
            elif self._find(previous) != self._find(node):
                # build proof
                prev_term = self._node_to_term[previous]
                node_term = self._node_to_term[node]

                if not isinstance(prev_term, (Application)) or not isinstance(
                    node_term, Application
                ):
                    raise RuntimeError("Application expected in congruence closure")

                head_proof = self._find_proof(
                    self._get_node(prev_term.head), self._get_node(node_term.head)
                )

                arg_proof = self._find_proof(
                    self._get_node(prev_term.arg), self._get_node(node_term.arg)
                )

                proof = syntax.App(
                    syntax.App(syntax.Var("congr"), head_proof), arg_proof
                )

                self._deb(f"Merging #{previous} with #{node} because of congruence")

                return self._union(previous, node, proof)

        return False

    def _do_equality_reflection(self) -> bool:
        for node in range(len(self._node_to_term)):
            term = self._node_to_term[node]
            if isinstance(term, Equals):
                left_node = self._get_node(term.left)
                right_node = self._get_node(term.right)
                if self._find(left_node) == self._find(right_node) and self._find(
                    node
                ) != self._find(self._true_node):
                    if self._union(
                        node,
                        self._true_node,
                        proof=syntax.App(
                            syntax.Var("eq_true"),
                            self._find_proof(left_node, right_node),
                        ),
                    ):
                        self._deb(f"Equality Reflection, #{node} becomes True")
                        return True
        return False
