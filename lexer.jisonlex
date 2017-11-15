%options flex

%%
\s+                 {/* skip white space */}
#.*                 {/* ignore comments  */}
"DEFINE"|"[#]"      return 'DEFINE';
"SIGNED"            return 'SIGNED';
"UNSIGNED"          return 'UNSIGNED';
"BYTE"              return 'BYTE';
"WORD"              return 'WORD';
[0-9]+              return 'DECIMAL';
b(0|1)+             return 'BINARY';
o[0-7]+             return 'OCTAL';
x[0-9a-fA-F]+       return 'HEXADECIMAL';
"ASSIGN"|"="        return '=';
"PRINT"|"$$"        return 'PRINT';
"DISPLAY"|"$"       return 'DISPLAY';
"FLAG"|"::"         return 'FLAG';
"GOTO"|":>"         return 'GOTO';
"LOOP"|"@>"         return 'LOOP';
"STOP"|"|>"         return 'STOP';
"IF"                return 'IF';
"ELSEIF"            return 'ELSEIF';
"ELSE"              return 'ELSE';
"?>"                return '?>';
"?"                 return '?';
"DO"                return 'DO';
"END"               return 'END';
"["                 return '[';
"]"                 return ']';
","                 return ',';
"."                 return '.';
"AT"|"@"            return 'AT';
"ADD"|"+"           return '+';
"SUB"|"-"           return '-';
"MUL"|"*"           return '*';
"DIV"|"/"           return '/';
"MOD"|"%"           return '%';
"INCR"|"++"         return '++';
"DECR"|"--"         return '--';
"NOT"|"!"           return '!';
"AND"|"&&"          return '&&';
"OR"|"||"           return '||';
"XOR"|"^^"          return '^^';
"NAND"|"!&&"        return '!&&';
"NOR"|"!||"         return '!||';
"XNOR"|"!^^"        return '!^^';
"EQUALS"|"=="       return '==';
"DIFF"|"!="         return '!=';
"GREATER"|">"       return '>';
"LESSER"|"<"        return '<';
"GREATEQU"|">="     return '>=';
"LESSEQU"|"<="      return '<=';
"("                 return '(';
")"                 return ')';
"BNOT"|"~"          return '~';
"BAND"|"&"          return '&';
"BOR"|"|"           return '|';
"BXOR"|"^"          return '^';
"BNAND"|"~&"        return '~&';
"BNOR"|"~|"         return '~|';
"BXNOR"|"~^"        return '~^';
"LSHIFT"|"<<"       return '<<';
"RSHIFT"|">>"       return '>>';
<<EOF>>             return 'EOF';
.                   return 'INVALID';
