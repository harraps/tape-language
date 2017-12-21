### CLASS ###
class Tape

    # create a new TAPE
    constructor: -> console.log "TAPE CREATED!"

    # initialize the tape with the define instruction
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
    convert: (x) ->
        @byte[0] = x 
        return @byte[0]
    
    # set the value in the array
    set: (i, x) -> 
        @index[0] = i
        @array[@index[0]] = x
        return null
    
    # get the value from the array
    get: (i) ->
        @index[0] = i
        return @array[@index[0]]

    # increment and decrement a value
    incr: (i) ->
        @index[0] = i
        return ++@array[@index[0]]
    decr: (i) ->
        @index[0] = i
        return --@array[@index[0]]

# we need an instance of tape
tape = new Tape()


### OPERATORS ###
op = {}

# unary
op.AT    = (i) -> tape.get i
op.NOT   = (a) -> unless a then 0 else 1
op.BNOT  = (a) -> tape.convert(~a)
op.INCR  = (a) -> tape.convert(a+1)
op.DECR  = (a) -> tape.convert(a-1)
op.INCR_ = (i) -> tape.incr i
op.DECR_ = (i) -> tape.decr i
op.ABS   = (a) -> tape.convert Math.abs a # special case |-128| -> 128 > 127 -> -128
op.NEG   = (a) -> tape.convert(-a)        # we may have only positive numbers
# arithmetic
op.ADD = (a, b) -> tape.convert(a + b)
op.SUB = (a, b) -> tape.convert(a - b)
op.MUL = (a, b) -> tape.convert(a * b)
op.DIV = (a, b) -> tape.convert(a / b) # if b == 0 -> 0
op.MOD = (a, b) -> tape.convert(a % b) 
# logical
op.AND  = (a, b) -> if  a &&  b then 1 else 0
op.OR   = (a, b) -> if  a ||  b then 1 else 0
op.XOR  = (a, b) -> if !a != !b then 1 else 0
op.NAND = (a, b) -> if  a &&  b then 0 else 1
op.NOR  = (a, b) -> if  a ||  b then 0 else 1
op.XNOR = (a, b) -> if !a != !b then 0 else 1
# bitwise
op.BAND   = (a, b) -> tape.convert(a & b)
op.BOR    = (a, b) -> tape.convert(a | b)
op.BXOR   = (a, b) -> tape.convert(a ^ b) 
op.BNAND  = (a, b) -> tape.convert(~(a & b))
op.BNOR   = (a, b) -> tape.convert(~(a | b))
op.BXNOR  = (a, b) -> tape.convert(~(a ^ b)) 
op.LSHIFT = (a, b) -> tape.convert(a << b)
op.RSHIFT = (a, b) -> tape.convert(a >> b)
# comparator
op.EQU = (a, b) -> if a == b then 1 else 0
op.DIF = (a, b) -> if a != b then 1 else 0
op.GRT = (a, b) -> if a >  b then 1 else 0
op.LST = (a, b) -> if a <  b then 1 else 0
op.GTE = (a, b) -> if a >= b then 1 else 0
op.LSE = (a, b) -> if a <= b then 1 else 0


### ACTION ###
actions = {}

# wait the given number of milliseconds before continuing
actions.WAIT = (v, f) -> 
    setTimeout(f, v)
    return null

# play a bell sound of given note
actions.BELL = (v, s) -> 
    s.Play()
    return null

# display the value in the console
actions.DISPLAY = (v) -> 
    console.log(v)

# print the character in the console
actions.PRINT = (v) -> 
    console.log(v)


### NODES TYPES ###
types = {}

# classes that define the nodes of our AST
class Node 
    print: -> "Node undefined"

# change the value of a cell
class types.Assign extends Node
    constructor: (@cell, @value) -> super()
    print: -> "at #{@cell} assign #{@value.print()}"
class types.Increment extends Node
    constructor: (@cell) -> super()
    print: -> "increment value at #{@cell}"
class types.Decrement extends Node
    constructor: (@cell) -> super()
    print: -> "decrement value at #{@cell}"

# navigate through the program
class types.Flag extends Node
    constructor: (@id) -> super()
    print: -> "flag #{@id.print()}"
class types.Goto extends Node
    constructor: (@id) -> super()
    print: -> "go to flag #{@id.print()}"

# do an action
class types.Action extends Node
    constructor: (@action, @value) -> super()
    print: -> "do action {@action} with value {@value}"

# apply operations to values
class types.Monadic extends Node
    constructor: (@op, @expr) -> super()
    print: -> "operate #{@op} on #{@expr}"
class types.Dyadic extends Node
    constructor: (@op, @left, @right) -> super()
    print: -> "operate #{@op} on #{@left.print()} and #{@right.print()}"

# conditional
class types.If extends Node
    constructor: (@conds, @blocks) -> super()
    print: ->
        strings = []
        for [cond, block] in zip(@conds, @blocks)
            strings.push("if #{cond.print()} then do #{block.print()} \n")
        return strings.join()

# loop
class types.Loop extends Node
    constructor: (@cond, @block, @breaks) -> super()
    print: -> "loop while #{@cond.print()} and do #{block.print()}"
class types.Break extends Node
    constructor: (@isStop) -> super()
    print: -> "stop the loop #{@loop}"


### FORMATERS ###
formaters = {}
instructions = []

# program structure
formaters._program = (def, instrs) -> 
    instructions.push(...instrs)
    return instrs
formaters._define = (value) -> 
    tape.init value
    return null
formaters._instructions = (instrs, instr) ->
    instrs = instrs or []
    instrs.push instr
    return instrs

# change values
formaters._incr = (type, value) ->
    return switch type 
        when 0 then new types.Monadic(op.INCR , value)
        when 1 then new types.Monadic(op.INCR_, value) 
formaters._decr = (type, value) ->
    return switch type 
        when 0 then new types.Monadic(op.DECR , value)
        when 1 then new types.Monadic(op.DECR_, value) 

# conditionals
formaters._if = (cond, block, elses) ->
    if elses?
        elses.conds .unshift cond
        elses.blocks.unshift block
    else return new types.If([cond], [block])
    return new types.If(elses.conds, elses.blocks)
formaters._elseif = (cond, block, elses) ->
    if elses?
        elses.conds .unshift cond
        elses.blocks.unshift block
    else return
        conds:  [cond]
        blocks: [block]
    return elses
formaters._else = (block) ->
    return
        conds:  [null]
        blocks: [block]

# loops
formaters._loop = (cond, block) ->
    # TODO: look for stops and retries in the inner block
    breaks = []
    return new types.Loop(cond, block, breaks)


# parse the numbers
parseBinary = (string) -> parseInt(string)
formaters._number = (type, value) ->
    return switch type
        when "decimal"     then parseInt(value)
        when "octal"       then parseInt('0' + value)
        when "hexadecimal" then parseInt('0x' + value)
        when "binary"      then parseBinary(value)
        else 0

# store our functions into the global scope
GLOBAL = window or exports
GLOBAL.TAPE = {tape, op, types, formaters, actions, instructions}