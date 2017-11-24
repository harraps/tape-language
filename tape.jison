/* lexical grammar */

%lex
%options flex

%%

\s+                 {/* skip white space */}
"#".*               {/* ignore comments  */}
"define"|"DEFINE"|"[#]"|"※"|"⚙️"    return 'DEFINE';
"signed"|"SIGNED"                     return 'SIGNED';
"unsigned"|"UNSIGNED"                 return 'UNSIGNED';
"byte"|"BYTE"                         return 'BYTE';
"word"|"WORD"                         return 'WORD';
[0-9]+\b                              return 'DECIMAL';
"b"[0-1]+\b                           return 'BINARY';
"o"[0-7]+\b                           return 'OCTAL';
"x"[0-9a-fA-F]+\b                     return 'HEXADECIMAL';
"assign"|"ASSIGN"|"="|"✍️"           return '=';
"print"|"PRINT"|"$$"|"💬"|"✒️"      return 'PRINT';
"display"|"DISPLAY"|"$"|"👁"         return 'DISPLAY';
"set"\s+"flag"|"FLAG"|"::"|"🏳️"     return 'FLAG';
"go"\s+"to"|"GOTO"|":>"|"➳"|"➵"|"➸"|"➻"|"➺"|"➼"|"➽" return 'GOTO';
"while"|"loop"\s+"while"|"LOOP"|"@>"|"🔁"|"🔄"|"🔃"|"♻️" return 'LOOP';
"stop"|"STOP"|"|>"|"✋"|"🔙"|"⏏"   return 'STOP';
"if"|"IF"                            return 'IF';
"else"\s+"if"|"ELSEIF"               return 'ELSEIF';
"else"|"ELSE"                        return 'ELSE';
"?>"|"❓"|"❔"                       return '?>';
"?"|"⁉️"                             return '?';
"do"|"DO"|"🔛"                      return 'DO';
"end"|"END"|"🔚"                    return 'END';
"["|"{"                              return '[';
"]"|"}"                              return ']';
","                                 return ',';
"."|";"                             return '.';
"at"|"AT"|"@"|"⭐"                 return 'AT';
"add"|"ADD"|"+"                     return '+';
"subtrack"|"SUB"|"-"                return '-';
"multiply"|"MUL"|"*"|"×"            return '*';
"divide"|"DIV"|"/"|"÷"              return '/';
"remainer"|"mod"|"MOD"|"%"          return '%';
"increment"|"INCR"|"++"|"👍"       return '++';
"decrement"|"DECR"|"--"|"👎"       return '--';
"not"|"NOT"|"!"|"¬"                 return '!';
"and"|"AND"|"&&"|"∧"                return '&&';
"or"|"OR"|"||"|"∨"                  return '||';
"xor"|"XOR"|"^^"|"⊕"                return '^^';
"nand"|"NAND"|"!&&"                 return '!&&';
"nor"|"NOR"|"!||"                   return '!||';
"xnor"|"XNOR"|"!^^"|"≡"             return '!^^';
"equals"|"EQUALS"|"=="                  return '==';
"different"\s+"than"|"DIFF"|"!="|"≠"    return '!=';
"greater"\s+"than"|"GREATER"|">"        return '>';
"lesser"\s+"than"|"LESSER"|"<"          return '<';
"greater"\s+"or"\s+"equals"|"GREATEQU"|">="|"≥" return '>=';
"lesser"\s+"or"\s+"equals"|"LESSEQU"|"<="|"≤"   return '<=';
"("|"⟨"                                 return '(';
")"|"⟩"                                 return ')';
"binary"\s+"not"|"BNOT"|"~"             return '~';
"binary"\s+"and"|"BAND"|"&"             return '&';
"binary"\s+"or"|"BOR"|"|"               return '|';
"binary"\s+"xor"|"BXOR"|"^"             return '^';
"binary"\s+"nand"|"BNAND"|"~&"          return '~&';
"binary"\s+"nor"|"BNOR"|"~|"            return '~|';
"binary"\s+"xnor"|"BXNOR"|"~^"          return '~^';
"left"\s+"shift"|"LSHIFT"|"<<"|"≪"|"»"|"👈"   return '<<';
"right"\s+"shift"|"RSHIFT"|">>"|"≫"|"«"|"👉"  return '>>';
<<EOF>>             return 'EOF';
.                   return 'INVALID';

