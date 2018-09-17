keywords = /// (?:
    main   | MAIN   |
    do     | DO     | \[  | \{ |
    end    | END    | \]  | \} |
    return | RETURN | \*> |
    if     | IF     | \?  |
    elseif | ELSEIF |
    else   | ELSE   |
    while  | WHILE  |
    loop   | LOOP   |
    stop   | STOP   | \|> |
    retry  | RETRY  | <\| |
    use    | USE    |
    bits   | BITS
) ///

number = ///
  ^ 0b[01]+       | # binary
  ^ 0o[0-7]+      | # octal
  ^ 0x[\da-fA-F]+ | # hex
  ^ \d+             # decimal
///i

operators = ///
    [-+\/*=<>!~&\|\^¬∧∨⊕⊼⊽≡]+
///

builtins = ///
    at    | AT    |  @     |
    reg   | REG   | \$     |
    wait  | WAIT  | \(%\)  |
    print | PRINT | \(&\)  |
    bell  | BELL  | \(\*\)
///

variables = ///
    ^[a-zA-Z][\w]*
///

start = [
    {
        regex: /"(?:[^\\]|\\.)*?(?:"|$)/
        token: "string"
    },
    {
        regex: keywords
        token: "keyword"
    },
    {
        regex: number
        token: "number"
    },
    {
        regex: operators
        token: "operator"
    },
    {
        regex: builtins
        token: "atom"
    },
    {
        regex: variables
        token: "variable"
    },
    {
        regex: /(?:#|❦).*/
        token: "comment"
    },
    {
        regex: /#\(|☙/
        token: "comment"
        next:  "comment"
    }
]

comment = [
    {
        regex: /.*?(?:\)#|❧)/
        token: "comment"
        next:  "start"
    },
    {
        regex: /.*/
        token: "comment"
    }
]

CodeMirror.defineSimpleMode("tape", {
    start:   start
    comment: comment
    meta:
        dontIndentStates: ["comment"],
        lineComment: "#"
})
