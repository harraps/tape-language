/* 
    lexical grammar

    postfix tokens by the syntax type:
    1 : WORDS
    2 : ASCII
    3 : SYMBOLS
    4 : EMOJIS

    TODO: add tokenizer for multiline comments and strings:
    #()# ☙❧ 🌜🌛
    "" ❝❞
*/

%lex
%options flex

%%

\s+                {/* skip white space */}
("#"|"❦"|"💭").*  {/* ignore comments  */}

"DEFINE"|"<$>"|"※"|"📯" return 'DEFINE';

"UNSIGNED"|"☏"|"📷" return 'UNSIGNED';
"SIGNED"|"☎"|"📸"   return 'DEFINE';

"BYTE"|"☎"|"💿" return 'BYTE';
"WORD"|"☻"|"📀" return 'WORD';

[0-9]+\b          return 'DECIMAL';
"b"[0-1]+\b       return 'BINARY';
"o"[0-7]+\b       return 'OCTAL';
"x"[0-9a-fA-F]+\b return 'HEXADECIMAL';
"'"."'"           return 'CHARACTER';

"ASSIGN"|":="|"≔"|"✍️" return 'ASSIGN';

"DO"  return 'BEGIN1';
"{"   return 'BEGIN2';
"🔛" return 'BEGIN4';

"END" return 'END1';
"}"   return 'END2';
"•"   return 'END3';
"🔚" return 'END4';

"IF" return 'IF1';
"?"  return 'IF2';
"❔" return 'IF4';

"ELSE"\s*"IF" return 'ELSEIF1';
"❓"          return 'ELSEIF4';

"ELSE" return 'ELSE';

"LOOP" return 'LOOP1';
"♺"   return 'LOOP3';
"🔄"  return 'LOOP4';

"["   return 'LOOPBEGIN';
"]"   return 'LOOPEND';

"STOP"|"\\>"|"⭍"|"🛑" return 'STOP';
"RETRY"|"\\<"          return 'RETRY';

"FLAG"|"|>"|"⚑"|"🚩"       return 'FLAG';
"GO"\s*"TO"|"->"|"➽"|"💨" return 'GOTO';

"WAIT"|"><"|"⧗"|"⏳"     return 'WAIT';
"BELL"|"(*)"|"♫"|"🔔"   return 'BELL';
"DISPLAY"|"$"|"👁"|"👁️" return 'DISPLAY';
"PRINT"|"$$"|"❡"|"👀"   return 'PRINT';

"." return '.';

"AT"|"@"|"★"|"📌" return 'AT';

"ADD"|"+"       return '+';
"SUB"|"-"       return '-';
"MUL"|"*"|"×"   return '*';
"DIV"|"/"|"÷"   return '/';
"MOD"|"%"|"mod" return '%';

"INCR"|"++"|"⭜"|"👍" return 'INCR';
"DECR"|"--"|"⭝"|"👎" return 'DECR';

"NOT"|"!"|"¬"    return 'NOT';
"AND"|"&&"|"∧"   return 'AND';
"OR"|"||"|"∨"    return 'OR';
"XOR"|"^^"|"⊕"  return 'XOR';
"NAND"|"!&"|"⊼"  return 'NAND';
"NOR"|"!|"|"⊽"   return 'NOR';
"XNOR"|"!^"|"≡"  return 'XNOR';

"=="|"=" return '==';
"!="|"≠" return '!=';
">"      return '>';
"<"      return '<';
">="|"≥" return '>=';
"<="|"≤" return '<=';

"~"         return 'BNOT';
"&"         return 'BAND';
"|"         return 'BOR';
"^"         return 'BXOR';
"~&"        return 'BNAND';
"~|"        return 'BNOR';
"~^"        return 'BXNOR';
"<<"|"⏪"  return 'LSHIFT';
">>"|"⏩"  return 'RSHIFT';

"(" return 'LPAR1';
")" return 'RPAR1';
"⟨" return 'LPAR2';
"⟩" return 'RPAR2';

<<EOF>>             return 'EOF';
.                   return 'INVALID';

/lex

/* operator associations and precedence */
%nonassoc '='
%nonassoc '==' '!='
%nonassoc '>' '<' '>=' '<='
%left   AND  OR  XOR  NAND  NOR  XNOR
%left  BAND BOR BXOR BNAND BNOR BXNOR
%left  '+' '-'
%left  '*' '/' '%'
%right AT NOT BNOT INCR DECR UNPLUS UNMINUS

