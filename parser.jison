/* operator associations and precedence */
%nonassoc '='
%nonassoc '==' '!='
%nonassoc '>' '<' '>=' '<='
%left  '&&' '||' '^^' '!&&' '!||' '!^^'
%left  '+' '-'
%left  '*' '/' '%'
%left  '&' '|' '^' '~&' '~|' '~^' '<<' '>>'
%right AT '!' '~' '++' '--' unplus unminus

%start program2

%%

program2
    : {return null;}
    ;

program 
    : def instrs EOF { return _program($1, $2); }
    ;

def
    : DEFINE SIGNED   BYTE '.' { $$ = _define( -8); }
    | DEFINE UNSIGNED BYTE '.' { $$ = _define(  8); }
    | DEFINE SIGNED   WORD '.' { $$ = _define(-16); }
    | DEFINE UNSIGNED WORD '.' { $$ = _define( 16); }
    | DEFINE '-' number    '.' { $$ = _define(-$3); }
    | DEFINE '+' number    '.' { $$ = _define( $3); }
    ;

instrs
    : 
    | instrs instr { $$ = _instrs($1, $2); }
    ;

instr 
    : AT expr '=' expr '.' { $$ = new Assign($2, $4);           }
    | INCR AT expr     '.' { $$ = _incr(1, $3); }
    | DECR AT expr     '.' { $$ = _decr(1, $3); }
    | FLAG number '.' { $$ = new Flag($2); }
    | GOTO  expr  '.' { $$ = new Goto($2); }
    | DISPLAY  expr          '.' { $$ = new Print(0, $2);       }
    | PRINT    expr          '.' { $$ = new Print(1, $2);       }
    | PRINT AT expr ',' expr '.' { $$ = new Print(2, $3, $5);   }
    | IF    expr DO  instrs     elses1 { $$ = _if($2, $4, $5);  }
    | '?>'  expr '[' instrs ']' elses2 { $$ = _if($2, $4, $6);  }
    | IF    expr '[' instrs ']' elses3 { $$ = _if($2, $4, $6);  }
    | LOOP  expr DO  instrs END        { $$ = new Loop($2, $4); }
    | LOOP  expr '[' instrs ']'        { $$ = new Loop($2, $4); }
    | STOP                             { $$ = new Stop();       }
    ;

elses1 
    : END
    | ELSE           instrs END    { $$ = _else  ($2);         }
    | ELSEIF expr DO instrs elses1 { $$ = _elseif($2, $4, $5); }
    ;
elses2 
    : 
    | '?'      '[' instrs ']'        { $$ = _else  ($2);         }
    | '?' expr '[' instrs ']' elses2 { $$ = _elseif($2, $4, $6); }
    ;
elses3 
    : 
    | ELSE        '[' instrs ']'        { $$ = _else  ($2);         }
    | ELSEIF expr '[' instrs ']' elses3 { $$ = _elseif($2, $4, $6); }
    ;

expr 
    : AT   expr       { $$ = new Op(AT, $2); }
    | '('  expr ')'   { $$ =     $2;  }
	| NOT  expr { $$ = new Op(NOT , $2); }
	| BNOT expr { $$ = new Op(BNOT, $2); }
    | INCR AT expr { $$ = _incr(1, $3);  }
    | DECR AT expr { $$ = _decr(1, $3);  }
	| INCR    expr { $$ = _incr(0, $2);  }
	| DECR    expr { $$ = _decr(0, $2);  }
	| '+' expr %prec unplus  { $$ = new Op(ABS, $2); }
	| '-' expr %prec unminus { $$ = new Op(NEG, $2); }
    | expr '+'   expr { $$ = new Op(ADD   , $1, $3); }
    | expr '-'   expr { $$ = new Op(SUB   , $1, $3); }
    | expr '*'   expr { $$ = new Op(MUL   , $1, $3); }
    | expr '/'   expr { $$ = new Op(DIV   , $1, $3); }
    | expr '%'   expr { $$ = new Op(MOD   , $1, $3); }
    | expr '&&'  expr { $$ = new Op(AND   , $1, $3); }
    | expr '||'  expr { $$ = new Op(OR    , $1, $3); }
    | expr '^^'  expr { $$ = new Op(XOR   , $1, $3); }
    | expr '!&&' expr { $$ = new Op(NAND  , $1, $3); }
    | expr '!||' expr { $$ = new Op(NOR   , $1, $3); }
    | expr '!^^' expr { $$ = new Op(XNOR  , $1, $3); }
    | expr '&'   expr { $$ = new Op(BAND  , $1, $3); }
    | expr '|'   expr { $$ = new Op(BOR   , $1, $3); }
    | expr '^'   expr { $$ = new Op(BXOR  , $1, $3); }
    | expr '~&'  expr { $$ = new Op(BNAND , $1, $3); }
    | expr '~|'  expr { $$ = new Op(BNOR  , $1, $3); }
    | expr '~^'  expr { $$ = new Op(BXNOR , $1, $3); }
    | expr '<<'  expr { $$ = new Op(LSHIFT, $1, $3); }
    | expr '>>'  expr { $$ = new Op(RSHIFT, $1, $3); }
    | expr '=='  expr { $$ = new Op(EQU   , $1, $3); }
    | expr '!='  expr { $$ = new Op(DIF   , $1, $3); }
    | expr '>'   expr { $$ = new Op(GRT   , $1, $3); }
    | expr '<'   expr { $$ = new Op(LST   , $1, $3); }
    | expr '>='  expr { $$ = new Op(GTE   , $1, $3); }
    | expr '<='  expr { $$ = new Op(LTE   , $1, $3); }
    | number          { $$ = $1; }
    ;

number
    : DECIMAL         { $$ = _number('decimal'    , yytext); }
    | BINARY          { $$ = _number('binary'     , yytext); }
    | OCTAL           { $$ = _number('octal'      , yytext); }
    | HEXADECIMAL     { $$ = _number('hexadecimal', yytext); }
    ;