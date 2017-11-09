/* operator associations and precedence */
%nonassoc '='
%nonassoc '==' '!='
%nonassoc '>' '<' '>=' '<='
%left  '&&' '||' '^^' '!&&' '!||' '!^^'
%left  '+' '-'
%left  '*' '/' '%'
%left  '&' '|' '^' '~&' '~|' '~^' '<<' '>>'
%right AT '!' '~' '++' '--' unplus unminus

%start program

%%

program 
    : instrs EOF { $$ = _program($1); }
    ;

instrs
    : 
    | instrs instr { $$ = _instrs($1, $2); }
    ;

instr 
    : AT expr '=' expr '.' { $$ = _assign($2, $4); }
    | FLAG NUMBER      '.' { $$ = _flag  ($2);     }
    | GOTO expr        '.' { $$ = _goto  ($2);     }
    | PRINT expr       '.' { $$ = _print ($2);     }
    | IF   expr DO  instrs     elses1 { $$ = _if($2, $4, $5); }
    | '?>' expr '[' instrs ']' elses2 { $$ = _if($2, $4, $6); }
    | IF   expr '[' instrs ']' elses3 { $$ = _if($2, $4, $6); }
    | LOOP expr DO  instrs END        { $$ = _loop  ($2, $4); }
    | LOOP expr '[' instrs ']'        { $$ = _loop  ($2, $4); }
    | STOP                            { $$ = _stop  ();       }
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
    : AT   expr       { $$ = _at($2);   }
    | '('  expr ')'   { $$ =     $2;    }
	| NOT  expr { $$ = _op('!'   , $2); }
	| BNOT expr { $$ = _op('~'   , $2); }
	| INCR expr { $$ = _op('INCR', $2); }
	| DECR expr { $$ = _op('DECR', $2); }
	| '+' expr %prec unplus  { $$ = _op('ABS', $2); }
	| '-' expr %prec unminus { $$ = _op('NEG', $2); }
    | expr '+'   expr { $$ = _op('+'  , $1, $3); }
    | expr '-'   expr { $$ = _op('-'  , $1, $3); }
    | expr '*'   expr { $$ = _op('*'  , $1, $3); }
    | expr '/'   expr { $$ = _op('/'  , $1, $3); }
    | expr '%'   expr { $$ = _op('%'  , $1, $3); }
    | expr '&&'  expr { $$ = _op('&&' , $1, $3); }
    | expr '||'  expr { $$ = _op('||' , $1, $3); }
    | expr '^^'  expr { $$ = _op('^^' , $1, $3); }
    | expr '!&&' expr { $$ = _op('!&&', $1, $3); }
    | expr '!||' expr { $$ = _op('!||', $1, $3); }
    | expr '!^^' expr { $$ = _op('!^^', $1, $3); }
    | expr '&'   expr { $$ = _op('&'  , $1, $3); }
    | expr '|'   expr { $$ = _op('|'  , $1, $3); }
    | expr '^'   expr { $$ = _op('^'  , $1, $3); }
    | expr '~&'  expr { $$ = _op('~&' , $1, $3); }
    | expr '~|'  expr { $$ = _op('~|' , $1, $3); }
    | expr '~^'  expr { $$ = _op('~^' , $1, $3); }
    | expr '<<'  expr { $$ = _op('<<' , $1, $3); }
    | expr '>>'  expr { $$ = _op('>>' , $1, $3); }
    | expr '=='  expr { $$ = _op('==' , $1, $3); }
    | expr '!='  expr { $$ = _op('!=' , $1, $3); }
    | expr '>'   expr { $$ = _op('>'  , $1, $3); }
    | expr '<'   expr { $$ = _op('<'  , $1, $3); }
    | expr '>='  expr { $$ = _op('>=' , $1, $3); }
    | expr '<='  expr { $$ = _op('<=' , $1, $3); }
    | DECIMAL         { $$ = _number('decimal'    , yytext); }
    | BINARY          { $$ = _number('binary'     , yytext); }
    | OCTAL           { $$ = _number('octal'      , yytext); }
    | HEXADECIMAL     { $$ = _number('hexadecimal', yytext); }
    ;