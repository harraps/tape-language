{
module Lexer (
  Token(..),
  scanTokens
) where

import Syntax

import Control.Monad.Except

}

%wrapper "basic"

$digit   = [0-9]
$octdig  = [0-7]
$hexdig  = [0-9a-fA-F]
$alpha   = [a-zA-Z]
$eol     = [\n]
$special = [\.\;\,\$\|\*\+\?\#\~\-\{\}\(\)\[\]\^\/]
$graphic = $printable # $white

@string = \" ($graphic # \")* \"
@code = -- curly braces surrounding a Haskell code fragment

tokens :-

  -- Whitespace insensitive
  $eol                          ;
  $white+                       ;

  -- Strings
  <0>           \"              {beginString}
  <stringSC>    \"              {endString}
  <stringSC>    .               {appendString}
  <stringSC>    \\[nt\"]        {escapeString}

  -- Comments
  <0>           "#".*           ;
  <0,commentSC> "#["            {beginComment}
  <commentSC>   "]#"            {endComment}
  <commentSC>   [.\n]           ;

  -- Instructions
  (ASSIGN  | '=' ) { \s -> TokenAssign  }
  (PRINT   | '$' ) { \s -> TokenPrint   }
  (FLAG    | "::") { \s -> TokenFlag    }
  (GOTO    | ":>") { \s -> TokenGoto    }
  (LOOP    | "@>") { \s -> TokenLoop    }
  (STOP    | "|>") { \s -> TokenStop    }
  IF     { \s -> TokenIf1         }
  "?>"   { \s -> TokenIf2         }
  ELSE   { \s -> TokenElse1       }
  '?'    { \s -> TokenElse2       }
  ELSEIF { \s -> TokenElseIf      }
  DO     { \s -> TokenBlockBegin1 }
  '['    { \s -> TokenBlockBegin2 }
  END    { \s -> TokenBlockEnd1   }
  ']'    { \s -> TokenBlockEnd2   }
  '.'    { \s -> TokenInstrEnd    }

  -- Expressions
  (AT   | '@'  ) { \s -> TokenAt   }
  (ADD  | '+'  ) { \s -> TokenAdd  }
  (SUB  | '-'  ) { \s -> TokenSub  }
  (MUL  | '*'  ) { \s -> TokenMul  }
  (DIV  | '/'  ) { \s -> TokenDiv  }
  (MOD  | '%'  ) { \s -> TokenMod  }
  (INCR | "++" ) { \s -> TokenIncr }
  (DECR | "--" ) { \s -> TokenDecr }
  (NOT  | '!'  ) { \s -> TokenNot  }
  (AND  | "&&" ) { \s -> TokenAnd  }
  (OR   | "||" ) { \s -> TokenOr   }
  (XOR  | "^^" ) { \s -> TokenXor  }
  (NAND | "!&&") { \s -> TokenNand }
  (NOR  | "!||") { \s -> TokenNor  }
  (XNOR | "!^^") { \s -> TokenXnor }
  (EQUALS   | "==") { \s -> TokenEquals   }
  (DIFF     | "!=") { \s -> TokenDiff     }
  (GREATER  | '>' ) { \s -> TokenGreater  }
  (LESSER   | '<' ) { \s -> TokenLesser   }
  (EQUGREAT | ">=") { \s -> TokenEquGreat }
  (EQULESS  | "<=") { \s -> TokenEquLess  }
  '('  { \s -> TokenLParen }
  ')'  { \s -> TokenRParen }
  '~'  { \s -> TokenBNot   }
  '&'  { \s -> TokenBAnd   }
  '|'  { \s -> TokenBOr    }
  '^'  { \s -> TokenBXor   }
  "~&" { \s -> TokenBNand  }
  "~|" { \s -> TokenBNor   }
  "~^" { \s -> TokenBXnor  }

  -- Values
  $digit+      { \s -> TokenNum (read s) }
  o$octdig+    { \s -> TokenNum (read s) }
  x$hexdig+    { \s -> TokenNum (read s) }
  \'$graphic\' { \s -> TokenNum (read s) }

{
data Token 
  = TokenAssign
  | TokenPrint
  | TokenFlag 
  | TokenGoto
  | TokenLoop 
  | TokenStop
  | TokenIf1
  | TokenIf2   
  | TokenElse1
  | TokenElse2
  | TokenElseIf
  | TokenBlockBegin1 
  | TokenBlockBegin2 
  | TokenBlockEnd1 
  | TokenBlockEnd2
  | TokenInstrEnd
  | TokenAt
  | TokenAdd    
  | TokenSub  
  | TokenMul  
  | TokenDiv  
  | TokenMod
  | TokenIncr   
  | TokenDecr
  | TokenNot    
  | TokenAnd  
  | TokenOr  
  | TokenXor 
  | TokenNand 
  | TokenNor
  | TokenXnor
  | TokenBNot   
  | TokenBAnd 
  | TokenBOr  
  | TokenBXor 
  | TokenBNand 
  | TokenBNor 
  | TokenBXnor
  | TokenEquals 
  | TokenDiff 
  | TokenGreater 
  | TokenLesser 
  | TokenEquGreat 
  | TokenEquLess
  | TokenLParen 
  | TokenRParen
  | TokenSym String
  | TokenNum Int
  | TokenEOF
  deriving (Eq,Show)
scanTokens :: String -> Except String [Token]
scanTokens str = go ('\n',[],str) where 
  go inp@(_,_bs,str) =
    case alexScan inp 0 of
     AlexEOF -> return []
     AlexError _ -> throwError "Invalid lexeme."
     AlexSkip  inp' len     -> go inp'
     AlexToken inp' len act -> do
      res <- go inp'
      let rest = act (take len str)
      return (rest : res)
}