/lex

/* operator associations and precedence */
%nonassoc '='
%nonassoc '==' '!='
%nonassoc '>' '<' '>=' '<='
%left  '&&' '||' '^^' '!&&' '!||' '!^^'
%left  '&' '|' '^' '~&' '~|' '~^' '<<' '>>'
%left  '+' '-'
%left  '*' '/' '%'
%right AT '!' '~' '++' '--' UNPLUS UNMINUS

%start program

%%

program 
    : def instrs EOF { return TAPE.func._program($1, $2); }
    ;

def
    : DEFINE SIGNED   BYTE '.' { $$ = TAPE.func._define( -8); }
    | DEFINE UNSIGNED BYTE '.' { $$ = TAPE.func._define(  8); }
    | DEFINE SIGNED   WORD '.' { $$ = TAPE.func._define(-16); }
    | DEFINE UNSIGNED WORD '.' { $$ = TAPE.func._define( 16); }
    | DEFINE '-' number    '.' { $$ = TAPE.func._define(-$3); }
    | DEFINE '+' number    '.' { $$ = TAPE.func._define( $3); }
    ;

instrs
    : 
    | instrs instr { $$ = TAPE.func._instrs($1, $2); }
    ;

instr 
    : AT expr '=' expr '.' { $$ = new TAPE.inst.Assign($2, $4); }
    | '++' AT expr     '.' { $$ = TAPE.func._incr(1, $3); }
    | '--' AT expr     '.' { $$ = TAPE.func._decr(1, $3); }
    | FLAG number '.' { $$ = new TAPE.inst.Flag($2); }
    | GOTO  expr  '.' { $$ = new TAPE.inst.Goto($2); }
    | DISPLAY  expr          '.' { $$ = new TAPE.inst.Print(0, $2);         }
    | PRINT    expr          '.' { $$ = new TAPE.inst.Print(1, $2);         }
    | PRINT AT expr ',' expr '.' { $$ = new TAPE.inst.Print(2, $3, $5);     }
    | IF    expr DO  instrs     elses1 { $$ = TAPE.func._if($2, $4, $5);  }
    | '?>'  expr '[' instrs ']' elses2 { $$ = TAPE.func._if($2, $4, $6);  }
    | IF    expr '[' instrs ']' elses3 { $$ = TAPE.func._if($2, $4, $6);  }
    | LOOP  expr DO  instrs END        { $$ = new TAPE.inst.Loop($2, $4);   }
    | LOOP  expr '[' instrs ']'        { $$ = new TAPE.inst.Loop($2, $4);   }
    | STOP                             { $$ = new TAPE.inst.Stop();         }
    ;

elses1 
    : END
    | ELSE           instrs END    { $$ = TAPE.func._else  ($2);         }
    | ELSEIF expr DO instrs elses1 { $$ = TAPE.func._elseif($2, $4, $5); }
    ;
elses2 
    : 
    | '?'      '[' instrs ']'        { $$ = TAPE.func._else  ($2);         }
    | '?' expr '[' instrs ']' elses2 { $$ = TAPE.func._elseif($2, $4, $6); }
    ;
elses3 
    : 
    | ELSE        '[' instrs ']'        { $$ = TAPE.func._else  ($2);         }
    | ELSEIF expr '[' instrs ']' elses3 { $$ = TAPE.func._elseif($2, $4, $6); }
    ;

