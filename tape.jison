/* 
    lexical grammar

    postfix tokens by the syntax type:
    1 : WORDS
    2 : ASCII
    3 : SYMBOLS
*/

%lex
%options flex

%%

\s+           {/* skip white space */}
("#"|"❦").*  {/* ignore comments  */}
"#(".*")#"    {/* ignore comments  */}
"☙".*"❧"    {/* ignore comments  */}

"use"\s*"8"\s*"bits"|"[8]"   return 'DEFINE_8';
"use"\s*"16"\s*"bits"|"[16]" return 'DEFINE_16';

[A-Za-z_][A-Za-z0-9_]*\b return 'NAME';
[0-9]+\b                 return 'DECIMAL';
"0b"[0-1]+\b             return 'BINARY';
"0o"[0-7]+\b             return 'OCTAL';
"0x"[0-9a-fA-F]+\b       return 'HEXADECIMAL';
"'"."'"                  return 'CHARACTER';

"\"".*"\"" return 'STRING';
"❝".*"❞"   return 'STRING';

"(" return '(';
")" return ')';
"," return ',';

"main"        return 'MAIN';
"return"|"*>" return 'RETURN';

"do"  return 'DO';
"end" return 'END';

"if"          return 'IF';
"else"\s*"if" return 'ELSEIF';
"else"        return 'ELSE';
"?"           return '?';
"{"           return '{';
"}"           return '}';

"while" return 'WHILE';
"loop"  return 'LOOP';
"retry" return 'RETRY';
"stop"  return 'STOP';
"["     return '[';
"]"     return ']';
"<|"    return '<|';
"|>"    return '|>';

"=" return '=';
"." return '.';

"wait"|"(%)"|"⧗"   return 'WAIT';
"bell"|"(*)"|"♫"   return 'BELL';
"print"|"(&)"|"❡"  return 'PRINT';

"at"|"@"  return 'AT';
"reg"|"$" return 'REG';

"+"       return '+';
"-"       return '-';
"*"|"×"   return '*';
"/"|"÷"   return '/';
"%"|"mod" return '%';

"++"|"⭜" return 'INCR';
"--"|"⭝" return 'DECR';

"not"|"!"|"¬"    return 'NOT';
"and"|"&&"|"∧"   return 'AND';
"or"|"||"|"∨"    return 'OR';
"xor"|"^^"|"⊕"  return 'XOR';
"nand"|"!&"|"⊼"  return 'NAND';
"nor"|"!|"|"⊽"   return 'NOR';
"xnor"|"!^"|"≡"  return 'XNOR';

"==" return '==';
"!=" return '!=';
">"  return '>';
"<"  return '<';
">=" return '>=';
"<=" return '<=';

"~"  return 'BNOT';
"&"  return 'BAND';
"|"  return 'BOR';
"^"  return 'BXOR';
"~&" return 'BNAND';
"~|" return 'BNOR';
"~^" return 'BXNOR';
"<<" return '<<';
">>" return '>>';

<<EOF>> return 'EOF';
.       return 'INVALID';

/lex

/* operator associations and precedence */
%nonassoc '='
%nonassoc '==' '!='
%nonassoc '>' '<' '>=' '<='
%left   AND  OR  XOR  NAND  NOR  XNOR
%left  BAND BOR BXOR BNAND BNOR BXNOR '<<' '>>'
%left  '+' '-'
%left  '*' '/' '%'
%right AT NOT BNOT INCR DECR UNPLUS UNMINUS

%start program

%%

program 
    : def funcs EOF { return TAPE.formaters._program($1, $2); }
    ;

def
    : DEFINE_8  { $$ =  8; }
    | DEFINE_16 { $$ = 16; }
    ;

funcs
    : 
    | funcs func { $$ = TAPE.formaters._functions($1, $2); }
    ;
func
    : NAME "(" instrs ")" { $$ = new TAPE.types.Function($1  , $3); }
    |      "(" instrs ")" { $$ = new TAPE.types.Function(null, $2); }
    | NAME DO  instrs END { $$ = new TAPE.types.Function($1  , $3); }
    | MAIN     instrs END { $$ = new TAPE.types.Function(null, $2); }      
    ;

instrs
    : 
    | instrs instr { $$ = TAPE.formaters._instructions($1, $2); }
    ;
instr 
    : expr '.' { $$ = $1; }
    | var ASSIGN expr '.' { $$ = new TAPE.types.Assign(false, $1, $3); }
    | RETURN     expr '.' { $$ = new TAPE.types.Return($2); }
    | INCR  var  '.' { $$ = new TAPE.types.Increment($2); }
    | DECR  var  '.' { $$ = new TAPE.types.Decrement($2); }
    | WAIT  expr '.' { $$ = new TAPE.types.Action(TAPE.actions.WAIT , $2); }
    | BELL  expr '.' { $$ = new TAPE.types.Action(TAPE.actions.BELL , $2); }
    | PRINT expr '.' { $$ = new TAPE.types.Action(TAPE.actions.PRINT, $2); }
    | IF  expr DO  instrs     elses1 { $$ = TAPE.formaters._if($2, $4, $5); }
    | "?" expr "{" instrs "}" elses2 { $$ = TAPE.formaters._if($2, $4, $6); }
    | WHILE expr DO  instrs END      { $$ = TAPE.formaters._loop(true , $2  , $4); }
    |       expr "[" instrs "]"      { $$ = TAPE.formaters._loop(false, $2  , $4); }
    | LOOP instrs END                { $$ = TAPE.formaters._loop(true , null, $2); }
    | "["  instrs "]"                { $$ = TAPE.formaters._loop(false, null, $2); }
    | RETRY { $$ = new TAPE.types.Break(false, true ); }
    | STOP  { $$ = new TAPE.types.Break(true , true ); }
    | "<|"  { $$ = new TAPE.types.Break(false, false); }
    | "|>"  { $$ = new TAPE.types.Break(true , false); }
    ;
