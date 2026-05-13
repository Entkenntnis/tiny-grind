from pathlib import Path
from lark import Lark
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

parser = Lark(grammar, start="start", parser="lalr")

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
        tree = parser.parse(content)  # pyright: ignore[reportUnknownMemberType]
        print(path)
        okCounter += 1
        print(tree)
    except Exception as e:
        # print(f"-> failed to parse: {e}")
        pass

print(f"{okCounter} parsed correctly")
