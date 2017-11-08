{
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Parser (
  parseExpr,
  parseTokens,
) where

import Lexer
import Syntax

import Control.Monad.Except

}

-- Entry point
%name expr

-- Lexer structure 
%tokentype { Token }

-- Parser monad
%monad { Except String } { (>>=) } { return }
%error { parseError }

-- Token Names
%token
	'='   { TokenAssign }
  	print { TokenPrint  }
  	flag  { TokenFlag   }
  	goto  { TokenGoto   }
  	if    { TokenIf     }   
  	else  { TokenElse   }
  	loop  { TokenLoop   } 
  	stop  { TokenStop   }
  	beg   { TokenBlockBegin1 } 
  	'['   { TokenBlockBegin2 } 
  	end   { TokenBlockEnd1   } 
  	']'   { TokenBlockEnd2   }
  	'.'   { TokenInstrEnd    }
  	at    { TokenAt   }
  	'+'   { TokenAdd  }    
  	'-'   { TokenSub  } 
  	'*'   { TokenMul  }  
  	'/'   { TokenDiv  }  
  	'%'   { TokenMod  }
  	incr  { TokenIncr }   
  	decr  { TokenDecr }
  	not   { TokenNot  }    
  	and   { TokenAnd  }  
  	or    { TokenOr   } 
  	xor   { TokenXor  }  
  	nand  { TokenNand }
  	nor   { TokenNor  }
  	xnor  { TokenXnor }
  	bnot  { TokenBNot }  
  	band  { TokenBAnd }
  	bor   { TokenBOr  }
  	bxor  { TokenBXor }
  	bnand { TokenBNand} 
  	bnor  { TokenBNor }
  	bxnor { TokenBXnor}
  	'=='  { TokenEquals   }
  	'!='  { TokenDiff     }
  	'>'   { TokenGreater  }
  	'<'   { TokenLesser   }
  	'>='  { TokenEquGreat }
  	'<='  { TokenEquLess  }
  	'('   { TokenLParen   }
  	')'   { TokenRParen   }
  	STR   { TokenSym String }
  	NUM   { TokenNum Int    }

-- Operators
%nonassoc '='
%nonassoc '>' '<' '>=' '<='
%nonassoc '==' '!='
%left   and  or  xor  nand  nor  xnor
%left  band bor bxor bnand bnor bxnor
%left  '+' '-'
%left  '*' '/' '%'
%right at not bnot incr decr 
%%

Inst : Expr '=' Expr '.'           { Lam $1 $3 }
	 | flag NUM  '.'               { $2 }
	 | goto Expr '.'               { $2 }
	 | if Expr Block Elses         {  }
	 | loop Expr Block             { }
	 | stop                        { }
	 | print Expr '.'              { }

Block : beg Insts end { $2 }
	  | '[' Insts ']' { $2 }

Insts : {- empty -}
	  | Inst Insts

Elses : {- empty -}
	  | else Block
	  | else Expr Block Elses

Expr : at   Expr      { $2 }
	 | not  Expr	  { $2 }
	 | bnot Expr      { $2 }
	 | incr Expr      { $2 }
	 | decr Expr      { $2 }
	 | '('  Expr ')'  { $2 }
     | Expr '+'   Expr { Op Add    $1 $3 }
     | Expr '-'   Expr { Op Sub    $1 $3 }
     | Expr '*'   Expr { Op Mul    $1 $3 }
     | Expr '/'   Expr { Op Div    $1 $3 }
     | Expr '%'   Expr { Op Mod    $1 $3 }
     | Expr and   Expr { Op And    $1 $3 }
     | Expr or    Expr { Op Or     $1 $3 }
     | Expr xor   Expr { Op Xor    $1 $3 }
     | Expr nand  Expr { Op Nand   $1 $3 }
     | Expr nor   Expr { Op Nor    $1 $3 }
     | Expr xnor  Expr { Op Xnor   $1 $3 }
     | Expr band  Expr { Op BNand  $1 $3 }
     | Expr bor   Expr { Op BOr    $1 $3 }
     | Expr bxor  Expr { Op BXor   $1 $3 }
     | Expr bnand Expr { Op BNand  $1 $3 }
     | Expr bnor  Expr { Op BNor   $1 $3 }
     | Expr bxnor Expr { Op BXnor  $1 $3 }
     | Expr '=='  Expr { Op Equals $1 $3 }
     | Expr '!='  Expr { Op Diff   $1 $3 }
     | Expr '>'   Expr { Op Greater  $1 $3 }
     | Expr '<'   Expr { Op Lesser   $1 $3 }
     | Expr '>='  Expr { Op EquGreat $1 $3 }
     | Expr '<='  Expr { Op EquLess  $1 $3 }
     | NUM             { Lit (LInt $1) }

{

parseError :: [Token] -> Except String a
parseError (l:ls) = throwError (show l)
parseError [] = throwError "Unexpected end of Input"

parseExpr :: String -> Either String Expr
parseExpr input = runExcept $ do
  tokenStream <- scanTokens input
  expr tokenStream

parseTokens :: String -> Either String [Token]
parseTokens = runExcept . scanTokens
    
}