elses1 
    : END
    | ELSE           instrs END    { $$ = TAPE.formaters._else($2); }
    | ELSEIF expr DO instrs elses1 { $$ = TAPE.formaters._elseif($2, $4, $5); }
    ;
elses2 
    :
    |      "{" instrs "}"        { $$ = TAPE.formaters._else($2); }
    | expr "{" instrs "}" elses2 { $$ = TAPE.formaters._elseif($1, $3, $5); }
    ;
var
    : AT  expr   { $$ = new TAPE.types.Variable(false, $2); }
    | REG number { $$ = new TAPE.types.Variable(true , $2); }
    ;

expr 
    : number       { $$ = $1; }
    | var          { $$ = $1; }
    | "(" expr ")" { $$ = $2; }
    | NAME "(" params ")"    { $$ = new TAPE.types.Call($1, $3); }
	| NOT  expr              { $$ = new TAPE.types.Monadic(TAPE.op.NOT , $2); }
	| BNOT expr              { $$ = new TAPE.types.Monadic(TAPE.op.BNOT, $2); }
	| '+' expr %prec UNPLUS  { $$ = new TAPE.types.Monadic(TAPE.op.ABS, $2); }
	| '-' expr %prec UNMINUS { $$ = new TAPE.types.Monadic(TAPE.op.NEG, $2); }
    | expr '+'   expr { $$ = new TAPE.types.Dyadic(TAPE.op.ADD   , $1, $3); }
    | expr '-'   expr { $$ = new TAPE.types.Dyadic(TAPE.op.SUB   , $1, $3); }
    | expr '*'   expr { $$ = new TAPE.types.Dyadic(TAPE.op.MUL   , $1, $3); }
    | expr '/'   expr { $$ = new TAPE.types.Dyadic(TAPE.op.DIV   , $1, $3); }
    | expr '%'   expr { $$ = new TAPE.types.Dyadic(TAPE.op.MOD   , $1, $3); }
    | expr AND   expr { $$ = new TAPE.types.Dyadic(TAPE.op.AND   , $1, $3); }
    | expr OR    expr { $$ = new TAPE.types.Dyadic(TAPE.op.OR    , $1, $3); }
    | expr XOR   expr { $$ = new TAPE.types.Dyadic(TAPE.op.XOR   , $1, $3); }
    | expr NAND  expr { $$ = new TAPE.types.Dyadic(TAPE.op.NAND  , $1, $3); }
    | expr NOR   expr { $$ = new TAPE.types.Dyadic(TAPE.op.NOR   , $1, $3); }
    | expr XNOR  expr { $$ = new TAPE.types.Dyadic(TAPE.op.XNOR  , $1, $3); }
    | expr BAND  expr { $$ = new TAPE.types.Dyadic(TAPE.op.BAND  , $1, $3); }
    | expr BOR   expr { $$ = new TAPE.types.Dyadic(TAPE.op.BOR   , $1, $3); }
    | expr BXOR  expr { $$ = new TAPE.types.Dyadic(TAPE.op.BXOR  , $1, $3); }
    | expr BNAND expr { $$ = new TAPE.types.Dyadic(TAPE.op.BNAND , $1, $3); }
    | expr BNOR  expr { $$ = new TAPE.types.Dyadic(TAPE.op.BNOR  , $1, $3); }
    | expr BXNOR expr { $$ = new TAPE.types.Dyadic(TAPE.op.BXNOR , $1, $3); }
    | expr '<<'  expr { $$ = new TAPE.types.Dyadic(TAPE.op.LSHIFT, $1, $3); }
    | expr '>>'  expr { $$ = new TAPE.types.Dyadic(TAPE.op.RSHIFT, $1, $3); }
    | expr '=='  expr { $$ = new TAPE.types.Dyadic(TAPE.op.EQU   , $1, $3); }
    | expr '!='  expr { $$ = new TAPE.types.Dyadic(TAPE.op.DIF   , $1, $3); }
    | expr '>'   expr { $$ = new TAPE.types.Dyadic(TAPE.op.GRT   , $1, $3); }
    | expr '<'   expr { $$ = new TAPE.types.Dyadic(TAPE.op.LST   , $1, $3); }
    | expr '>='  expr { $$ = new TAPE.types.Dyadic(TAPE.op.GTE   , $1, $3); }
    | expr '<='  expr { $$ = new TAPE.types.Dyadic(TAPE.op.LTE   , $1, $3); }
    ;

number
    : DECIMAL     { $$ = TAPE.formaters._number('decimal'    , yytext); }
    | BINARY      { $$ = TAPE.formaters._number('binary'     , yytext); }
    | OCTAL       { $$ = TAPE.formaters._number('octal'      , yytext); }
    | HEXADECIMAL { $$ = TAPE.formaters._number('hexadecimal', yytext); }
    | CHARACTER   { $$ = TAPE.formaters._number('character'  , yytext); }
    ;