expr 
    : AT   expr       { $$ = new TAPE.inst.Op(TAPE.op.AT, $2); }
    | '('  expr ')'   { $$ = $2; }
	| NOT  expr { $$ = new TAPE.inst.Op(TAPE.op.NOT , $2); }
	| BNOT expr { $$ = new TAPE.inst.Op(TAPE.op.BNOT, $2); }
    | '++' AT expr { $$ = TAPE.func._incr(1, $3);  }
    | '--' AT expr { $$ = TAPE.func._decr(1, $3);  }
	| '++'    expr { $$ = TAPE.func._incr(0, $2);  }
	| '--'    expr { $$ = TAPE.func._decr(0, $2);  }
	| '+' expr %prec UNPLUS  { $$ = new TAPE.inst.Op(TAPE.op.ABS, $2); }
	| '-' expr %prec UNMINUS { $$ = new TAPE.inst.Op(TAPE.op.NEG, $2); }
    | expr '+'   expr { $$ = new TAPE.inst.Op(TAPE.op.ADD   , $1, $3); }
    | expr '-'   expr { $$ = new TAPE.inst.Op(TAPE.op.SUB   , $1, $3); }
    | expr '*'   expr { $$ = new TAPE.inst.Op(TAPE.op.MUL   , $1, $3); }
    | expr '/'   expr { $$ = new TAPE.inst.Op(TAPE.op.DIV   , $1, $3); }
    | expr '%'   expr { $$ = new TAPE.inst.Op(TAPE.op.MOD   , $1, $3); }
    | expr '&&'  expr { $$ = new TAPE.inst.Op(TAPE.op.AND   , $1, $3); }
    | expr '||'  expr { $$ = new TAPE.inst.Op(TAPE.op.OR    , $1, $3); }
    | expr '^^'  expr { $$ = new TAPE.inst.Op(TAPE.op.XOR   , $1, $3); }
    | expr '!&&' expr { $$ = new TAPE.inst.Op(TAPE.op.NAND  , $1, $3); }
    | expr '!||' expr { $$ = new TAPE.inst.Op(TAPE.op.NOR   , $1, $3); }
    | expr '!^^' expr { $$ = new TAPE.inst.Op(TAPE.op.XNOR  , $1, $3); }
    | expr '&'   expr { $$ = new TAPE.inst.Op(TAPE.op.BAND  , $1, $3); }
    | expr '|'   expr { $$ = new TAPE.inst.Op(TAPE.op.BOR   , $1, $3); }
    | expr '^'   expr { $$ = new TAPE.inst.Op(TAPE.op.BXOR  , $1, $3); }
    | expr '~&'  expr { $$ = new TAPE.inst.Op(TAPE.op.BNAND , $1, $3); }
    | expr '~|'  expr { $$ = new TAPE.inst.Op(TAPE.op.BNOR  , $1, $3); }
    | expr '~^'  expr { $$ = new TAPE.inst.Op(TAPE.op.BXNOR , $1, $3); }
    | expr '<<'  expr { $$ = new TAPE.inst.Op(TAPE.op.LSHIFT, $1, $3); }
    | expr '>>'  expr { $$ = new TAPE.inst.Op(TAPE.op.RSHIFT, $1, $3); }
    | expr '=='  expr { $$ = new TAPE.inst.Op(TAPE.op.EQU   , $1, $3); }
    | expr '!='  expr { $$ = new TAPE.inst.Op(TAPE.op.DIF   , $1, $3); }
    | expr '>'   expr { $$ = new TAPE.inst.Op(TAPE.op.GRT   , $1, $3); }
    | expr '<'   expr { $$ = new TAPE.inst.Op(TAPE.op.LST   , $1, $3); }
    | expr '>='  expr { $$ = new TAPE.inst.Op(TAPE.op.GTE   , $1, $3); }
    | expr '<='  expr { $$ = new TAPE.inst.Op(TAPE.op.LTE   , $1, $3); }
    | number          { $$ = $1; }
    ;

number
    : DECIMAL         { $$ = TAPE.func._number('decimal'    , yytext); }
    | BINARY          { $$ = TAPE.func._number('binary'     , yytext); }
    | OCTAL           { $$ = TAPE.func._number('octal'      , yytext); }
    | HEXADECIMAL     { $$ = TAPE.func._number('hexadecimal', yytext); }
    ;