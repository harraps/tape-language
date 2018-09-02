%lex
%options flex

%%

\s+           {/* skip white space */}
("#"|"❦").*  {/* ignore comments  */}
"#(".*")#"    {/* ignore comments  */}
"☙".*"❧"    {/* ignore comments  */}

"USE"\s*"8"\s*"BITS"|"use"\s*"8"\s*"bits"|"[8]"   return 'DEFINE_8';
"USE"\s*"16"\s*"BITS"|"[16]" return 'DEFINE_16';

[0-9]+\b           return 'DECIMAL';
"0b"[0-1]+\b       return 'BINARY';
"0o"[0-7]+\b       return 'OCTAL';
"0x"[0-9a-fA-F]+\b return 'HEXADECIMAL';
"'"."'"            return 'CHARACTER';

"\"".*"\"" return 'STRING';
"❝".*"❞"   return 'STRING';

"(" return '(';
")" return ')';
"," return ',';

"MAIN"|"main"          return 'MAIN';
"RETURN"|"return"|"*>" return 'RETURN';

"DO"|"do"   return 'DO';
"END"|"end" return 'END';

"IF"|"if"                   return 'IF';
"ELSE"\s*"IF"|"else"\s*"if" return 'ELSEIF';
"ELSE"|"else"               return 'ELSE';
"?" return '?';
"{" return '{';
"}" return '}';

"WHILE"|"while" return 'WHILE';
"LOOP"|"loop"   return 'LOOP';
"RETRY"|"retry" return 'RETRY';
"STOP"|"stop"   return 'STOP';
"["  return '[';
"]"  return ']';
"<|" return '<|';
"|>" return '|>';

":="|"=" return '=';
"."|";"  return '.';

"WAIT"|"wait"|"(%)"|"⧗"   return 'WAIT';
"BELL"|"bell"|"(*)"|"♫"   return 'BELL';
"PRINT"|"print"|"(&)"|"¶"  return 'PRINT';

"AT"|"at"|"@"   return 'AT';
"REG"|"reg"|"$" return 'REG';

"+"             return '+';
"-"             return '-';
"*"|"×"         return '*';
"/"|"÷"         return '/';
"%"|"MOD"|"mod" return '%';

"NOT"|"not"|"!"|"¬"     return 'NOT';
"AND"|"and"|"&&"|"∧"    return 'AND';
"OR"|"or"|"||"|"∨"      return 'OR';
"XOR"|"xor"|"^^"|"⊕"   return 'XOR';
"NAND"|"nand"|"!&"|"⊼"  return 'NAND';
"NOR"|"nor"|"!|"|"⊽"    return 'NOR';
"XNOR"|"xnor"|"!^"|"≡"  return 'XNOR';

"~"  return 'BNOT';
"&"  return 'BAND';
"|"  return 'BOR';
"^"  return 'BXOR';
"~&" return 'BNAND';
"~|" return 'BNOR';
"~^" return 'BXNOR';
"<<" return '<<';
">>" return '>>';

"==" return '==';
"!=" return '!=';
">"  return '>';
"<"  return '<';
">=" return '>=';
"<=" return '<=';

"++"|"⭜" return 'INCR';
"--"|"⭝" return 'DECR';

[A-Za-z_\u00A0-\uFFFF]+ return 'NAME';

<<EOF>> return 'EOF';
.       return 'INVALID';
