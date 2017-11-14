class Tape 
    constructor: (@type) ->
        # used to store the data
        @array = switch @type
            when   8 then new Uint8Array  0x100
            when  -8 then new Int8Array   0x100
            when  16 then new Uint16Array 0x10000
            when -16 then new Int16Array  0x10000
        # used for keeping numbers in the expected range
        @byte = switch @type
            when   8 then new Uint8Array  1
            when  -8 then new Int8Array   1
            when  16 then new Uint16Array 1
            when -16 then new Int16Array  1
        # used to correctly index the array
        @index = switch math.abs @type
            when  8 then new Uint8Array  1
            when 16 then new Uint16Array 1
    # convert to the numerical type chosen
    c: (x) ->
        @byte[0] = x 
        return @byte[0]
    # set the value in the array
    s: (i, x) -> 
        @index[0] = i
        @array[@index[0]] = x
    # get the value from the array
    g: (i) ->
        @index[0] = i
        return @array[@index[0]]

TAPE = null
INSTRUCTIONS = []

# unary
AT   = (i) -> TAPE.g i
NOT  = (a) -> unless a then 0 else 1
BNOT = (a) -> TAPE.c(~a)
INCR = (a) -> TAPE.c(a+1)
DECR = (a) -> TAPE.c(a-1)
INCR_ = (i) -> 
    TAPE.index[0] = i
    return ++TAPE.array[TAPE.index[0]]
DECR_ = (i) -> 
    TAPE.index[0] = i
    return --TAPE.array[TAPE.index[0]]

ABS = (a) -> TAPE.c math.abs a # special case |-128| -> 128 > 127 -> -128
NEG = (a) -> TAPE.c(-a)        # we may have only positive numbers
# arithmetic
ADD = (a, b) -> TAPE.c(a + b)
SUB = (a, b) -> TAPE.c(a - b)
MUL = (a, b) -> TAPE.c(a * b)
DIV = (a, b) -> TAPE.c(a / b) # if b == 0 -> 0
MOD = (a, b) -> TAPE.c(a % b) 
# logical
AND  = (a, b) -> if  a &&  b then 1 else 0
OR   = (a, b) -> if  a ||  b then 1 else 0
XOR  = (a, b) -> if !a != !b then 1 else 0
NAND = (a, b) -> if  a &&  b then 0 else 1
NOR  = (a, b) -> if  a ||  b then 0 else 1
XNOR = (a, b) -> if !a != !b then 0 else 1
# bitwise
BAND   = (a, b) -> TAPE.c(a & b)
BOR    = (a, b) -> TAPE.c(a | b)
BXOR   = (a, b) -> TAPE.c(a ^ b) 
BNAND  = (a, b) -> TAPE.c(~(a & b))
BNOR   = (a, b) -> TAPE.c(~(a | b))
BXNOR  = (a, b) -> TAPE.c(~(a ^ b)) 
LSHIFT = (a, b) -> TAPE.c(a << b)
RSHIFT = (a, b) -> TAPE.c(a >> b)
# comparator
EQU = (a, b) -> if a == b then 1 else 0
DIF = (a, b) -> if a != b then 1 else 0
GRT = (a, b) -> if a >  b then 1 else 0
LST = (a, b) -> if a <  b then 1 else 0
GTE = (a, b) -> if a >= b then 1 else 0
LSE = (a, b) -> if a <= b then 1 else 0

class Instruction 
    print: -> "instruction undefined"

class Assign extends Instruction
    constructor: (@cell, @value) ->
    print: -> "at #{@cell} assign #{@value.print()}"

class Increment extends Instruction
    constructor: (@cell) ->
    print: -> "increment value at #{@cell}"

class Decrement extends Instruction
    constructor: (@cell) ->
    print: -> "decrement value at #{@cell}"

class Flag extends Instruction
    constructor: (@id) ->
    print: -> "flag #{@id.print()}"

class Goto extends Instruction
    constructor: (@id) ->
    print: -> "go to flag #{@id.print()}"

class Print extends Instruction
    constructor: (@type, @value, @range) ->
    print: -> switch @type
        when 0 then "display #{@value.print()}" # display
        when 1 then "print #{@value.print()}"   # print char
        when 2 then "print starting at #{@value.print()} 
            up to #{@range.print()} characters" # print range

class If extends Instruction
    constructor: (@conds, @blocks) ->
    print: ->
        strings = []
        for [cond, block] in zip(@conds, @blocks)
            strings.append("if #{cond.print()} then do #{block.print()} \n")
        return strings.join()

class Loop extends Instruction
    constructor: (@cond, @block) ->
    print: -> "loop while #{@cond.print()} and do #{block.print()}"

class Stop extends Instruction
    print: -> "stop"

class Op 
    constructor: (@op, @left, @right) ->
        # incr and decr change the value in the tape when used
        if @op == INCR or @op == DECR
            if @left instanceof Op and Op.op == AT


_program = (def, instrs) -> INSTRUCTIONS = instrs
_define  = (value) -> TAPE = new Tape(value)
_instrs  = (instrs, instr) ->
    instrs = instrs or []
    instrs.append instr
    return instrs

# group cond and blocks in arrays
_if     = (cond, block, elses) ->
    elses.conds .unshift cond
    elses.blocks.unshift block
    return new If(elses.conds, elses.blocks)

# group cond and blocks in arrays
_elseif = (cond, block, elses) ->
    elses.conds .unshift cond
    elses.blocks.unshift block
    return elses

# group cond and blocks in arrays
_else = (block) ->
    return
        conds: [null]
        blocks: [block]

_incr = (type, value) ->
    return switch type 
        when 0 then new Op(INCR , value)
        when 1 then new Op(INCR_, value) 

_decr = (type, value) ->
    return switch type 
        when 0 then new Op(DECR , value)
        when 1 then new Op(DECR_, value) 