import sys
import unittest
from pathlib import Path


"""Behavioral tests for the equality-as-fact EGraph core.

The tests document the intended public contract:

- value terms are added neutrally;
- proposition terms passed to addTerm are true Lean hypotheses;
- proposition terms passed to addGoal are negated goals, so they become false;
- congruence closure and equality-as-fact reflection should produce bottom by
  putting True and False in the same equivalence class.
"""


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from tinygrind.egraph import (  # noqa: E402
    Constant,
    EGraph,
    Equals,
    FalseTerm,
    FunctionApplication,
    FunctionSymbol,
    NodeId,
    PredicateApplication,
    PredicateSymbol,
    NodeKind,
    TrueTerm,
)


class EGraphTests(unittest.TestCase):
    """End-to-end tests for EGraph's public API and core invariants."""

    # Node identity and construction

    def test_nodes_have_semantic_kinds(self) -> None:
        """Every public term variant receives the expected semantic node kind."""
        graph = EGraph()
        a = Constant("a")
        f = FunctionSymbol("f")
        p = PredicateSymbol("P")

        self.assertEqual(graph.addTerm(a).kind, NodeKind.VALUE)
        self.assertEqual(graph.addTerm(FunctionApplication(f, a)).kind, NodeKind.VALUE)
        self.assertEqual(graph.addTerm(f).kind, NodeKind.HIGHER_ORDER)
        self.assertEqual(graph.addTerm(p).kind, NodeKind.HIGHER_ORDER)
        self.assertEqual(graph.addTerm(PredicateApplication(p, a)).kind, NodeKind.PROP)
        self.assertEqual(graph.addTerm(Equals(a, a)).kind, NodeKind.PROP)

    def test_symbols_and_applications_get_distinct_nodes(self) -> None:
        """Symbols and applications are separate nodes, even when related syntactically."""
        graph = EGraph()
        f = FunctionSymbol("f")
        b = Constant("b")
        c = Constant("c")
        fb = FunctionApplication(f, b)
        fc = FunctionApplication(f, c)
        p = PredicateSymbol("P")
        pb = PredicateApplication(p, b)

        nodes = {
            graph.addTerm(f),
            graph.addTerm(b),
            graph.addTerm(c),
            graph.addTerm(fb),
            graph.addTerm(fc),
            graph.addTerm(p),
            graph.addTerm(pb),
        }

        self.assertEqual(len(nodes), 7)

    def test_exact_terms_reuse_nodes(self) -> None:
        """Adding the exact same public term twice returns the same graph node."""
        graph = EGraph()
        f = FunctionSymbol("f")
        a = Constant("a")
        fa = FunctionApplication(f, a)

        self.assertEqual(graph.addTerm(f), graph.addTerm(FunctionSymbol("f")))
        self.assertEqual(graph.addTerm(a), graph.addTerm(Constant("a")))
        self.assertEqual(graph.addTerm(fa), graph.addTerm(FunctionApplication(f, a)))

    def test_node_ids_are_wrapped_and_stable(self) -> None:
        """Node ids are wrapped in NodeId while repeated terms keep the same id."""
        graph = EGraph()
        first = graph.addTerm(Constant("a"))
        second = graph.addTerm(Constant("a"))

        self.assertEqual(first, second)
        self.assertIsInstance(first.id, NodeId)
        self.assertIsInstance(first.id.value, int)

    def test_add_new_helpers_reuse_existing_symbol_nodes(self) -> None:
        """The addNew* helpers are convenience wrappers around normal term insertion."""
        graph = EGraph()

        self.assertEqual(graph.addNewConstant("a"), graph.addTerm(Constant("a")))
        self.assertEqual(
            graph.addNewFunctionSymbol("f"),
            graph.addTerm(FunctionSymbol("f")),
        )
        self.assertEqual(
            graph.addNewPredicateSymbol("P"),
            graph.addTerm(PredicateSymbol("P")),
        )

    # Union-find and class inspection

    def test_equations_are_transitive(self) -> None:
        """Explicit equalities merge value classes transitively."""
        graph = EGraph()
        a = Constant("a")
        b = Constant("b")
        c = Constant("c")

        graph.addEquation(a, b)
        graph.addEquation(b, c)

        self.assertTrue(graph.sameClass(graph.addTerm(a), graph.addTerm(c)))

    def test_find_class_reports_equivalence_representatives(self) -> None:
        """findClass changes when two previously separate nodes are unioned."""
        graph = EGraph()
        a = Constant("a")
        b = Constant("b")
        a_node = graph.addTerm(a)
        b_node = graph.addTerm(b)

        self.assertNotEqual(graph.findClass(a_node), graph.findClass(b_node))

        graph.addEquation(a, b)

        self.assertEqual(graph.findClass(a_node), graph.findClass(b_node))

    # Congruence closure

    def test_function_applications_are_congruent(self) -> None:
        """If a equals b, then f(a) and f(b) become congruent."""
        graph = EGraph()
        f = FunctionSymbol("f")
        a = Constant("a")
        b = Constant("b")
        fa = FunctionApplication(f, a)
        fb = FunctionApplication(f, b)

        fa_node = graph.addTerm(fa)
        fb_node = graph.addTerm(fb)
        self.assertFalse(graph.sameClass(fa_node, fb_node))

        graph.addEquation(a, b)

        self.assertTrue(graph.sameClass(fa_node, fb_node))

    def test_nested_congruence_matches_readme_shape(self) -> None:
        """Congruence closure propagates through nested unary applications."""
        graph = EGraph()
        a = Constant("a")
        b = Constant("b")
        c = Constant("c")
        d = Constant("d")
        f = FunctionSymbol("f")
        g = FunctionSymbol("g")
        h = FunctionSymbol("h")

        fb = FunctionApplication(f, b)
        gc = FunctionApplication(g, c)
        hd = FunctionApplication(h, d)
        left = FunctionApplication(g, FunctionApplication(f, FunctionApplication(h, a)))
        right = FunctionApplication(g, FunctionApplication(f, gc))

        left_node = graph.addTerm(left)
        right_node = graph.addTerm(right)
        graph.addEquation(a, fb)
        graph.addEquation(fb, gc)
        graph.addEquation(gc, hd)
        graph.addEquation(d, a)

        self.assertTrue(graph.sameClass(left_node, right_node))

    def test_function_applications_with_different_symbols_are_not_congruent(self) -> None:
        """Sharing an argument is not enough: the function symbols must match too."""
        graph = EGraph()
        a = Constant("a")
        f = FunctionSymbol("f")
        g = FunctionSymbol("g")

        fa_node = graph.addTerm(FunctionApplication(f, a))
        ga_node = graph.addTerm(FunctionApplication(g, a))

        self.assertFalse(graph.sameClass(fa_node, ga_node))

    # Predicate facts and goals

    def test_predicate_assertion_and_false_goal_find_bottom(self) -> None:
        """Asserting P(a) true and also adding P(a) as a false goal gives bottom."""
        graph = EGraph()
        p = PredicateSymbol("P")
        a = Constant("a")
        pa = PredicateApplication(p, a)

        graph.addPredicateApplication(p, a)
        graph.addGoal(pa)
        bottom = graph.findBottom()

        self.assertTrue(bottom.found)

    def test_add_term_true_hypothesis_does_not_find_bottom(self) -> None:
        """True as a hypothesis is harmless because it is already the true class."""
        graph = EGraph()

        graph.addTerm(TrueTerm())

        self.assertTrue(graph.hasFact(TrueTerm()))
        self.assertFalse(graph.isBottom())

    def test_add_term_predicate_asserts_true_hypothesis(self) -> None:
        """Public addTerm treats predicate propositions as true Lean hypotheses."""
        graph = EGraph()
        p = PredicateSymbol("P")
        a = Constant("a")
        pa = PredicateApplication(p, a)

        graph.addTerm(pa)

        self.assertTrue(graph.hasFact(pa))

    def test_add_term_equality_asserts_true_hypothesis(self) -> None:
        """Public addTerm treats equality propositions as true Lean hypotheses."""
        graph = EGraph()
        a = Constant("a")
        b = Constant("b")

        graph.addTerm(Equals(a, b))

        self.assertTrue(graph.sameClass(graph.addTerm(a), graph.addTerm(b)))
        self.assertTrue(graph.hasFact(Equals(a, b)))

    def test_add_term_false_hypothesis_finds_bottom(self) -> None:
        """False as a true hypothesis immediately means True and False coincide."""
        graph = EGraph()

        graph.addTerm(FalseTerm())

        self.assertTrue(graph.isBottom())

    def test_has_fact_query_does_not_assert_predicate(self) -> None:
        """Querying hasFact creates/reuses a prop node without making it true."""
        graph = EGraph()
        p = PredicateSymbol("P")
        a = Constant("a")
        pa = PredicateApplication(p, a)

        self.assertFalse(graph.hasFact(pa))
        graph.addGoal(pa)

        self.assertFalse(graph.hasFact(pa))
        self.assertFalse(graph.isBottom())

    def test_goal_predicate_is_false_not_true(self) -> None:
        """addGoal(P(a)) puts P(a) in the false class and does not assert it true."""
        graph = EGraph()
        p = PredicateSymbol("P")
        a = Constant("a")
        pa = PredicateApplication(p, a)

        goal_node = graph.addGoal(pa)

        self.assertFalse(graph.hasFact(pa))
        false_node = graph.addGoal(FalseTerm())
        self.assertTrue(graph.sameClass(goal_node, false_node))
        self.assertFalse(graph.isBottom())

    def test_goal_true_finds_bottom(self) -> None:
        """A negated True goal means True is false, so bottom is immediate."""
        graph = EGraph()

        graph.addGoal(TrueTerm())

        self.assertTrue(graph.isBottom())

    def test_congruent_predicate_assertion_and_goal_find_bottom(self) -> None:
        """P(a) true contradicts P(b) false once a and b are equal."""
        graph = EGraph()
        p = PredicateSymbol("P")
        a = Constant("a")
        b = Constant("b")

        graph.addPredicateApplication(p, a)
        graph.addGoal(PredicateApplication(p, b))
        self.assertFalse(graph.isBottom())

        graph.addEquation(a, b)
        bottom = graph.findBottom()

        self.assertTrue(bottom.found)

    def test_add_term_predicate_contradicts_existing_false_goal(self) -> None:
        """A later true hypothesis can contradict an already-added false goal."""
        graph = EGraph()
        p = PredicateSymbol("P")
        a = Constant("a")
        pa = PredicateApplication(p, a)

        graph.addGoal(pa)
        self.assertFalse(graph.isBottom())

        graph.addTerm(pa)

        self.assertTrue(graph.isBottom())

    def test_different_predicates_with_same_argument_do_not_contradict(self) -> None:
        """P(a) true does not contradict Q(a) false when P and Q are distinct."""
        graph = EGraph()
        a = Constant("a")
        p = PredicateSymbol("P")
        q = PredicateSymbol("Q")

        graph.addTerm(PredicateApplication(p, a))
        graph.addGoal(PredicateApplication(q, a))

        self.assertFalse(graph.isBottom())

    # Equality facts and equality goals

    def test_false_equality_goal_finds_bottom_through_true_false(self) -> None:
        """A false equality goal is contradicted when the same equality is asserted."""
        graph = EGraph()
        a = Constant("a")
        b = Constant("b")

        graph.addGoal(Equals(a, b))
        self.assertFalse(graph.isBottom())

        graph.addEquation(a, b)
        bottom = graph.findBottom()

        self.assertTrue(bottom.found)

    def test_goal_equality_does_not_merge_value_sides(self) -> None:
        """addGoal(a = b) makes the proposition false without merging a and b."""
        graph = EGraph()
        a = Constant("a")
        b = Constant("b")

        graph.addGoal(Equals(a, b))

        self.assertFalse(graph.sameClass(graph.addTerm(a), graph.addTerm(b)))
        self.assertFalse(graph.hasFact(Equals(a, b)))
        self.assertFalse(graph.isBottom())

    def test_reflexive_equality_is_true_without_explicit_hypothesis(self) -> None:
        """The equality proposition a = a reflects to True automatically."""
        graph = EGraph()
        a = Constant("a")

        self.assertTrue(graph.hasFact(Equals(a, a)))
        self.assertFalse(graph.isBottom())

    def test_reflexive_equality_goal_finds_bottom(self) -> None:
        """A negated reflexive equality goal contradicts equality reflection."""
        graph = EGraph()
        a = Constant("a")

        graph.addGoal(Equals(a, a))

        self.assertTrue(graph.isBottom())

    def test_function_inequality_goal_finds_bottom_by_congruence(self) -> None:
        """A false f(a)=f(b) goal is contradicted once a=b makes the apps congruent."""
        graph = EGraph()
        f = FunctionSymbol("f")
        a = Constant("a")
        b = Constant("b")
        fa = FunctionApplication(f, a)
        fb = FunctionApplication(f, b)

        graph.addGoal(Equals(fa, fb))
        self.assertFalse(graph.isBottom())

        graph.addTerm(Equals(a, b))

        self.assertTrue(graph.isBottom())

    def test_equation_hypothesis_marks_equality_true(self) -> None:
        """addEquation returns the equality proposition node and marks it true."""
        graph = EGraph()
        a = Constant("a")
        b = Constant("b")

        equation_node = graph.addEquation(a, b)

        self.assertEqual(equation_node, graph.addTerm(Equals(a, b)))
        self.assertTrue(graph.hasFact(Equals(a, b)))
        self.assertFalse(graph.isBottom())

    def test_equality_facts_are_checked_symmetrically(self) -> None:
        """Knowing a=b also means hasFact reports b=a as true."""
        graph = EGraph()
        a = Constant("a")
        b = Constant("b")

        graph.addEquation(a, b)

        self.assertTrue(graph.hasFact(Equals(a, b)))
        self.assertTrue(graph.hasFact(Equals(b, a)))

    def test_reversed_equality_goal_finds_bottom(self) -> None:
        """A false a=b goal is contradicted by adding the reversed equality b=a."""
        graph = EGraph()
        a = Constant("a")
        b = Constant("b")

        graph.addGoal(Equals(a, b))
        graph.addEquation(b, a)

        bottom = graph.findBottom()

        self.assertTrue(bottom.found)

    def test_reversed_add_term_equality_contradicts_false_goal(self) -> None:
        """The same reversed-equality contradiction works through addTerm too."""
        graph = EGraph()
        a = Constant("a")
        b = Constant("b")

        graph.addGoal(Equals(a, b))
        graph.addTerm(Equals(b, a))

        self.assertTrue(graph.isBottom())



    


    # Type/category validation

    def test_rejects_value_term_as_goal(self) -> None:
        """Goals must be propositions, not value terms."""
        graph = EGraph()

        with self.assertRaises(TypeError):
            graph.addGoal(Constant("a"))

    def test_rejects_proposition_as_equation_side(self) -> None:
        """Equality sides must be values; propositions cannot be equation sides."""
        graph = EGraph()
        p = PredicateSymbol("P")
        a = Constant("a")

        with self.assertRaises(TypeError):
            graph.addEquation(PredicateApplication(p, a), a)

    def test_rejects_proposition_inside_equals(self) -> None:
        """The Equals constructor can be formed, but EGraph rejects prop sides."""
        graph = EGraph()
        p = PredicateSymbol("P")
        a = Constant("a")

        with self.assertRaises(TypeError):
            graph.addTerm(Equals(PredicateApplication(p, a), a))

    def test_rejects_proposition_as_function_argument(self) -> None:
        """Function applications only accept value arguments."""
        graph = EGraph()
        f = FunctionSymbol("f")
        p = PredicateSymbol("P")
        a = Constant("a")

        with self.assertRaises(TypeError):
            graph.addTerm(FunctionApplication(f, PredicateApplication(p, a)))

    def test_rejects_proposition_as_predicate_argument(self) -> None:
        """Predicate applications only accept value arguments."""
        graph = EGraph()
        p = PredicateSymbol("P")
        a = Constant("a")

        with self.assertRaises(TypeError):
            graph.addPredicateApplication(p, PredicateApplication(p, a))


if __name__ == "__main__":
    unittest.main()