%start program

%%

program 
    : def instrs EOF { return TAPE.formaters._program($1, $2); }
    ;

def
    : DEFINE SIGNED   BYTE '.' { $$ = TAPE.formaters._define( -8); }
    | DEFINE UNSIGNED BYTE '.' { $$ = TAPE.formaters._define(  8); }
    | DEFINE SIGNED   WORD '.' { $$ = TAPE.formaters._define(-16); }
    | DEFINE UNSIGNED WORD '.' { $$ = TAPE.formaters._define( 16); }
    | DEFINE '-' number    '.' { $$ = TAPE.formaters._define(-$3); }
    | DEFINE '+' number    '.' { $$ = TAPE.formaters._define( $3); }
    ;

instrs
    : 
    | instrs instr { $$ = TAPE.formaters._instructions($1, $2); }
    ;

instr 
    : AT expr ASSIGN expr '.' { $$ = new TAPE.types.Assign($2, $4); }
    | INCR AT expr   '.' { $$ = TAPE.formaters._incr(1, $3); }
    | INCR AT expr   '.' { $$ = TAPE.formaters._decr(1, $3); }
    | FLAG    number '.' { $$ = new TAPE.types.Flag($2); }
    | GOTO    expr   '.' { $$ = new TAPE.types.Goto($2); }
    | WAIT    expr   '.' { $$ = new TAPE.actions.WAIT($2, function(){}); }
    | BELL    expr   '.' { $$ = new TAPE.actions.BELL($2, sound);        }
    | DISPLAY expr   '.' { $$ = new TAPE.actions.Print($2);              }
    | PRINT   expr   '.' { $$ = new TAPE.actions.Print($2);              }
    | IF1   expr BEGIN1 instrs      elses1 { $$ = TAPE.formaters._if($2, $4, $5); }
    | IF2   expr BEGIN2 instrs END2 elses2 { $$ = TAPE.formaters._if($2, $4, $6); }
    | IF4   expr BEGIN4 instrs      elses4 { $$ = TAPE.formaters._if($2, $4, $6); }
    | LOOP1 expr BEGIN1 instrs END1  { $$ = new TAPE.types.Loop($2  , $4); }
    | LOOP4 expr BEGIN4 instrs END4  { $$ = new TAPE.types.Loop($2  , $4); }
    | LOOP1 instrs END1              { $$ = new TAPE.types.Loop(null, $2); }
    | LOOP3 instrs END3              { $$ = new TAPE.types.Loop(null, $2); }
    | LOOP4 instrs END4              { $$ = new TAPE.types.Loop(null, $2); }
    |      LOOPBEGIN  instrs LOOPEND { $$ = new TAPE.types.Loop(null, $2); }
    | expr LOOPBEGIN  instrs LOOPEND { $$ = new TAPE.types.Loop($1  , $3); }
    | STOP  { $$ = new TAPE.types.Break(true ); }
    | RETRY { $$ = new TAPE.types.Break(false); }
    ;

elses1 
    : END1
    | ELSE1 instrs END1                 { $$ = TAPE.formaters._else($2); }
    | ELSEIF1 expr BEGIN1 instrs elses1 { $$ = TAPE.formaters._elseif($2, $4, $5); }
    ;
elses2 
    :
    | BEGIN2 instrs END2             { $$ = TAPE.formaters._else($2); }
    | expr BEGIN2 instrs END2 elses2 { $$ = TAPE.formaters._elseif($1, $3, $5); }
    ;
elses4 
    : END4
    | ELSE4 instrs END4                 { $$ = TAPE.formaters._else($2); }
    | ELSEIF4 expr BEGIN4 instrs elses4 { $$ = TAPE.formaters._elseif($2, $4, $5); }
    ;

