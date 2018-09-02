/*
  parser
*/

/* operator associations and precedence */
%nonassoc '='
%left  AND  OR  XOR  NAND  NOR  XNOR
%left BAND BOR BXOR BNAND BNOR BXNOR '<<' '>>'
%nonassoc '==' '!=' '>' '<' '>=' '<='
%left '+' '-'
%left '*' '/' '%'
%left NAME
%right AT NOT BNOT INCR DECR UNPLUS UNMINUS MONAD

%start program

%%

program
    : def funcs EOF { return TAPE.formater.program($1, $2); }
    ;

def
    : DEFINE_8  { $$ =  8; }
    | DEFINE_16 { $$ = 16; }
    ;

funcs
    :
    | funcs func { $$ = TAPE.formater.namedGather($1, $2); }
    ;
func
    : NAME '{' instrs '}' { $$ = new TAPE.node.Function($1  , $3); }
    |      '{' instrs '}' { $$ = new TAPE.node.Function(null, $2); }
    | NAME DO  instrs END { $$ = new TAPE.node.Function($1  , $3); }
    | MAIN     instrs END { $$ = new TAPE.node.Function(null, $2); }
    ;

instrs
    :              { $$ = []; }
    | instrs instr { $$ = TAPE.formater.gather($1, $2); }
    ;
instr
    : var '=' expr '.' { $$ = new TAPE.node.Assign($1, $3); }
    | var '=' text '.' { $$ = new TAPE.node.StringAssign($1, $3); }
    | RETURN  expr '.' { $$ = new TAPE.node.Return($2); }
    | identifier '(' params ')' '.' { $$ = new TAPE.node.Call($1, $3); }
    | identifier     params     '.' { $$ = new TAPE.node.Call($1, $2); }
    | INCR  var  '.' { $$ = new TAPE.node.Increment($2); }
    | DECR  var  '.' { $$ = new TAPE.node.Decrement($2); }
    | WAIT  expr '.' { $$ = new TAPE.node.Action(TAPE.action.wait , $2); }
    | BELL  expr '.' { $$ = new TAPE.node.Action(TAPE.action.bell , $2); }
    | PRINT expr '.' { $$ = new TAPE.node.Action(TAPE.action.print, $2); }
    | IF  expr DO  instrs     elses1 { $$ = TAPE.formater.if_($2, $4, $5); }
    | '?' expr '{' instrs '}' elses2 { $$ = TAPE.formater.if_($2, $4, $6); }
    | WHILE expr DO  instrs END      { $$ = TAPE.formater.loop(true , $2   , $4); }
    |       expr '[' instrs ']'      { $$ = TAPE.formater.loop(false, $1   , $3); }
    | LOOP instrs END                { $$ = TAPE.formater.loop(true , true, $2); }
    | '['  instrs ']'                { $$ = TAPE.formater.loop(false, true, $2); }
    | RETRY { $$ = new TAPE.node.Break(false, true ); }
    | STOP  { $$ = new TAPE.node.Break(true , true ); }
    | '<|'  { $$ = new TAPE.node.Break(false, false); }
    | '|>'  { $$ = new TAPE.node.Break(true , false); }
    ;
elses1
    : END
    | ELSE           instrs END    { $$ = TAPE.formater.else_($2); }
    | ELSEIF expr DO instrs elses1 { $$ = TAPE.formater.elseif($2, $4, $5); }
    ;
elses2
    :
    |      '{' instrs '}'        { $$ = TAPE.formater.else_($2); }
    | expr '{' instrs '}' elses2 { $$ = TAPE.formater.elseif($1, $3, $5); }
    ;
var
    : AT  expr   { $$ = new TAPE.node.Variable(false, $2); }
    | REG number { $$ = new TAPE.node.Variable(true , $2); }
    ;

