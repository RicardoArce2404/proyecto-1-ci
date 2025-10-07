import java_cup.runtime.Symbol;

%%

%class Lexer
%unicode
%cup
%line
%column
%public
%state STRING

%{
    StringBuffer string_lit = new StringBuffer();
    private TablaSimbolos tablaSimbolos;
    private ManejadorErrores manejadorErrores;
    
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
    
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
    
    public void setTablaSimbolos(TablaSimbolos tabla) {
        this.tablaSimbolos = tabla;
    }
    
    public void setManejadorErrores(ManejadorErrores manejador) {
        this.manejadorErrores = manejador;
    }
    
    private boolean esPalabraReservada(String texto) {
        return texto.equals("let") || texto.equals("int") || texto.equals("float") || 
               texto.equals("bool") || texto.equals("char") || texto.equals("string") ||
               texto.equals("for") || texto.equals("return") || texto.equals("input") ||
               texto.equals("output") || texto.equals("principal") || texto.equals("loop") ||
               texto.equals("decide") || texto.equals("else") || texto.equals("true") ||
               texto.equals("false") || texto.equals("void") || texto.equals("of") ||
               texto.equals("end") || texto.equals("exit") || texto.equals("when") ||
               texto.equals("step") || texto.equals("to") || texto.equals("downto") ||
               texto.equals("do");
    }
%}

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
void        = "void"
of          = "of"
end         = "end"
exit        = "exit"
when        = "when"
step        = "step"
to          = "to"
downto      = "downto"
do          = "do"

