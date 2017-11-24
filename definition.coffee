# get access to the global scope
GLOBAL = window or exports

class Tape 
    constructor: -> console.log "TAPE CREATED!"
    init: (type) ->
        # used to store the data
        @array = switch type
            when   8 then new Uint8Array  0x100
            when  -8 then new Int8Array   0x100
            when  16 then new Uint16Array 0x10000
            when -16 then new Int16Array  0x10000
        # used for keeping numbers in the expected range
        @byte = switch type
            when   8 then new Uint8Array  1
            when  -8 then new Int8Array   1
            when  16 then new Uint16Array 1
            when -16 then new Int16Array  1
        # used to correctly index the array
        @index = switch Math.abs type
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

# declare a tape
t     = new Tape()
op    = {}
funcs = {}
cls   = {}

GLOBAL.TAPE =
    tape: t
    op:   op
    func: funcs
    inst: cls
    instructions: []

# unary
op.AT   = (i) -> t.g i
op.NOT  = (a) -> unless a then 0 else 1
op.BNOT = (a) -> t.c(~a)
op.INCR = (a) -> t.c(a+1)
op.DECR = (a) -> t.c(a-1)
op.INCR_ = (i) -> 
    t.index[0] = i
    return ++t.array[t.index[0]]
op.DECR_ = (i) -> 
    t.index[0] = i
    return --t.array[t.index[0]]

op.ABS = (a) -> t.c Math.abs a # special case |-128| -> 128 > 127 -> -128
op.NEG = (a) -> t.c(-a)        # we may have only positive numbers
# arithmetic
op.ADD = (a, b) -> t.c(a + b)
op.SUB = (a, b) -> t.c(a - b)
op.MUL = (a, b) -> t.c(a * b)
op.DIV = (a, b) -> t.c(a / b) # if b == 0 -> 0
op.MOD = (a, b) -> t.c(a % b) 
# logical
op.AND  = (a, b) -> if  a &&  b then 1 else 0
op.OR   = (a, b) -> if  a ||  b then 1 else 0
op.XOR  = (a, b) -> if !a != !b then 1 else 0
op.NAND = (a, b) -> if  a &&  b then 0 else 1
op.NOR  = (a, b) -> if  a ||  b then 0 else 1
op.XNOR = (a, b) -> if !a != !b then 0 else 1
# bitwise
op.BAND   = (a, b) -> t.c(a & b)
op.BOR    = (a, b) -> t.c(a | b)
op.BXOR   = (a, b) -> t.c(a ^ b) 
op.BNAND  = (a, b) -> t.c(~(a & b))
op.BNOR   = (a, b) -> t.c(~(a | b))
op.BXNOR  = (a, b) -> t.c(~(a ^ b)) 
op.LSHIFT = (a, b) -> t.c(a << b)
op.RSHIFT = (a, b) -> t.c(a >> b)
# comparator
op.EQU = (a, b) -> if a == b then 1 else 0
op.DIF = (a, b) -> if a != b then 1 else 0
op.GRT = (a, b) -> if a >  b then 1 else 0
op.LST = (a, b) -> if a <  b then 1 else 0
op.GTE = (a, b) -> if a >= b then 1 else 0
op.LSE = (a, b) -> if a <= b then 1 else 0

class Instruction 
    print: -> "instruction undefined"

class Assign extends Instruction
    constructor: (@cell, @value) -> super()
    print: -> "at #{@cell} assign #{@value.print()}"

class Increment extends Instruction
    constructor: (@cell) -> super()
    print: -> "increment value at #{@cell}"

class Decrement extends Instruction
    constructor: (@cell) -> super()
    print: -> "decrement value at #{@cell}"

class Flag extends Instruction
    constructor: (@id) -> super()
    print: -> "flag #{@id.print()}"

class Goto extends Instruction
    constructor: (@id) -> super()
    print: -> "go to flag #{@id.print()}"

class Print extends Instruction
    constructor: (@type, @value, @range) -> super()
    print: -> switch @type
        when 0 then "display #{@value.print()}" # display
        when 1 then "print #{@value.print()}"   # print char
        when 2 then "print starting at #{@value.print()} 
            up to #{@range.print()} characters" # print range

class If extends Instruction
    constructor: (@conds, @blocks) -> super()
    print: ->
        strings = []
        for [cond, block] in zip(@conds, @blocks)
            strings.push("if #{cond.print()} then do #{block.print()} \n")
        return strings.join()

class Loop extends Instruction
    constructor: (@cond, @block) -> super()
    print: -> "loop while #{@cond.print()} and do #{block.print()}"

class Stop extends Instruction
    print: -> "stop"

class Op 
    constructor: (@op, @left, @right) ->
    print: -> "operate #{@op} on #{@left.print()} and #{@right.print()}"

cls.Assign    = Assign
cls.Increment = Increment
cls.Decrement = Decrement
cls.Flag      = Flag
cls.Goto      = Goto
cls.Print     = Print
cls.If        = If
cls.Loop      = Loop
cls.Stop      = Stop
cls.Op        = Op


funcs._program = (def, instrs) -> GLOBAL.TAPE.instructions = instrs
funcs._define  = (value) -> t = t.init value
funcs._instrs  = (instrs, instr) ->
    instrs = instrs or []
    instrs.push instr
    return instrs

# group cond and blocks in arrays
funcs._if     = (cond, block, elses) ->
    if elses?
        elses.conds .unshift cond
        elses.blocks.unshift block
    else return new If([cond], [block])
    return new If(elses.conds, elses.blocks)

# group cond and blocks in arrays
funcs._elseif = (cond, block, elses) ->
    if elses?
        elses.conds .unshift cond
        elses.blocks.unshift block
    else return
        conds:  [cond]
        blocks: [block]
    return elses

# group cond and blocks in arrays
funcs._else = (block) ->
    return
        conds:  [null]
        blocks: [block]

funcs._incr = (type, value) ->
    return switch type 
        when 0 then new Op(op.INCR , value)
        when 1 then new Op(op.INCR_, value) 

funcs._decr = (type, value) ->
    return switch type 
        when 0 then new Op(op.DECR , value)
        when 1 then new Op(op.DECR_, value) 

# TODO
parseBinary = (string) -> parseInt(string)

funcs._number = (type, value) ->
    return switch type
        when "decimal"     then parseInt(value)
        when "octal"       then parseInt('0' + value)
        when "hexadecimal" then parseInt('0x' + value)
        when "binary"      then parseBinary(value)
        else 0