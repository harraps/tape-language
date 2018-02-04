### CLASS ###
class Tape

    # create a new TAPE
    constructor: -> console.log "[TAPE!]"

    # initialize the tape with the define instruction
    init: (@type) ->
        # array : store the data
        # byte  : keep number in the expected range
        # index : index the array
        if @type == 16
            @array = new Int16Array 0x10000
            @byte  = new Int16Array       1
            @index = new Uint16Array      1
        else
            @array = new Int8Array 0x100
            @byte  = new Int8Array     1
            @index = new Uint8Array    1
        return @type
    
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

# generate a string of tabs
strTabs = (tabs) ->
    str = ""
    str += '\t' for [0 ... tabs]
    return str

### OPERATORS ###
op =
    getName: (fun) -> name if fun2 == fun for name, fun2 of @

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
actions.WAIT = (v) -> 
    setTimeout(v)
    return null

# play a bell sound of given note
actions.BELL = (v) -> 
    console.log(v)
    return null

# print the character in the console
actions.PRINT = (v) -> 
    console.log(v)

### NODES TYPES ###
types = {}

# classes that define the nodes of our AST
class Node 
    string: (tabs) -> strTabs(tabs) + "[UNDEFINED!]\n"

class types.Program extends Node
    constructor: (@def, @funcs) -> super()
    string: (tabs) ->
        str  = "PROGRAM #{@def}:\n"
        str += func.string(0) for func in @funcs
        return str

class types.Function extends Node
    constructor: (@name, @instrs) -> super()
    string: (tabs) ->
        str = if @name != null
        then "FUNCTION #{@name}:\n"
        else "MAIN FUNCTION:\n"
        str += instr.string(1) for instr in @instrs
        return str

# change the value of a cell
class types.Assign extends Node
    constructor: (@var, @val) -> super()
    string: (tabs) -> 
        strTabs(tabs) + "IN:\n"  + @var.string(tabs+1) + 
        strTabs(tabs) + "PUT:\n" + @val.string(tabs+1)

class types.Increment extends Node
    constructor: (@var) -> super()
    string: (tabs) -> strTabs(tabs) + "INCREMENT:\n" + @var.string(tabs+1)

class types.Decrement extends Node
    constructor: (@var) -> super()
    string: (tabs) -> strTabs(tabs) + "DECREMENT:\n" + @var.string(tabs+1)

# do an action
class types.Action extends Node
    constructor: (@act, @val) ->
        super()
        @name = switch @act
            when actions.WAIT  then "WAIT"
            when actions.BELL  then "BELL"
            when actions.PRINT then "PRINT"
    string: (tabs) -> strTabs(tabs) + "ACTION {@act}:\n" + @var.string(tabs+1)

# conditional
class types.If extends Node
    constructor: (@conds, @blocks) -> super()
    string: (tabs) ->
        str = strTabs(tabs) + "IF:\n"
        for [cond, block] in zip(@conds, @blocks)
            str += if cond != null
                strTabs(tabs+1) + "ON CONDITION:\n" + cond .string(tabs+2) +
                strTabs(tabs+1) + "DO:\n"           + block.string(tabs+2)
            else 
                strTabs(tabs+1) "NO CONDITION DO:\n" + block.string(tabs+2)
        return str

# loop
class types.Loop extends Node
    constructor: (@cond, @block) -> super()
    string: (tabs) ->
        return if cond != null
            strTabs(tabs) + "LOOP WHILE:\n" + @cond .string(tabs+1) +
            strTabs(tabs) + "DO:\n"         + @block.string(tabs+1)
        else
            strTabs(tabs) + "LOOP:\n" + @block.string(tabs+1)

class types.Break extends Node
    constructor: (@isStop, @loop) -> super()
    string: (tabs) -> strTabs(tabs) + "BREAK " + if @isStop then "▼" else "▲"

class types.Call extends Node
    constructor: (@name, @params) -> super()
    string: (tabs) -> 
        str = strTabs(tabs) + "CALL #{@name} WITH PARAMS:\n"
        str += param.string(tabs+1) for param in @params

# apply operations to values
class types.Monadic extends Node
    constructor: (@op, @expr) -> super()
    string: (tabs) -> strTabs(tabs) + "MONADIC #{op.getName(@op)}:\n" + @expr.string(tabs+1)

class types.Dyadic extends Node
    constructor: (@op, @left, @right) -> super()
    string: (tabs) -> 
        strTabs(tabs  ) + "DYADIC #{op.getName(@op)}:\n" + 
        strTabs(tabs+1) + "LEFT:\n"  + @left .string(tabs+2) +
        strTabs(tabs+1) + "RIGHT:\n" + @right.string(tabs+2)


### FORMATERS ###
formaters    = {}
functions    = []
program      = null


# program structure
formaters._program = (def, funcs) -> 
    program = new types.Program(def, funcs)
    functions.push(...funcs)
    return funcs

# define the tape structure
formaters._define = (type) -> tape.init type

formaters._functions = (funcs, func) ->
    funcs = funcs or {}
    funcs[func.name] = func
    return funcs

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
formaters._loop = (type, cond, block) ->
    # TODO: look for stops and retries in the inner block
    breaks = []
    return new types.Loop(cond, block)

formaters._break = (type, isStop) ->
    # TODO: find the corresponding loop
    return new types.Break(isStop, null)

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