// Identificadores y literales
id        = [a-zA-Z_][a-zA-Z0-9_]*
int_lit   = [1-9][0-9]*|0
float_lit = ([0-9]+"."[0-9]*)|([0-9]*"."[0-9]+)
char_lit  = \'([^'\\]|\\[nrt'\\])\'

// Espacios y saltos de línea
espacio     = [ \t\r\n]+

// Símbolos
sigma       = "Σ"
dollar      = "$"
lparen      = \u0454 // є
rparen      = \u044d // э
lblock      = "¿"
rblock      = "?"
assign      = "="
plus        = "+"
minus       = "-"
mult        = "*"
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
lbracket    = "["
rbracket    = "]"
divint      = "//"
inc         = "++"
dec         = "--"

// Comentarios
comentario_linea = "|".*
comentario_multi = "¡"([^!])*"!"

%%

<YYINITIAL> {
    // Ignorar espacios y comentarios
    {espacio}          { /* ignorar espacios */ }
    {comentario_linea} { /* ignorar comentarios */ }
    {comentario_multi} { /* ignorar comentarios */ }

    // Palabras reservadas
    {let}       { return new Symbol(sym.LET, yyline, yycolumn, yytext()); }
    {float}     { return new Symbol(sym.FLOAT, yyline, yycolumn, yytext()); }
    {int}       { return new Symbol(sym.INT, yyline, yycolumn, yytext()); }
    {bool}      { return new Symbol(sym.BOOL, yyline, yycolumn, yytext()); }
    {char}      { return new Symbol(sym.CHAR, yyline, yycolumn, yytext()); }
    {string}    { return new Symbol(sym.STRING, yyline, yycolumn, yytext()); }
    {for}       { return new Symbol(sym.FOR, yyline, yycolumn, yytext()); }
    {return}    { return new Symbol(sym.RETURN, yyline, yycolumn, yytext()); }
    {input}     { return new Symbol(sym.INPUT, yyline, yycolumn, yytext()); }
    {output}    { return new Symbol(sym.OUTPUT, yyline, yycolumn, yytext()); }
    {principal} { return new Symbol(sym.PRINCIPAL, yyline, yycolumn, yytext()); }
    {loop}      { return new Symbol(sym.LOOP, yyline, yycolumn, yytext()); }
    {decide}    { return new Symbol(sym.DECIDE, yyline, yycolumn, yytext()); }
    {else}      { return new Symbol(sym.ELSE, yyline, yycolumn, yytext()); }
    {true}      { 
        if (tablaSimbolos != null) tablaSimbolos.agregarSimbolo("true_literal", "bool", "literal", yyline + 1, "true");
        return new Symbol(sym.TRUE, yyline, yycolumn, yytext()); 
    }
    {false}     { 
        if (tablaSimbolos != null) tablaSimbolos.agregarSimbolo("false_literal", "bool", "literal", yyline + 1, "false");
        return new Symbol(sym.FALSE, yyline, yycolumn, yytext()); 
    }
    {void}      { return new Symbol(sym.VOID, yyline, yycolumn, yytext()); }
    {of}        { return new Symbol(sym.OF, yyline, yycolumn, yytext()); }
    {end}       { return new Symbol(sym.END, yyline, yycolumn, yytext()); }
    {exit}      { return new Symbol(sym.EXIT, yyline, yycolumn, yytext()); }
    {when}      { return new Symbol(sym.WHEN, yyline, yycolumn, yytext()); }
    {step}      { return new Symbol(sym.STEP, yyline, yycolumn, yytext()); }
    {to}        { return new Symbol(sym.TO, yyline, yycolumn, yytext()); }
    {downto}    { return new Symbol(sym.DOWNTO, yyline, yycolumn, yytext()); }
    {do}        { return new Symbol(sym.DO, yyline, yycolumn, yytext()); }

    // Identificadores y literales
    \"          { string_lit.setLength(0); yybegin(STRING); }
    {id}        { 
        if (tablaSimbolos != null && !esPalabraReservada(yytext())) {
            tablaSimbolos.agregarSimbolo(yytext(), "por determinar", "identificador", yyline + 1);
        }
        return new Symbol(sym.ID, yyline, yycolumn, yytext()); 
    }
    {int_lit}   { 
        if (tablaSimbolos != null) {
            tablaSimbolos.agregarSimbolo("int_" + yytext(), "int", "literal", yyline + 1, yytext());
        }
        return new Symbol(sym.INT_LIT, yyline, yycolumn, yytext()); 
    }
    {float_lit} { 
        if (tablaSimbolos != null) {
            tablaSimbolos.agregarSimbolo("float_" + yytext(), "float", "literal", yyline + 1, yytext());
        }
        return new Symbol(sym.FLOAT_LIT, yyline, yycolumn, yytext()); 
    }
    {char_lit} { 
        String valor = yytext().substring(1, yytext().length()-1);
        if (tablaSimbolos != null) {
            tablaSimbolos.agregarSimbolo("char_" + valor, "char", "literal", yyline + 1, "'" + valor + "'");
        }
        return new Symbol(sym.CHAR_LIT, yyline, yycolumn, valor); 
    }

    // Operadores y símbolos
    {inc}       { return new Symbol(sym.INC, yyline, yycolumn, yytext()); }
    {dec}       { return new Symbol(sym.DEC, yyline, yycolumn, yytext()); }
    {sigma}     { return new Symbol(sym.SIGMA, yyline, yycolumn, yytext()); }
    {dollar}    { return new Symbol(sym.DOLLAR, yyline, yycolumn, yytext()); }
    {lparen}    { return new Symbol(sym.LPAREN, yyline, yycolumn, yytext()); }
    {rparen}    { return new Symbol(sym.RPAREN, yyline, yycolumn, yytext()); }
    {lblock}    { return new Symbol(sym.LBLOCK, yyline, yycolumn, yytext()); }
    {rblock}    { return new Symbol(sym.RBLOCK, yyline, yycolumn, yytext()); }
    {assign}    { return new Symbol(sym.ASSIGN, yyline, yycolumn, yytext()); }
    {plus}      { return new Symbol(sym.PLUS, yyline, yycolumn, yytext()); }
    {minus}     { return new Symbol(sym.MINUS, yyline, yycolumn, yytext()); }
    {mult}      { return new Symbol(sym.MULT, yyline, yycolumn, yytext()); }
    {div}       { return new Symbol(sym.DIV, yyline, yycolumn, yytext()); }
    {mod}       { return new Symbol(sym.MOD, yyline, yycolumn, yytext()); }
    {power}     { return new Symbol(sym.POW, yyline, yycolumn, yytext()); }
    {and}       { return new Symbol(sym.AND, yyline, yycolumn, yytext()); }
    {or}        { return new Symbol(sym.OR, yyline, yycolumn, yytext()); }
    {eq}        { return new Symbol(sym.EQ, yyline, yycolumn, yytext()); }
    {neq}       { return new Symbol(sym.NEQ, yyline, yycolumn, yytext()); }
    {gt}        { return new Symbol(sym.GT, yyline, yycolumn, yytext()); }
    {lt}        { return new Symbol(sym.LT, yyline, yycolumn, yytext()); }
    {ge}        { return new Symbol(sym.GE, yyline, yycolumn, yytext()); }
    {le}        { return new Symbol(sym.LE, yyline, yycolumn, yytext()); }
    {comma}     { return new Symbol(sym.COMMA, yyline, yycolumn, yytext()); }
    {arrow}     { return new Symbol(sym.ARROW, yyline, yycolumn, yytext()); }
    {lbracket}  { return new Symbol(sym.LBRACKET, yyline, yycolumn, yytext()); }
    {rbracket}  { return new Symbol(sym.RBRACKET, yyline, yycolumn, yytext()); }
    {divint}    { return new Symbol(sym.DIVINT, yyline, yycolumn, yytext()); }

} // aquí termina todo lo del estado YYINITIAL.

<STRING> {
    \"           { 
        yybegin(YYINITIAL); 
        String valor = string_lit.toString();
        if (tablaSimbolos != null) {
            tablaSimbolos.agregarSimbolo("string_literal", "string", "literal", yyline + 1, "\"" + valor + "\"");
        }
        return symbol(sym.STRING_LIT, valor); 
    }
    [^\n\r\"\\]+ { string_lit.append( yytext() ); }
    \\t          { string_lit.append('\t'); }
    \\n          { string_lit.append('\n'); }
    \\r          { string_lit.append('\r'); }
    \\\"         { string_lit.append('\"'); }
    \\           { string_lit.append('\\'); }
}

// Manejo de errores léxicos
. { 
    String errorMsg = "Carácter no válido: '" + yytext() + "'";
    if (manejadorErrores != null) {
        manejadorErrores.agregarErrorLexico(errorMsg, yyline, yycolumn);
    } else {
        System.err.println("ERROR LÉXICO [Línea " + (yyline + 1) + ", Columna " + (yycolumn + 1) + "]: " + errorMsg);
    }
}