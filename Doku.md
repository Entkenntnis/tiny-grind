# Doku

## Union Find

### _union
Verbindet zwei Äquivalenzklassen. Hängt die kleinere and die Größere an (Größen der Klassen werden in "_sizes" gespeichert). Konkret werden die Einträge in "_parents" verändert. "_parents" speichert für jede Node ihren Repräsentanten und damit ihre Äquivalenzklasse.

### _find
Returned einfach nur den Repräsentanten der Äquivalenzklasse, kann zb genutzt werden um zu testen, ob zwei Nodes in der gleichen Äquivalenzklasse sind (dann haben sie den gleichen Repräsentanten)



## Basic E-Graph (Phase 00)

### =
Um als Goal eine Ungleichheit darstellen zu können. (= ist dann in einer Äquivalenzklasse mit False)

### _rebuild
ruft alle "Simplifizierungen" auf: 
- Constraint Propagation
- Congruence Closure
- Case Splitting
- Modus Ponens
bis der Graph sich stabilisiert hat/ Bottom gefunden wurde.
Wird aufgerufen, wenn in den Graph eingefügt wird.

### _do_equality_reflection
wenn eine Equals Node existiert, die nicht True ist (also evtl. in der gleichen Klasse mit False ist), und der linke und rechte Term gleich sind, wird die Node mit True geunioned. 
Wenn die Node in der gleichen Klasse mit False war, haben wir eine Contradiction (True und False in der gleichen Klasse), die kommt daher dass zwei ungleiche Terme mit einem = verbunden sind.

### _do_true_equality_elimination
wenn eine Equals Node existiert, die True ist (also in der gleichen Klasse mit True ist), wird die linke und die Rechte Seite geunioned.

### _do_congrunce_closure
"wenn a = b, dann f(a) = f(b)"
key = (repr_head, repr_arg) 
Wenn a und b gleich sind, ist repr_arg von a und repr_arg von b gleich, und repr_head von f ist immer gleich, wenn es exakt die gleiche Funktion ist. Die repr_arg kommen aus dem "parents" array, in dem für jede Node ihr Repräsentant, bzw der Repräsentant der Äquivalenzklasse gespeichert ist.

Wenn wir also den key nochmal finden, haben wir eine weitere Kombination, bei der die Funktion gleich ist und die Argumente ebenfalls gleich sind, also zb den Fall (wenn a = b, dann f(a) = f(b)). Dann werden auch die Applications f(a) und f(b) geunioned, weil sie gleich sind. In diesem Schritt wird der Proof ("congr") gespeichert.

### _find_proof
Wir speichern für alle Unions die Beweise in beide Richtungen. Damit lässt sich zwischen je zwei nodes a und b einer Äquivalenzklasse ein Beweis konstruieren von der Form a = b. Der Beweis wird über ein Breath-First-Search gefunden, der Algorithmus bricht ab, sobald eine Verbindungen gefunden wurde und gibt den Beweis als direkten lean-Term zurück.

## E-Graph Erweiterungen (Phase 01)

### _try_case_split (1)
(wird aufgerufen wenn congruence closure, propagation nicht mehr weiter kommen)
Wenn ein Or existiert, kopiere den Graphen:
- nehme die linke Seite (Term) an, versuche eine Contradiction zu finden
- gleiches mit der rechten Seiten

### _do_propositional_constraint_propagation
(Es werden keine neuen Nodes erstellt, nur Existierende geunioned)
Propagiert AND, OR und NOT (ohne Case Splitting, das passiert an anderer Stelle). (Das sind die Funktionen _propagate*)
Zum Beispiel: A = True      => ¬A = False
Checkt, ob A in der gleichen Äquivalenzklasse wie True ist, und ¬A (welches eine Application ist), noch nicht in der gleichen Äquivalenzklasse wie False ist (sonst können wir uns den Rest sparen. Dann wird der Proof für die linke Seite gefunden, und ein neuer Proof für die Rechte seite mit einem Helper-Theorem "not_eq_false_of_arg_true" gebaut. Zuletzt werden ¬A und False geunioned.

### _do_push_not
(Hier werden tatsächlich neue Nodes erstellt)
Pusht Not in AND, OR und IMP (Das sind die Funktionen _push_not*)
Zum Beispiel: (A ∧ B) = False => (¬ A ∨ ¬ B) = True
Erstellt neue Nodes für die rechte Seite (falls noch nicht existent), erstellt den Proof via Helper-Theorem "push_not_and" und unioned die OR-Node mit True.

### _binary_connective_args und _unary_connective_args
Helper-Funktion für die Propagator und Pusher um zu checken ob es sich um AND, OR, IMP oder NOT handelt.

### _try_case_split (2)
Schließlich, wenn nichts mehr zu tun ist, wird eine Prop-Node gesucht, die noch keinem Wahrheitswert (True/False) zugewiesen wurde. Nun wird einmal diese Prop auf True gesetzt, und einmal auf False. Wenn in beiden Fällen ein Widerspruch auftritt, dann kann daraus der Beweis konstruiert werden (law of the excluded middle).


