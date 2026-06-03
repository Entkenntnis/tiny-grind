import sys
import unittest
from pathlib import Path


"""My own tests for the Egraph

Tests on actual lemmas
"""


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from src.tinygrind.egraph import (
    EGraph,
    Constant,
    FunctionSymbol,
    PredicateSymbol,
    FunctionApplication,
    PredicateApplication,
    Equals,
    TrueTerm,
    FalseTerm,
    NodeKind,
)

class EGraphTests(unittest.TestCase):

    #test if function congruence works
    def test_function_congruence(self) -> None:
        """Graph proves this lemma:
        a = b -> f(a) = f(b)
        ."""
        graph = EGraph()
        
        a = Constant("a")
        b = Constant("b")
        f= FunctionSymbol("f")

        fa = FunctionApplication(f, a)
        fb = FunctionApplication(f, b)

        ab = Equals(a, b)
        fafb = Equals(fa, fb)

        
        nodes = {
            graph.addTerm(a),
            graph.addTerm(b),
            graph.addTerm(ab),
            graph.addTerm(f),
            graph.addTerm(fa),
            graph.addTerm(fb),

        }

        _ = graph.addGoal(fafb)
        bottom = graph.findBottom()
        self.assertTrue(bottom.found)
    
    def test_function_congruence_wrong1(self) -> None:
        """Graph DOES NOT prove this lemma:
        a -> b -> f(a) = f(b)
        ."""
        graph = EGraph()
        
        a = Constant("a")
        b = Constant("b")
        f= FunctionSymbol("f")

        fa = FunctionApplication(f, a)
        fb = FunctionApplication(f, b)

        fafb = Equals(fa, fb)

        
        nodes = {
            graph.addTerm(a),
            graph.addTerm(b),
            graph.addTerm(f),
            graph.addTerm(fa),
            graph.addTerm(fb),

        }

        _ = graph.addGoal(fafb)
        bottom = graph.findBottom()
        self.assertFalse(bottom.found)
    
    def test_function_congruence_wrong2(self) -> None:
        """Graph DOES NOT prove this lemma:
        a -> b -> c -> b = c -> f(a) = f(b)
        ."""
        graph = EGraph()
        
        a = Constant("a")
        b = Constant("b")
        c = Constant("c")
        f= FunctionSymbol("f")

        fa = FunctionApplication(f, a)
        fb = FunctionApplication(f, b)

        bc = Equals(b, c)
        fafb = Equals(fa, fb)

        
        nodes = {
            graph.addTerm(a),
            graph.addTerm(b),
            graph.addTerm(bc),
            graph.addTerm(f),
            graph.addTerm(fa),
            graph.addTerm(fb),

        }

        _ = graph.addGoal(fafb)
        bottom = graph.findBottom()
        self.assertFalse(bottom.found)
    

    def test_function_congruence_transitive1(self) -> None:
        """Graph proves this lemma:
        a -> b -> c -> a = b -> b = c -> f(a) = f(c)
        ."""
        graph = EGraph()
        
        a = Constant("a")
        b = Constant("b")
        c = Constant("c")
        f= FunctionSymbol("f")

        fa = FunctionApplication(f, a)
        fc = FunctionApplication(f, c)

        ab = Equals(a, b)
        bc = Equals(b, c)
        fafc = Equals(fa, fc)

        
        nodes = {
            graph.addTerm(a),
            graph.addTerm(b),
            graph.addTerm(ab),
            graph.addTerm(bc),
            graph.addTerm(f),
            graph.addTerm(fa),
            graph.addTerm(fc),

        }

        _ = graph.addGoal(fafc)
        bottom = graph.findBottom()
        self.assertTrue(bottom.found)
    
    def test_function_congruence_transitive2(self) -> None:
        """Graph proves this lemma:
        a -> b -> c -> a = b -> b = c -> f(a) = f(b)
        ."""
        graph = EGraph()
        
        a = Constant("a")
        b = Constant("b")
        c = Constant("c")
        f= FunctionSymbol("f")

        fa = FunctionApplication(f, a)
        fb = FunctionApplication(f, b)

        ab = Equals(a, b)
        bc = Equals(b, c)
        fafb = Equals(fa, fb)

        
        nodes = {
            graph.addTerm(a),
            graph.addTerm(b),
            graph.addTerm(ab),
            graph.addTerm(bc),
            graph.addTerm(f),
            graph.addTerm(fa),
            graph.addTerm(fb),

        }

        _ = graph.addGoal(fafb)
        bottom = graph.findBottom()
        self.assertTrue(bottom.found)
    
    #test bigger example
    def test_double_function_congruence(self) -> None:
        """Graph proves this lemma:
        a -> b -> c -> d -> f -> g -> h -> a = f(b) -> f(b) = g(c) -> g(c) = h(d) -> d = a -> g(f(h(a))) = g(f(g(c)))
        """
        graph = EGraph()

        #constants
        a = Constant("a")
        b = Constant("b")
        c = Constant("c")
        d = Constant("d")

        #function symbols
        f = FunctionSymbol("f")
        g = FunctionSymbol("g")
        h = FunctionSymbol("h")

        #first application
        fb = FunctionApplication(f, b)
        gc = FunctionApplication(g, c)
        hd = FunctionApplication(h, d)
        ha = FunctionApplication(h, a)

        #second application (application to application)
        fha = FunctionApplication(f,ha)
        fgc = FunctionApplication(f, gc)

        #second application (application to application to application)
        gfha = FunctionApplication(g, fha)
        gfgc = FunctionApplication(g, fgc)

        #equalities
        afb = Equals(a, fb)
        fbgc = Equals(fb, gc)
        gchd = Equals(gc, hd)
        da = Equals(d, a)

        #goal equality
        gfhagfgc = Equals(gfha, gfgc)

        #add nodes to graph
        _ = {
            graph.addTerm(a),
            graph.addTerm(b),
            graph.addTerm(c),
            graph.addTerm(d),
            graph.addTerm(f),
            graph.addTerm(g),
            graph.addTerm(h),
            graph.addTerm(afb),
            graph.addTerm(fbgc),
            graph.addTerm(gchd),
            graph.addTerm(da)
        }

        _ = graph.addGoal(gfhagfgc)

        bottom = graph.findBottom()
        self.assertTrue(bottom.found)


    def test_double_function_congruence_wrong1(self) -> None:
        """Graph DOES NOT prove this lemma:
        a -> b -> c -> d -> f -> g -> h -> a = f(b) -> f(b) = g(c) -> g(c) = h(d) -> d = a -> g(f(h(a))) = g(f(g(B)))
        """
        graph = EGraph()

        #constants
        a = Constant("a")
        b = Constant("b")
        c = Constant("c")
        d = Constant("d")

        #function symbols
        f = FunctionSymbol("f")
        g = FunctionSymbol("g")
        h = FunctionSymbol("h")

        #first application
        fb = FunctionApplication(f, b)
        gc = FunctionApplication(g, c)
        gb = FunctionApplication(g, b)
        hd = FunctionApplication(h, d)
        ha = FunctionApplication(h, a)

        #second application (application to application)
        fha = FunctionApplication(f,ha)
        fgb = FunctionApplication(f, gb)

        #second application (application to application to application)
        gfha = FunctionApplication(g, fha)
        gfgb = FunctionApplication(g, fgb)

        #equalities
        afb = Equals(a, fb)
        fbgc = Equals(fb, gc)
        gchd = Equals(gc, hd)
        da = Equals(d, a)

        #goal equality
        gfhagfgb = Equals(gfha, gfgb)

        #add nodes to graph
        _ = {
            graph.addTerm(a),
            graph.addTerm(b),
            graph.addTerm(c),
            graph.addTerm(d),
            graph.addTerm(f),
            graph.addTerm(g),
            graph.addTerm(h),
            graph.addTerm(afb),
            graph.addTerm(fbgc),
            graph.addTerm(gchd),
            graph.addTerm(da)
        }

        _ = graph.addGoal(gfhagfgb)

        bottom = graph.findBottom()
        self.assertFalse(bottom.found)

    
    #test predicates
    def test_predicate_congruence(self) -> None:
        """Graph proves this lemma:
        a = b -> P(a) = true -> P(b) = true
        """
        graph = EGraph()
        
        p = PredicateSymbol("P")
        a = Constant("a")
        b = Constant("b")

        pa = PredicateApplication(p, a)
        pb = PredicateApplication(p, b)

        ab = Equals(a, b)

        _ = graph.addTerm(ab)
        _ = graph.addTerm(pa)
       
        
        _ = graph.addGoal(pb)

        bottom = graph.findBottom()
        self.assertTrue(bottom.found)

        






        







        


