from lark import Lark
import os

tptp_parser = Lark(
    r"""
	tptp_file : tptp_input*
	tptp_input : annotated_formula | include

	annotated_formula : thf_annotated | tfx_annotated | tff_annotated| tcf_annotated | fof_annotated | cnf_annotated | tpi_annotated

	tpi_annotated : "tpi(" NAME "," FORMULA_ROLE "," tpi_formula annotations* ")."
	tpi_formula : fof_formula
	thf_annotated : "thf(" NAME "," FORMULA_ROLE "," thf_formula annotations* ")."
	tfx_annotated : "tfx("  NAME "," FORMULA_ROLE "," tfx_formula annotations* ")."
	tff_annotated : "tff(" NAME "," FORMULA_ROLE "," tff_formula annotations* ")."
	tcf_annotated : "tcf(" NAME "," FORMULA_ROLE "," tcf_formula annotations* ")."
	fof_annotated : "fof(" NAME "," FORMULA_ROLE "," fof_formula annotations* ")."
	cnf_annotated : "cnf(" NAME "," FORMULA_ROLE "," cnf_formula annotations* ")."
	annotations : "," source (optional_info)*

	FORMULA_ROLE : "axiom" | "hypothesis" | "definition" | "assumption" | "lemma" | "theorem" | "corollary" | "conjecture"
				| "negated_conjecture" | "plain" | "type" | "fi_domain" | "fi_functors" | "fi_predicates" | "unknown" | LOWER_WORD

	thf_formula : thf_logic_formula | thf_sequent
	thf_logic_formula : thf_binary_formula | thf_unitary_formula | thf_type_formula | thf_subtype
	thf_binary_formula : thf_binary_pair | thf_binary_tuple | thf_binary_type

	thf_binary_pair : thf_unitary_formula thf_pair_connective thf_unitary_formula
	thf_binary_tuple : thf_or_formula | thf_and_formula | thf_apply_formula
	thf_or_formula : thf_unitary_formula "|" thf_unitary_formula | thf_or_formula "|" thf_unitary_formula
	thf_and_formula : thf_unitary_formula "&" thf_unitary_formula | thf_and_formula "&" thf_unitary_formula

	thf_apply_formula: thf_unitary_formula "@" thf_unitary_formula | thf_apply_formula "@" thf_unitary_formula

	thf_unitary_formula : thf_quantified_formula | thf_unary_formula | thf_atom | thf_conditional | thf_let | thf_tuple | "(" thf_logic_formula ")"

	thf_quantified_formula : thf_quantification thf_unitary_formula
	thf_quantification : thf_quantifier "[" thf_variable_list "] :"
	thf_variable_list : thf_variable ("," thf_variable)*
	thf_variable : thf_typed_variable | VARIABLE
	thf_typed_variable : VARIABLE ":" thf_top_level_type

	thf_unary_formula : thf_unary_connective "(" thf_logic_formula ")"
	thf_atom : thf_function | VARIABLE | defined_term | thf_conn_term

	thf_function : ATOM | FUNCTOR "(" thf_arguments ")" | DEFINED_FUNCTOR "(" thf_arguments ")" | SYSTEM_FUNCTOR "(" thf_arguments ")"

	thf_conn_term : thf_pair_connective | ASSOC_CONNECTIVE | thf_unary_connective

	thf_conditional : "$ite(" thf_logic_formula "," thf_logic_formula "," thf_logic_formula ")"

	thf_let : "$let(" thf_unitary_formula "," thf_formula ")" | "$let(" thf_let_defns "," thf_formula")"
	thf_let_defns : thf_let_defn | "[" thf_let_defn_list "]"
	thf_let_defn_list : thf_let_defn ("," thf_let_defn)*
	thf_let_defn : thf_let_quantified_defn | thf_let_plain_defn
	thf_let_quantified_defn: thf_quantification "(" thf_let_plain_defn ")"
	thf_let_plain_defn: thf_let_defn_lhs ASSIGNMENT thf_formula
	thf_let_defn_lhs : CONSTANT | FUNCTOR "(" fof_arguments ")" | thf_tuple

	thf_arguments : thf_formula_list

	thf_type_formula : thf_typeable_formula ":" thf_top_level_type | CONSTANT ":" thf_top_level_type
	thf_typeable_formula : thf_atom | "(" thf_logic_formula ")"
	thf_subtype : thf_atom "<<" thf_atom

	thf_top_level_type : thf_unitary_type | thf_mapping_type | thf_apply_type

	thf_unitary_type : thf_unitary_formula
	thf_apply_type : thf_apply_formula
	thf_binary_type : thf_mapping_type | thf_xprod_type | thf_union_type
	thf_mapping_type : thf_unitary_type ">" thf_unitary_type | thf_unitary_type ">" thf_mapping_type
	thf_xprod_type : thf_unitary_type "*" thf_unitary_type | thf_xprod_type "*" thf_unitary_type
	thf_union_type : thf_unitary_type "+" thf_unitary_type | thf_union_type "+" thf_unitary_type

	thf_sequent : thf_tuple "-->" thf_tuple | "(" thf_sequent ")"

	thf_tuple : "[" thf_formula_list? "]" | "{" thf_formula_list? "}"
	thf_formula_list : thf_logic_formula ("," thf_logic_formula)*

	logic_defn_rule : logic_defn_lhs ASSIGNMENT logic_defn_rhs
	logic_defn_lhs : LOGIC_DEFN_VALUE | thf_top_level_type | NAME | "$constants" | "$quantification" | "$consequence" | "$modalities"

	logic_defn_rhs : LOGIC_DEFN_VALUE | thf_unitary_formula
	LOGIC_DEFN_VALUE : DEFINED_CONSTANT | "$rigid" | "$flexible" | "$constant" | "$varying" | "$cumulative" | "$decreasing" | "$local"
					| "$global" | "$modal_system_K" | "$modal_system_T" | "$modal_system_D" | "$modal_system_S4" | "$modal_system_S5"
					| "$modal_axiom_K" | "$modal_axiom_T" | "$modal_axiom_B" | "$modal_axiom_D" | "$modal_axiom_4" | "$modal_axiom_5"

	tfx_formula : tfx_logic_formula | thf_sequent
	tfx_logic_formula : thf_logic_formula

	tff_formula : tff_logic_formula | tff_typed_atom | tff_sequent
	tff_logic_formula : tff_binary_formula | tff_unitary_formula | tff_subtype
	tff_binary_formula : tff_binary_nonassoc | tff_binary_assoc
	tff_binary_nonassoc : tff_unitary_formula BINARY_CONNECTIVE tff_unitary_formula
	tff_binary_assoc : tff_or_formula | tff_and_formula
	tff_or_formula : tff_unitary_formula "|" tff_unitary_formula | tff_or_formula "|" tff_unitary_formula
	tff_and_formula : tff_unitary_formula "&" tff_unitary_formula | tff_and_formula "&" tff_unitary_formula
	tff_unitary_formula : tff_quantified_formula | tff_unary_formula | tff_atomic_formula | tff_conditional | tff_let | "(" tff_logic_formula ")"

	tff_quantified_formula : FOF_QUANTIFIER "[" tff_variable_list "] :" tff_unitary_formula
	tff_variable_list : tff_variable ("," tff_variable)*
	tff_variable : tff_typed_variable | VARIABLE
	tff_typed_variable : VARIABLE ":" tff_atomic_type
	tff_unary_formula : "~" tff_unitary_formula | fof_infix_unary
	tff_atomic_formula : fof_atomic_formula
	tff_conditional : "$ite_f(" tff_logic_formula "," tff_logic_formula "," tff_logic_formula ")"
	tff_let : "$let_tf(" tff_let_term_defns "," tff_formula ")" | "$let_ff(" tff_let_formula_defns "," tff_formula ")"

	tff_let_term_defns : tff_let_term_defn | "[" tff_let_term_list "]"
	tff_let_term_list : tff_let_term_defn ("," tff_let_term_defn)*
	tff_let_term_defn : "! [" tff_variable_list "] :" tff_let_term_defn | tff_let_term_binding
	tff_let_term_binding : fof_plain_term "=" fof_term | "(" tff_let_term_binding ")"
	tff_let_formula_defns : tff_let_formula_defn | "[" tff_let_formula_list "]"
	tff_let_formula_list : tff_let_formula_defn ("," tff_let_formula_defn)*
	tff_let_formula_defn : "! [ "tff_variable_list "] :" tff_let_formula_defn | tff_let_formula_binding
	tff_let_formula_binding : fof_plain_atomic_formula "<=>" tff_unitary_formula | "(" tff_let_formula_binding ")"
	tff_sequent : tff_formula_tuple "-->" tff_formula_tuple | "(" tff_sequent ")"
	tff_formula_tuple : "[" [tff_formula_tuple_list] "]"
	tff_formula_tuple_list : tff_logic_formula ("," tff_logic_formula)*

	tff_typed_atom : UNTYPED_ATOM ":" tff_top_level_type | "(" tff_typed_atom ")"
	tff_subtype : UNTYPED_ATOM "<<" ATOM

	tff_top_level_type : tff_atomic_type | tff_mapping_type | tf1_quantified_type | "(" tff_top_level_type ")"
	tf1_quantified_type : "!> [" tff_variable_list "] :" tff_monotype
	tff_monotype : tff_atomic_type | "(" tff_mapping_type ")"
	tff_unitary_type :  tff_atomic_type | "(" tff_xprod_type ")"
	tff_atomic_type : TYPE_CONSTANT | DEFINED_TYPE | TYPE_FUNCTOR "(" tff_type_arguments ")" | VARIABLE
	tff_type_arguments : tff_atomic_type ("," tff_atomic_type)*

	tff_mapping_type : tff_unitary_type ">" tff_atomic_type
	tff_xprod_type : tff_unitary_type "*" tff_atomic_type | tff_xprod_type "*" tff_atomic_type


	tcf_formula : tcf_logic_formula | tff_typed_atom
	tcf_logic_formula : tcf_quantified_formula | cnf_formula
	tcf_quantified_formula : "! [" tff_variable_list "] :" cnf_formula


	fof_formula : fof_logic_formula | fof_sequent
	fof_logic_formula : fof_binary_formula | fof_unitary_formula

	fof_binary_formula :  fof_binary_nonassoc | fof_binary_assoc
	
	fof_binary_nonassoc : fof_unitary_formula BINARY_CONNECTIVE fof_unitary_formula
	
	fof_binary_assoc : fof_or_formula | fof_and_formula
	fof_or_formula : fof_unitary_formula "|" fof_unitary_formula | fof_or_formula "|" fof_unitary_formula
	fof_and_formula  : fof_unitary_formula "&" fof_unitary_formula | fof_and_formula "&"  fof_unitary_formula
	
	fof_unitary_formula : fof_quantified_formula | fof_unary_formula | fof_atomic_formula | "(" fof_logic_formula ")"
	
	fof_quantified_formula : FOF_QUANTIFIER "[" fof_variable_list "] :" fof_unitary_formula
	fof_variable_list : VARIABLE ("," VARIABLE)*
	fof_unary_formula : "~" fof_unitary_formula | fof_infix_unary
	
	fof_infix_unary : fof_term INFIX_INEQUALITY fof_term
	fof_atomic_formula : fof_plain_atomic_formula | fof_defined_atomic_formula | fof_system_atomic_formula
	fof_plain_atomic_formula : fof_plain_term
	fof_defined_atomic_formula : fof_defined_plain_formula | fof_defined_infix_formula
	fof_defined_plain_formula : fof_defined_plain_term | DEFINED_PROPOSITION | DEFINED_PREDICATE "(" fof_arguments ")"
	fof_defined_infix_formula : fof_term defined_infix_pred fof_term

	fof_system_atomic_formula : fof_system_term

	fof_plain_term : CONSTANT | FUNCTOR "(" fof_arguments ")"

	fof_defined_term : defined_term | fof_defined_atomic_term
	fof_defined_atomic_term : fof_defined_plain_term

	fof_defined_plain_term : DEFINED_CONSTANT | DEFINED_FUNCTOR "(" fof_arguments ")"

	fof_system_term : SYSTEM_CONSTANT | SYSTEM_FUNCTOR "(" fof_arguments ")"

	fof_arguments : fof_term ("," fof_term)*

	fof_term : fof_function_term | VARIABLE | tff_conditional_term | tff_let_term | tff_tuple_term
	fof_function_term : fof_plain_term | fof_defined_term | fof_system_term
	
	tff_conditional_term : "$ite_t(" tff_logic_formula "," fof_term "," fof_term ")"
	tff_let_term : "let_ft(" tff_let_formula_defns "," fof_term ")" | "$let_tt(" tff_let_term_defns ","fof_term ")"
	tff_tuple_term : "{" [fof_arguments] "}"


	fof_sequent : fof_formula_tuple "-->" fof_formula_tuple | "(" fof_sequent ")"
	fof_formula_tuple : "[" [fof_formula_tuple_list] "]"
	fof_formula_tuple_list : fof_logic_formula ("," fof_logic_formula)*


	cnf_formula : disjunction | "(" disjunction ")"
	disjunction : literal ("|" literal)*
	literal : fof_atomic_formula | "~" fof_atomic_formula | fof_infix_unary

	thf_quantifier : FOF_QUANTIFIER | TH0_QUANTIFIER | TH1_QUANTIFIER

	TH1_QUANTIFIER : "!>" | "?*"
	TH0_QUANTIFIER : "^" | "@+" | "@-"
	thf_pair_connective : INFIX_EQUALITY | INFIX_INEQUALITY | BINARY_CONNECTIVE | ASSIGNMENT
	thf_unary_connective : "~" | TH1_UNARY_CONNECTIVE
	TH1_UNARY_CONNECTIVE : "!!" | "??" | "@@+" | "@@-" | "@="

	FOF_QUANTIFIER : "!" | "?"
	BINARY_CONNECTIVE : "<=>" | "=>" | "<=" | "<~>" | "~|" | "~&"
	ASSOC_CONNECTIVE: "&" | "|"

	ASSIGNMENT : ":="

	TYPE_CONSTANT : TYPE_FUNCTOR
	TYPE_FUNCTOR : ATOMIC_WORD
	DEFINED_TYPE : ATOMIC_DEFINED_WORD | "$oType" | "$o" | "$iType" | "$i" | "$tType" | "$real" | "$rat" | "$int"

	SYSTEM_TYPE : ATOMIC_SYSTEM_WORD

	ATOM : UNTYPED_ATOM | DEFINED_CONSTANT
	UNTYPED_ATOM : CONSTANT | SYSTEM_CONSTANT
	DEFINED_PROPOSITION :  ATOMIC_DEFINED_WORD | "$true" | "$false"
	DEFINED_PREDICATE : ATOMIC_DEFINED_WORD | "$distinct" | "$less" | "$lesseq" | "$greater" | "$greatereq" | "$is_int"
						| "$is_rat" | "$box_P" | "$box_i" | "$box_int" | "$box" | "$dia_P" | "$dia_i" | "$dia_int" | "$dia"

	defined_infix_pred : INFIX_EQUALITY | ASSIGNMENT
	INFIX_EQUALITY : "="
	INFIX_INEQUALITY : "!="

	CONSTANT : FUNCTOR
	FUNCTOR : ATOMIC_WORD
	SYSTEM_CONSTANT : SYSTEM_FUNCTOR
	SYSTEM_FUNCTOR : ATOMIC_SYSTEM_WORD
	DEFINED_CONSTANT : DEFINED_FUNCTOR
	DEFINED_FUNCTOR : ATOMIC_DEFINED_WORD |"$uminus" | "$sum" | "$difference" | "$product" | "$quotient" | "$quotient_e" | "$quotient_t" | "$quotient_f"
					| "$remainder_e" | "$remainder_t" | "$remainder_f" | "$floor" | "$ceiling" | "$truncate" | "$round" | "$to_int" | "$to_rat" | "$to_real"
	defined_term : number | DISTINCT_OBJECT
	VARIABLE : UPPER_WORD

	source : general_term | dag_source | internal_source | external_source | "[" sources "]"
	sources : source ("," source)*
	dag_source : NAME | inference_record
	inference_record : "inference(" INFERENCE_RULE "," useful_info "," inference_parents ")"
	INFERENCE_RULE : ATOMIC_WORD

	inference_parents : "[" parent_list* "]"
	parent_list : parent_info ("," parent_info)*
	parent_info : source parent_details*
	parent_details : general_list
	internal_source : "introduced(" intro_type optional_info* ")"
	intro_type : "definition" | "axiom_of_choice" | "tautology" | "assumption"

	external_source : file_source | theory | creator_source
	file_source : "file(" FILE_NAME FILE_INFO* ")"
	FILE_INFO : "," NAME
	theory : "theory(" THEORY_NAME optional_info* ")"
	THEORY_NAME : "equality" | "ac"

	creator_source : "creator(" CREATOR_NAME optional_info* ")"
	CREATOR_NAME : ATOMIC_WORD

	optional_info : "," useful_info
	useful_info : general_list | "[" info_items* "]"
	info_items : info_item ("," info_item)*
	info_item : formula_item | inference_item | general_function

	formula_item : DESCRIPTION_ITEM  | IQUOTE_ITEM
	DESCRIPTION_ITEM : "description(" ATOMIC_WORD ")"
	IQUOTE_ITEM : "iquote(" ATOMIC_WORD ")"

	inference_item : inference_status | assumptions_record | new_symbol_record | refutation
	inference_status : "status(" STATUS_VALUE ")" | inference_info

	STATUS_VALUE : "suc" | "unp" | "sap" | "esa" | "sat" | "fsa" | "thm" | "eqv" | "tac" | "wec" | "eth" | "tau" | "wtc" | "wth" | "cax" | "sca" | "tca"
				| "wca" | "cup" | "csp" | "ecs" | "csa" | "cth" | "ceq" | "unc" | "wcc" | "ect" | "fun" | "uns" | "wuc" | "wct" | "scc" | "uca" | "noc"

	inference_info : INFERENCE_RULE "(" ATOMIC_WORD "," general_list ")"

	assumptions_record : "assumptions([" name_list "])"

	refutation : "refutation(" file_source ")"

	new_symbol_record : "new_symbols(" ATOMIC_WORD ", [" new_symbol_list "])"
	new_symbol_list : principal_symbol ("," principal_symbol)*

	principal_symbol : FUNCTOR | VARIABLE


	include : "include(" FILE_NAME formula_selection* ")."
	formula_selection : ",[" name_list "]"
	name_list : NAME ("," NAME)*

	general_term : general_data | general_data ":" general_term | general_list
	general_data : ATOMIC_WORD | general_function | VARIABLE | number | DISTINCT_OBJECT | formula_data | "bind(" VARIABLE "," formula_data ")"
	general_function : ATOMIC_WORD "(" general_terms ")"

	formula_data : "$thf(" thf_formula ")" | "$tff(" tff_formula ")" | "$fof(" fof_formula ")" | "$cnf(" cnf_formula ")" | "$fot(" fof_term ")"
	general_list : "[" general_terms? "]"
	general_terms : general_term ("," general_term)*

	NAME : ATOMIC_WORD | INTEGER

	ATOMIC_WORD : LOWER_WORD | SINGLE_QUOTED

	ATOMIC_DEFINED_WORD : "$" LOWER_WORD
	ATOMIC_SYSTEM_WORD : "$$" LOWER_WORD
	number : INTEGER | RATIONAL | REAL

	FILE_NAME : SINGLE_QUOTED

	comment : COMMENT_LINE | COMMENT_BLOCK
	COMMENT_LINE : "%" PRINTABLE_CHAR*
	COMMENT_BLOCK : "/*" NOT_STAR_SLASH? "*"+ "/"
	NOT_STAR_SLASH : ("^*"* "*"+ "^/*") ("^*")*

	SINGLE_QUOTED : "'" SQ_CHAR+ "'"

	DISTINCT_OBJECT : "\"" DO_CHAR* "\""

	UPPER_WORD : UPPER_ALPHA ALPHA_NUMERIC*
	LOWER_WORD : LOWER_ALPHA ALPHA_NUMERIC*

	REAL : SIGN? DECIMAL_FRACTION | SIGN? DECIMAL_EXPONENT
	RATIONAL : SIGN? DECIMAL "/" POSITIVE_DECIMAL
	INTEGER : SIGN? DECIMAL
	DECIMAL : ZERO_NUMERIC | POSITIVE_DECIMAL
	POSITIVE_DECIMAL : NON_ZERO_NUMERIC NUMERIC*           
	DECIMAL_EXPONENT : DECIMAL "Ee" EXP_INTEGER | DECIMAL_FRACTION "Ee" EXP_INTEGER
	DECIMAL_FRACTION : DECIMAL DOT_DECIMAL
	DOT_DECIMAL : "." NUMERIC+
	EXP_INTEGER : SIGN? NUMERIC+

	DO_CHAR : (/["\40"-"\41", "\43"-"\133", "\135"-"\176"]/ | "\\\\ \" \\\\")


	SQ_CHAR : (/["\40"-"\46", "\50"-"\133", "\135"-"\176"]/ | "\\\\ ' \\\\")

	SIGN : "+" | "-"
	ZERO_NUMERIC : "0"
	NON_ZERO_NUMERIC : "1" .. "9"
	NUMERIC : "0" .. "9"
	LOWER_ALPHA : "a" .. "z"
	UPPER_ALPHA : "A" .. "Z"
	ALPHA_NUMERIC : LOWER_ALPHA | UPPER_ALPHA | NUMERIC | "_"
	PRINTABLE_CHAR : /["\32"-"\126"]/

	VIEWABLE_CHAR : "\n"

    %import common.WS  
    %ignore WS

    """,
    start="tptp_file",
)
