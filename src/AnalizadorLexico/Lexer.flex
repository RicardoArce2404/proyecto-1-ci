package compilador;

import java_cup.runtime.Symbol;

%%

%class Lexer
%unicode
%cup
%line
%column
%public

// Palabras reservadas
let         = "let"
int         = "int"
float       = "float"
bool        = "bool"
char        = "char"
string      = "string"
for         = "for"
return      = "return"
input       = "input"
output      = "output"
principal   = "principal"
loop        = "loop"
decide      = "decide"
else        = "else"
true        = "true"
false       = "false"

// Identificadores y literales
id          = [a-zA-Z_][a-zA-Z0-9_]*
int_lit     = [0-9]+
float_lit   = [0-9]+"."[0-9]+

// Espacios y saltos de línea
espacio     = [ \t\r\n]+

// Símbolos
sigma       = "Σ"
dollar      = "\\$"
lparen      = "є"
rparen      = "э"
lblock      = "¿"
rblock      = "?"
assign      = "="
plus        = "+"
minus       = "-"
times       = "*"
div         = "/"
mod         = "%"
power       = "^"
and         = "@"
or          = "~"
eq          = "=="
neq         = "!="
gt          = ">"
lt          = "<"
ge          = ">="
le          = "<="
comma       = ","
arrow       = "->"

// Comentarios
comentario_linea = "\\|".*
comentario_multi = "¡"([^!])*"!"

// Ignorar espacios y comentarios
%%

{espacio}                { /* ignorar espacios */ }
{comentario_linea}       { /* ignorar comentarios */ }
{comentario_multi}       { /* ignorar comentarios */ }

// Palabras reservadas
{let}                    { return new Symbol(sym.LET, yyline, yycolumn, yytext()); }
{int}                    { return new Symbol(sym.INT, yyline, yycolumn, yytext()); }
{float}                  { return new Symbol(sym.FLOAT, yyline, yycolumn, yytext()); }
{bool}                   { return new Symbol(sym.BOOL, yyline, yycolumn, yytext()); }
{char}                   { return new Symbol(sym.CHAR, yyline, yycolumn, yytext()); }
{string}                 { return new Symbol(sym.STRING, yyline, yycolumn, yytext()); }
{for}                    { return new Symbol(sym.FOR, yyline, yycolumn, yytext()); }
{return}                 { return new Symbol(sym.RETURN, yyline, yycolumn, yytext()); }
{input}                  { return new Symbol(sym.INPUT, yyline, yycolumn, yytext()); }
{output}                 { return new Symbol(sym.OUTPUT, yyline, yycolumn, yytext()); }
{principal}              { return new Symbol(sym.PRINCIPAL, yyline, yycolumn, yytext()); }
{loop}                   { return new Symbol(sym.LOOP, yyline, yycolumn, yytext()); }
{decide}                 { return new Symbol(sym.DECIDE, yyline, yycolumn, yytext()); }
{else}                   { return new Symbol(sym.ELSE, yyline, yycolumn, yytext()); }
{true}                   { return new Symbol(sym.TRUE, yyline, yycolumn, yytext()); }
{false}                  { return new Symbol(sym.FALSE, yyline, yycolumn, yytext()); }

// Identificadores y literales
{id}                     { return new Symbol(sym.ID, yyline, yycolumn, yytext()); }
{int_lit}                { return new Symbol(sym.INT_LIT, yyline, yycolumn, yytext()); }
{float_lit}              { return new Symbol(sym.FLOAT_LIT, yyline, yycolumn, yytext()); }

// Operadores y símbolos
{sigma}                  { return new Symbol(sym.SIGMA, yyline, yycolumn, yytext()); }
{dollar}                 { return new Symbol(sym.DOLLAR, yyline, yycolumn, yytext()); }
{lparen}                 { return new Symbol(sym.LPAREN, yyline, yycolumn, yytext()); }
{rparen}                 { return new Symbol(sym.RPAREN, yyline, yycolumn, yytext()); }
{lblock}                 { return new Symbol(sym.LBLOCK, yyline, yycolumn, yytext()); }
{rblock}                 { return new Symbol(sym.RBLOCK, yyline, yycolumn, yytext()); }
{assign}                 { return new Symbol(sym.ASSIGN, yyline, yycolumn, yytext()); }
{plus}                   { return new Symbol(sym.PLUS, yyline, yycolumn, yytext()); }
{minus}                  { return new Symbol(sym.MINUS, yyline, yycolumn, yytext()); }
{times}                  { return new Symbol(sym.TIMES, yyline, yycolumn, yytext()); }
{div}                    { return new Symbol(sym.DIV, yyline, yycolumn, yytext()); }
{mod}                    { return new Symbol(sym.MOD, yyline, yycolumn, yytext()); }
{power}                  { return new Symbol(sym.POWER, yyline, yycolumn, yytext()); }
{and}                    { return new Symbol(sym.AND, yyline, yycolumn, yytext()); }
{or}                     { return new Symbol(sym.OR, yyline, yycolumn, yytext()); }
{eq}                     { return new Symbol(sym.EQ, yyline, yycolumn, yytext()); }
{neq}                    { return new Symbol(sym.NEQ, yyline, yycolumn, yytext()); }
{gt}                     { return new Symbol(sym.GT, yyline, yycolumn, yytext()); }
{lt}                     { return new Symbol(sym.LT, yyline, yycolumn, yytext()); }
{ge}                     { return new Symbol(sym.GE, yyline, yycolumn, yytext()); }
{le}                     { return new Symbol(sym.LE, yyline, yycolumn, yytext()); }
{comma}                  { return new Symbol(sym.COMMA, yyline, yycolumn, yytext()); }
{arrow}                  { return new Symbol(sym.ARROW, yyline, yycolumn, yytext()); }

.                        { System.err.println("Símbolo no reconocido: " + yytext() + " en línea " + yyline); }
