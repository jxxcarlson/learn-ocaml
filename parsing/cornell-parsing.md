
## Parsing in OCaml

[Link](https://www.cs.cornell.edu/courses/cs3110/2015fa/l/12-interp/rec.html)

[Assignments](https://www.cs.cornell.edu/courses/cs3110/2015fa/)

You could build your own lexer and parser from scratch.  But many languages include
tools for automatically generating lexers and parsers from formal descriptions of the
syntax of a language.  The ancestors of many of those tools are [lex][lex] and [yacc][yacc],
which generate lexers and parsers, respectively; lex and yacc were developed in the 1970s 
for C.  As part of the standard distribution, OCaml provides lexer and parser generators 
named [ocamllex and ocamlyacc][ocamllexyacc].  There is a more modern parser generator
named [menhir][menhir] available through opam; menhir is "90% compatible" with ocamlyacc
and provides significantly improved support for debugging generated parsers. 
[Chapter 16 of RWO][rwo16] has a tutorial on ocamllex and menhir.

[lex]: https://en.wikipedia.org/wiki/Lex_(software)
[yacc]: https://en.wikipedia.org/wiki/Yacc
[ocamllexyacc]: http://caml.inria.fr/pub/docs/manual-ocaml/lexyacc.html
[menhir]: http://gallium.inria.fr/~fpottier/menhir/
[rwo16]: https://realworldocaml.org/v1/en/html/parsing-with-ocamllex-and-menhir.html

To get started, install menhir on the VM:
```
$ opam install menhir
```

## Part 1:  Explore the base code

We provide some [base code][basecode] for this lab. 
Download it to the VM. The base code completes the
*substitution-model* interpreter we wrote in lecture by adding
parsing and lexing.  Recall, the language that interpreter
implements is a simple arithmetic expression language with
integers, addition, and let expressions.  The Backus-Naur Form
(BNF) description of that language is as follows:

```
e ::= x                 (* variables *)
    | i                 (* integers *)
    | e1 + e2           (* addition *)
    | let x = e1 in e2  (* let expressions *)
```

[basecode]: rec-code.zip

You'll find six files in the base code archive:

* `ast.ml`: The variant type for the abstract syntax tree (AST) of the expression language.
   
   **Exercise:** Open and read that file now to remind yourself how the AST is defined.
   
* `main.ml`: The interpreter for the expression language.  The first three functions in
   this file, `subst`, `step`, and `multistep` should be familiar.  
   
   **Exercise:** Re-read those three functions now
   to remind yourself how the *small-step semantics* works:  `step` causes an expression 
   to take a single, small step of execution, and `multistep` takes as many steps
   as possible.  
   
   The remaining functions in the file are new; we'll discuss them below.
   
* `parser.mly`:  The input file to menhir.  It describes the syntax of the expression
   language; we'll discuss it below.
   
* `lexer.mll`:  The input file to ocamllex.  It describes the tokens of the expression
   language; we'll discuss it below.
   
* `test.ml`:  A convenient OCaml script to load all the interpreter into utop and
   run the unit tests.
   
* `.ocamlinit`:  An initialization file to cause utop to use `test.ml` automatically.

### Compiling and running

To compile the interpreter, run the following command:

```
$ ocamlbuild -use-menhir main.byte
```

(The `cs3110` tool is actually a thin wrapper around `ocamlbuild`, which itself
does the real work.  We directly use `ocamlbuild` here because `cs3110` has not
yet been upgraded to work with menhir.)

To experiment with the interpreter interactively, launch utop.  Because of the
`.ocamlinit` and `test.ml` files we provided, there are already two functions
available for your use:

```
(* [parse s] is the AST corresponding to the concrete syntax of expression [s]. *)
val parse : string -> expr

(* [interp s] parses the string [s] into an AST, interprets the AST, and yields
   the resulting integer value. *)
val interp : string -> int
```

**Exercise:** Evaluate the following expressions in utop.  Note what each returns.

* `parse "22"`
* `interp "22"`
* `parse "1+2+3"`
* `interp "1+2+3"`
* `parse "let x = 2 in 20+x"`
* `interp "let x = 2 in 20+x"`

Also evaluate these expressions, which will raise exceptions.  Explain why
each one is an error, and whether the error occurs during parsing or during
evaluation.

* `interp "3.14"`
* `interp "(let x = 2 in 20)+x"`

### The parser

Read the `parse` function in `main.ml`:

```
(* Parse a string into an ast *)
let parse s =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
  ast
```

This function takes a string `s` and uses the standard
library's `Lexing` module to create a *lexer buffer* from
it. Think of that buffer as the token stream that we
discussed in lecture. The function then lexes and parses the
string into an AST, using `Lexer.read` and `Parser.prog`. 
The `Lexer` and `Parser` modules are code that is generated
automatically during the compilation process by ocamllex and
menhir:

* ocamllex produces `lexer.ml` from input file `lexer.mll`.
* menhir produces `parser.ml` from input file `parser.mly`.

**Exercise:** Read the `parser.mly` file.  That file gives a
*grammar definition* for the expression language.  Read the comments
in the file carefully.

**Exercise:** Compare the `expr` rule in `parser.mly` to the BNF given
above for the expression language.  How are they the same?  How are
they different?  

**Exercise:** Open `_build/parser.ml`, which is the module generated
automatically by menhir from `parser.mly`.  Skim through the file to
appreciate not having to write it yourself.

### The lexer

**Exercise:** Read the `lexer.mll` file.  That file gives a *lexer definition*
for the expression language.  Read the comments in the file carefully.

**Exercise:** Examine the definition of the `id` regular expression.
Identify at least one way in which it differs from the definition of
OCaml identifiers.

**Exercise:** Open `_build/lexer.ml`, which is the module generated
automatically by ocamllex from `lexer.mll`.  Skim through the file to
appreciate not having to write it yourself.

## Part 2:  Multiplication

In this part of the lab, we'll add multiplication to the expression language.
The new BNF is as follows:

```
e ::= x                 (* variables *)
    | i                 (* integers *)
    | e1 + e2           (* addition *)
    | e1 * e2           (* multiplication *)
    | let x = e1 in e2  (* let expressions *)
```

**Exercise:** Follow the next five steps to add multiplication to your interpreter.

**Step 1 (AST):**  Add the following line to the definition of the `expr` 
type in `ast.ml`:

```
| Mult of expr*expr
```

Recompile the code.  You should get two compiler warnings about inexhaustive
pattern matching.  The compiler is telling you that the implementations
of `subst` and `step` are now incomplete, because they don't handle the 
new AST node.

**Step 2 (Evaluation):**

Add the following line to the definition of `subst` in `main.ml`:

```
| Mult(el,er) -> Mult(subst el e2 x, subst er e2 x)
```

Add the following lines to the definition of `step` in `main.ml`:

```
| Mult(Int n1, Int n2) -> Int (n1*n2)  
| Mult(Int n1, e2) -> Mult(Int n1, step e2)  
| Mult(e1,e2) -> Mult(step e1, e2)
```

Recompile the code.  You should no longer get any compiler warnings.
The evaluation part of your interpreter is finished, but you stil need to 
extend the parser to handle multiplication.

**Step 3 (Parsing):**

Add the following line to the declarations section of `parser.mly`:

```
%token TIMES
```

Add the following line to the precedence and associativity section of `parser.mly`:

```
%left TIMES
```

It must be the next line after `PLUS` in that section.  That's because multiplication
has higher precedence than addition&mdash;i.e., `1+2*3` should be parsed as
`1+(2*3)`, not as `(1+2)*3`.

Add the following production to the `expr` rule:

```
| e1 = expr; TIMES; e2 = expr { Mult(e1,e2) } 
```

Recompile the code.  You should not receive any errors or warnings.

**Step 4 (Lexing):**

Add the following line to the `read` rule in `lexer.mll`:

``` 
| "*" { TIMES }
```

Recompile the code.  You should not receive any errors or warnings.

**Step 5 (Testing):**

Add the following lines to `run_tests` in `main.ml`:

```
  assert (22 = interp "2*11");
  assert (22 = interp "2+2*10");
  assert (14 = interp "2*2+10");
  assert (40 = interp "2*2*10")
```

Don't forget to insert a semicolon at the end of what was previously the last
test case.  Recompile the code.  Load utop and evaluate `run_tests()`.  You should 
not receive any assertion failures.

You've successfully added multiplication to the interpreter!

**Exercise:** You declared the `TIMES` token as having higher precedence than `PLUS`,
and as being left associative.  Let's experiment with other choices.

* Evaluate `parse "1*2*3"` with your current interpreter.  Note the AST.
  Now change the declaration of the associativity of `TIMES` in `parser.mly` to be 
  `%right` instead of `%left`.  Recompile and reevaluate `parse "1*2*3"`.  How did
  the AST change?  Before moving on, restore the declaration to be `%left`.
  
* Evaluate `parse "1+2*3"` with your current interpreter.  Note the AST.
  Now swap the declaration `%left TIMES` in `parser.mly` with the declaration
  `%left PLUS`.  Recompile and reevaluate `parse "1+2*3"`.  How did
  the AST change?  Before moving on, restore the original declaration order.
  
## *Part 3:  If expressions

In this starred part of the lab, we'll add `if` expressions, Booleans, and a comparison
operator to the expression language.
The new BNF is as follows:

```
e ::= x                      (* variables *)
    | i                      (* integers *)
    | b                      (* Booleans *)
    | e1 + e2                (* addition *)
    | e1 * e2                (* multiplication *)
    | e1 <= e2               (* less than or equal *)
    | let x = e1 in e2       (* let expressions *)
    | if e1 then e2 else e3  (* if expressions *)
```

**Exercise:** Follow the next five steps to extend your interpreter.
The instructions are deliberately less precise than in the previous part of
the lab.  

**Step 1 (AST):**  Extend your AST type to include three new
kinds of nodes: Boolean values, the `<=` operator, and `if`
expressions.   Also add the following definition to `ast.ml`:

```
type value =
  | VInt of int
  | VBool of bool
```

We will need this definition in the next step, because there is now more than one
type of value in the language.

**Step 2 (Evaluation):**  Add code to the definitions of `subst`
and `step` to handle the three new kinds of AST nodes.  To handle
Boolean values, change `extract_value` as follows:

```
let extract_value = function
  | Int i -> VInt i
  | Bool b -> VBool b  (* NEW *)
  | _ -> failwith "Not a value"
```

**Step 3 (Parsing):**

Declare six new tokens in `parser.mly`:  `TRUE`, `FALSE`, `LEQ`, `IF`, `THEN`, and `ELSE`.
Change the precedence and associativity section to declare `ELSE` as nonassociative.
The precedence from least to greatest should be `IN`, `ELSE`, `LEQ`, `PLUS`, `TIMES`.
You can see that OCaml uses a similar precedence and associativity by looking at the
table [immediately above section 6.7.1 of the OCaml manual][man-6.7.1].

[man-6.7.1]: http://caml.inria.fr/pub/docs/manual-ocaml/expr.html#sec116

**Step 4 (Lexing):**

Add six new lines to `lexer.mll` for the six new tokens.  Make sure they all appear
before the line that lexes `ID`, otherwise the five new keywords (`true`, `false`,
`if`, `then`, and `else`) would be considered identifiers rather than keywords.

**Step 5 (Testing):**

Modify the existing test cases in `main.ml` to expect `VInt`.  Add new test cases
for the extended language.  Here are some suggestions:

```
  assert (VInt 22 = interp "if true then 22 else 0");
  assert (VBool true = interp "true");
  assert (VBool true = interp "1<=1");
  assert (VInt 22 = interp "if 1+2 <= 3+4 then 22 else 0");
  assert (VInt 22 = interp "if 1+2 <= 3*4 then let x = 22 in x else 0");
  assert (VInt 22 = interp "let x = 1+2 <= 3*4 in if x then 22 else 0")  
```

**Exercise:** You now have three binary operators in the language.  The
code implementing them in `subst` and `step` is highly repetetive. 
Fix that inelegance by having a single AST node, `Binop`, that unifies
all three.  You might need to introduce some additional types or functions.

**Question:** You could now write a new kind of nonsensical expression
in the language, e.g., `true + 22`.  There would be no meaningful way to evaluate
that at runtime.  How could you prevent such errors?  

**Answer:** See the next lecture...
