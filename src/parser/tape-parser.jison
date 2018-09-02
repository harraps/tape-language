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
    : var    '=' expr '.' { $$ = new TAPE.node.Assign      ($1, $3);     }
    | var    '=' text '.' { $$ = new TAPE.node.StringAssign($1, $3);     }
	| var op '=' expr '.' { $$ = new TAPE.node.SelfAssign  ($1, $4, $2); }
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
    | WHILE expr DO  instrs END      { $$ = TAPE.formater.loop(true , $2  , $4); }
    |       expr '[' instrs ']'      { $$ = TAPE.formater.loop(false, $1  , $3); }
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
	| expr op   expr { $$ = new TAPE.node.Dyadic($2, $1, $3); }
	| expr comp expr { $$ = new TAPE.node.Dyadic($2, $1, $3); }
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
comp
	: '=='  { $$ = TAPE.op.equ; }
	| '!='  { $$ = TAPE.op.dif; }
	| '>'   { $$ = TAPE.op.grt; }
	| '<'   { $$ = TAPE.op.lst; }
	| '>='  { $$ = TAPE.op.gte; }
	| '<='  { $$ = TAPE.op.lte; }
	;
op
	: '+'   { $$ = TAPE.op.add   ; }
    | '-'   { $$ = TAPE.op.sub   ; }
    | '*'   { $$ = TAPE.op.mul   ; }
    | '/'   { $$ = TAPE.op.div   ; }
    | '%'   { $$ = TAPE.op.mod   ; }
    | AND   { $$ = TAPE.op.and_  ; }
    | OR    { $$ = TAPE.op.or_   ; }
    | XOR   { $$ = TAPE.op.xor   ; }
    | NAND  { $$ = TAPE.op.nand  ; }
    | NOR   { $$ = TAPE.op.nor   ; }
    | XNOR  { $$ = TAPE.op.xnor  ; }
    | BAND  { $$ = TAPE.op.band  ; }
    | BOR   { $$ = TAPE.op.bor   ; }
    | BXOR  { $$ = TAPE.op.bxor  ; }
    | BNAND { $$ = TAPE.op.bnand ; }
    | BNOR  { $$ = TAPE.op.bnor  ; }
    | BXNOR { $$ = TAPE.op.bxnor ; }
    | '<<'  { $$ = TAPE.op.lshift; }
    | '>>'  { $$ = TAPE.op.rshift; }
	;