expr 
    : number { $$ = $1; }
    | AT expr { $$ = new TAPE.types.Monadic(TAPE.op.AT, $2); }
    | LPAR1 expr RPAR1 { $$ = $2; }
    | LPAR2 expr RPAR2 { $$ = $2; }
	| NOT  expr { $$ = new TAPE.types.Monadic(TAPE.op.NOT , $2); }
	| BNOT expr { $$ = new TAPE.types.Monadic(TAPE.op.BNOT, $2); }
    | INCR AT expr { $$ = TAPE.formaters._incr(1, $3);  }
    | DECR AT expr { $$ = TAPE.formaters._decr(1, $3);  }
	| INCR    expr { $$ = TAPE.formaters._incr(0, $2);  }
	| DECR    expr { $$ = TAPE.formaters._decr(0, $2);  }
	| '+' expr %prec UNPLUS  { $$ = new TAPE.types.Monadic(TAPE.op.ABS, $2); }
	| '-' expr %prec UNMINUS { $$ = new TAPE.types.Monadic(TAPE.op.NEG, $2); }
    | expr '+'    expr { $$ = new TAPE.types.Dyadic(TAPE.op.ADD   , $1, $3); }
    | expr '-'    expr { $$ = new TAPE.types.Dyadic(TAPE.op.SUB   , $1, $3); }
    | expr '*'    expr { $$ = new TAPE.types.Dyadic(TAPE.op.MUL   , $1, $3); }
    | expr '/'    expr { $$ = new TAPE.types.Dyadic(TAPE.op.DIV   , $1, $3); }
    | expr '%'    expr { $$ = new TAPE.types.Dyadic(TAPE.op.MOD   , $1, $3); }
    | expr AND    expr { $$ = new TAPE.types.Dyadic(TAPE.op.AND   , $1, $3); }
    | expr OR     expr { $$ = new TAPE.types.Dyadic(TAPE.op.OR    , $1, $3); }
    | expr XOR    expr { $$ = new TAPE.types.Dyadic(TAPE.op.XOR   , $1, $3); }
    | expr NAND   expr { $$ = new TAPE.types.Dyadic(TAPE.op.NAND  , $1, $3); }
    | expr NOR    expr { $$ = new TAPE.types.Dyadic(TAPE.op.NOR   , $1, $3); }
    | expr XNOR   expr { $$ = new TAPE.types.Dyadic(TAPE.op.XNOR  , $1, $3); }
    | expr BAND   expr { $$ = new TAPE.types.Dyadic(TAPE.op.BAND  , $1, $3); }
    | expr BOR    expr { $$ = new TAPE.types.Dyadic(TAPE.op.BOR   , $1, $3); }
    | expr BXOR   expr { $$ = new TAPE.types.Dyadic(TAPE.op.BXOR  , $1, $3); }
    | expr BNAND  expr { $$ = new TAPE.types.Dyadic(TAPE.op.BNAND , $1, $3); }
    | expr BNOR   expr { $$ = new TAPE.types.Dyadic(TAPE.op.BNOR  , $1, $3); }
    | expr BXNOR  expr { $$ = new TAPE.types.Dyadic(TAPE.op.BXNOR , $1, $3); }
    | expr LSHIFT expr { $$ = new TAPE.types.Dyadic(TAPE.op.LSHIFT, $1, $3); }
    | expr RSHIFT expr { $$ = new TAPE.types.Dyadic(TAPE.op.RSHIFT, $1, $3); }
    | expr '=='   expr { $$ = new TAPE.types.Dyadic(TAPE.op.EQU   , $1, $3); }
    | expr '!='   expr { $$ = new TAPE.types.Dyadic(TAPE.op.DIF   , $1, $3); }
    | expr '>'    expr { $$ = new TAPE.types.Dyadic(TAPE.op.GRT   , $1, $3); }
    | expr '<'    expr { $$ = new TAPE.types.Dyadic(TAPE.op.LST   , $1, $3); }
    | expr '>='   expr { $$ = new TAPE.types.Dyadic(TAPE.op.GTE   , $1, $3); }
    | expr '<='   expr { $$ = new TAPE.types.Dyadic(TAPE.op.LTE   , $1, $3); }
    ;

number
    : DECIMAL     { $$ = TAPE.formaters._number('decimal'    , yytext); }
    | BINARY      { $$ = TAPE.formaters._number('binary'     , yytext); }
    | OCTAL       { $$ = TAPE.formaters._number('octal'      , yytext); }
    | HEXADECIMAL { $$ = TAPE.formaters._number('hexadecimal', yytext); }
    | CHARACTER   { $$ = TAPE.formaters._number('character'  , yytext); }
    ;