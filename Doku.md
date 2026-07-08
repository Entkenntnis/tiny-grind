# Doku

## =
Um als Goal eine Ungleichheit darstellen zu können. (= ist dann in einer Äquivalenzklasse mit False)

## _rebuild
ruft alle "Simplifizierungen" auf: 
- Constraint Propagation
- Congruence Closure
- Case Splitting
- Modus Ponens

## _do_equality_reflection
wenn eine Equals Node existiert, die nicht True ist (also evtl. in der gleichen Klasse mit False ist), und der linke und rechte Term gleich sind, wird die Node mit True geunioned. 
Wenn die Node in der gleichen Klasse mit False war, haben wir eine Contradiction (True und False in der gleichen Klasse), die kommt daher dass zwei ungleiche Terme mit einem = verbunden sind.


## _do_true_equality_elimination
wenn eine Equals Node existiert, die True ist (also in der gleichen Klasse mit True ist), wird die linke und die Rechte Seite geunioned.

## _do_congrunce_closure
"wenn a = b, dann f(a) = f(b)"
key = (repr_head, repr_arg) 
wenn a und b gleich sind, ist repr_arg von a und repr_arg von b gleich, und repr_head von f ist immer gleich. Wenn wir also den key nochmal finden, haben wir denn Fall (wenn a = b, dann f(a) = f(b)). Dann werden die Applications f(a) und f(b) geunioned, weil sie gleich sind. In diesem Schritt wird der Proof ("congr") gespeichert.

## _try_case_split
(wird aufgerufen wenn congruence closure, propagation nicht mehr weiter kommen)
Wenn ein Or existiert, kopiere den Graphen:
- nehme die linke Seite (Term) an, versuche eine Contradiction zu finden
- gleiches mit der rechten


## _do_propositional_constraint_propagation
 (Es werden keine neuen Nodes erstellt, nur Existierende geunioned)