expr
    : number       { $$ = $1; }
    | var          { $$ = $1; }
    | '(' expr ')' { $$ = $2; }
    | identifier '(' params ')'   { $$ = new TAPE.node.Call($1, $3);   }
    | identifier expr %prec MONAD { $$ = new TAPE.node.Call($1, [$2]); }
    | exprDyad identifier expr    { $$ = formater.callDyadic($2, $1, $3); }
	| NOT  expr              { $$ = new TAPE.node.Monadic(TAPE.op.not_, $2); }
	| BNOT expr              { $$ = new TAPE.node.Monadic(TAPE.op.bnot, $2); }
	| '+' expr %prec UNPLUS  { $$ = new TAPE.node.Monadic(TAPE.op.abs , $2); }
	| '-' expr %prec UNMINUS { $$ = new TAPE.node.Monadic(TAPE.op.neg , $2); }
    | expr '+'   expr { $$ = new TAPE.node.Dyadic(TAPE.op.add   , $1, $3); }
    | expr '-'   expr { $$ = new TAPE.node.Dyadic(TAPE.op.sub   , $1, $3); }
    | expr '*'   expr { $$ = new TAPE.node.Dyadic(TAPE.op.mul   , $1, $3); }
    | expr '/'   expr { $$ = new TAPE.node.Dyadic(TAPE.op.div   , $1, $3); }
    | expr '%'   expr { $$ = new TAPE.node.Dyadic(TAPE.op.mod   , $1, $3); }
    | expr AND   expr { $$ = new TAPE.node.Dyadic(TAPE.op.and_  , $1, $3); }
    | expr OR    expr { $$ = new TAPE.node.Dyadic(TAPE.op.or_   , $1, $3); }
    | expr XOR   expr { $$ = new TAPE.node.Dyadic(TAPE.op.xor   , $1, $3); }
    | expr NAND  expr { $$ = new TAPE.node.Dyadic(TAPE.op.nand  , $1, $3); }
    | expr NOR   expr { $$ = new TAPE.node.Dyadic(TAPE.op.nor   , $1, $3); }
    | expr XNOR  expr { $$ = new TAPE.node.Dyadic(TAPE.op.xnor  , $1, $3); }
    | expr BAND  expr { $$ = new TAPE.node.Dyadic(TAPE.op.band  , $1, $3); }
    | expr BOR   expr { $$ = new TAPE.node.Dyadic(TAPE.op.bor   , $1, $3); }
    | expr BXOR  expr { $$ = new TAPE.node.Dyadic(TAPE.op.bxor  , $1, $3); }
    | expr BNAND expr { $$ = new TAPE.node.Dyadic(TAPE.op.bnand , $1, $3); }
    | expr BNOR  expr { $$ = new TAPE.node.Dyadic(TAPE.op.bnor  , $1, $3); }
    | expr BXNOR expr { $$ = new TAPE.node.Dyadic(TAPE.op.bxnor , $1, $3); }
    | expr '<<'  expr { $$ = new TAPE.node.Dyadic(TAPE.op.lshift, $1, $3); }
    | expr '>>'  expr { $$ = new TAPE.node.Dyadic(TAPE.op.rshift, $1, $3); }
    | expr '=='  expr { $$ = new TAPE.node.Dyadic(TAPE.op.equ   , $1, $3); }
    | expr '!='  expr { $$ = new TAPE.node.Dyadic(TAPE.op.dif   , $1, $3); }
    | expr '>'   expr { $$ = new TAPE.node.Dyadic(TAPE.op.grt   , $1, $3); }
    | expr '<'   expr { $$ = new TAPE.node.Dyadic(TAPE.op.lst   , $1, $3); }
    | expr '>='  expr { $$ = new TAPE.node.Dyadic(TAPE.op.gte   , $1, $3); }
    | expr '<='  expr { $$ = new TAPE.node.Dyadic(TAPE.op.lte   , $1, $3); }
    ;
identifier
    : NAME { $$ = yytext; }
    ;
params
    :         { $$ = []; }
    | params2 { $$ = $1; }
    ;
params2
    :             expr { $$ = TAPE.formater.gather([], $1); }
    | params2 ',' expr { $$ = TAPE.formater.gather($1, $3); }
    ;
exprDyad
    :                     expr { $$ = $1; }
    | exprDyad identifier expr { $$ = TAPE.formater.callDyadicList($2, $1, $3); }
    ;

number
    : DECIMAL     { $$ = TAPE.formater.number('decimal'    , yytext); }
    | BINARY      { $$ = TAPE.formater.number('binary'     , yytext); }
    | OCTAL       { $$ = TAPE.formater.number('octal'      , yytext); }
    | HEXADECIMAL { $$ = TAPE.formater.number('hexadecimal', yytext); }
    | CHARACTER   { $$ = TAPE.formater.number('character'  , yytext); }
    ;
text
    : STRING { $$ = yytext.slice(1, -1); }
    ;
