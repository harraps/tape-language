
# conver javascript numbers into expected format
CONVERTER =
    signedCell: null
    unsignedCell: null
    init: (type) ->
        if type == 16
            @signedCell   = new Int16Array  1
            @unsignedCell = new Uint16Array 1
        else
            @signedCell   = new Int8Array   1
            @unsignedCell = new Uint8Array  1
    int: (v) ->
        @signedCell[0] = v
        return @signedCell[0]
    uint: (v) ->
        @unsignedCell[0] = v
        return @unsignedCell[0]

# implementation of Python zip function
zip = () ->
  lengthArray = (arr.length for arr in arguments)
  length = Math.min(lengthArray...)
  for i in [0...length]
    arr[i] for arr in arguments

### CLASS ###
structs = {}

class structs.Register
    constructor: (type) ->
        # array : store the data
        # byte  : keep number in the expected range
        # index : index the array
        if type == 16
            @array = new Int16Array 16
            @type  = 16
        else
            @array = new Int8Array  8
            @type  = 8
        # index of the cell that have been modified
        @modifed = null
    
    _modif: (i) -> @modified = CONVERTER.uint(i) % @type

    # access the array
    get: (i) -> @array[CONVERTER.uint(i) % @type]
    set: (i, x) -> 
        @_modif i
        @array[@edited] = x
    incr: (i) -> 
        @_modif i
        ++@array[@edited]
    decr: (i) ->
        @_modif i
        --@array[@edited]

class structs.Tape
    constructor: (type) ->
        # array : store the data
        # byte  : keep number in the expected range
        # index : index the array
        if type == 16
            @array = new Int16Array 0x10000
            @type  = 16
        else
            @array = new Int8Array 0x100
            @type  = 8
        # index of the cell that have been modified
        @modifed = null
    
    _modif: (i) -> @modified = CONVERTER.uint i
    
    # make a register for a function
    makeReg: (params) -> 
        reg = new structs.Register @type
        length = Math.min @type, params.length
        reg.set(i, params[i]) for i in [0...length]
        return reg
    
    # access the array
    get: (i) -> @array[CONVERTER.uint i]
    set: (i, x) -> 
        @_modif i
        @array[@edited] = x
    incr: (i) -> 
        @_modif i
        ++@array[@edited]
    decr: (i) ->
        @_modif i
        --@array[@edited]

### OPERATORS ###
op =
    getName: (fun) -> name if fun2 == fun for name, fun2 of @

# unary
op.NOT   = (a) -> unless a then 0 else 1
op.BNOT  = (a) -> CONVERTER.int(~a)
op.ABS   = (a) -> CONVERTER.int Math.abs a # special case |-128| -> 128 > 127 -> -128
op.NEG   = (a) -> CONVERTER.int(-a)        # we may have only positive numbers
# arithmetic
op.ADD = (a, b) -> CONVERTER.int(a + b)
op.SUB = (a, b) -> CONVERTER.int(a - b)
op.MUL = (a, b) -> CONVERTER.int(a * b)
op.DIV = (a, b) -> CONVERTER.int(a / b) # if b == 0 -> 0
op.MOD = (a, b) -> CONVERTER.int(a % b) 
# logical
op.AND  = (a, b) -> if  a &&  b then 1 else 0
op.OR   = (a, b) -> if  a ||  b then 1 else 0
op.XOR  = (a, b) -> if !a != !b then 1 else 0
op.NAND = (a, b) -> if  a &&  b then 0 else 1
op.NOR  = (a, b) -> if  a ||  b then 0 else 1
op.XNOR = (a, b) -> if !a != !b then 0 else 1
# bitwise
op.BAND   = (a, b) -> CONVERTER.int(a & b)
op.BOR    = (a, b) -> CONVERTER.int(a | b)
op.BXOR   = (a, b) -> CONVERTER.int(a ^ b) 
op.BNAND  = (a, b) -> CONVERTER.int(~(a & b))
op.BNOR   = (a, b) -> CONVERTER.int(~(a | b))
op.BXNOR  = (a, b) -> CONVERTER.int(~(a ^ b)) 
op.LSHIFT = (a, b) -> CONVERTER.int(a << b)
op.RSHIFT = (a, b) -> CONVERTER.int(a >> b)
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
    v = CONVERTER.uint v
    setTimeout(v)
    return null

# play a bell sound of given note
actions.BELL = (v) -> 
    v = CONVERTER.uint v
    console.log(v)
    return null

# print the character in the console
actions.PRINT = (v) -> 
    v = CONVERTER.uint v
    console.log(v)
    return null

### NODES TYPES ###
types = {}

# classes that define the nodes of our AST
class Node 
    link:   ()     -> console.log "not implemented"
    run:    ()     -> console.log "not implemented"
    string: (tabs) -> strTabs(tabs) + "[UNDEFINED!]\n"

# helper functions to print the AST
strTabs = (tabs) ->
    str  = ""
    str += '\t' for [0 ... tabs]
    return str
stringBlock = (tabs, block) ->
    str  = ""
    str += e.string(tabs) for e in block
    return str
strNode = (tabs, n) ->
    return if n is Node then n.string(tabs) else strTabs(tabs) + n + "\n"

# program
class types.Program extends Node
    constructor: (@def, @funcs) -> 
        super()
        # correct the definition if there was an error
        if @def != 8 and @def != 16 then @def = 8
        # generate a new tape using the definition provided
        @tape = new structs.Tape @def
        # provide a pointer to the program to every node of the tree
        func.link @ for name, func of @funcs

    string: (tabs) -> "PROGRAM #{@def}:\n" + stringBlock(0, @funcs)
    run: (...params) -> @funcs[null].run @, params

# declare a function
class types.Function extends Node
    constructor: (@name, @block) ->
        super()
        @returnValue = 0

    link: (@program) ->
        instr.link @program for instr in @block

    string: (tabs) ->
        # print function name and content
        str = if @name != null
        then "FUNCTION #{@name}:\n"
        else "MAIN FUNCTION:\n"
        str += stringBlock tabs, @block
        return str

    run: (params) ->
        # generate a register for the function
        reg = @program.tape.makeReg params
        # execute instructions
        instr.run reg for instr in @block
        return @returnValue

class types.Return extends Node
    constructor: (@val) ->
        super()
        @func = null

    link: (@program) ->

    string: (tabs) ->

    run: (reg) ->
        @func.returnValue = if @val is Node then @val.run reg else @val

# access a variable
class types.Variable extends Node
    constructor: (@useReg, @ind) -> super()
    link: (@program) -> @ind.link @program if @ind is Node

    string: (tabs) ->
        str = stringTabs(tabs) + if @useReg then "REGISTER:\n" else "TAPE:\n"
        return str + strNode tabs+1, @ind

    index: (reg) -> if @ind is Node then @ind.run reg else @ind
    run:   (reg) ->
        index = @index reg
        return if @useReg then reg.get index else @program.tape.get index
        


# change the value of a cell
class types.Assign extends Node
    constructor: (@var, @val) -> super()
    link: (@program) ->
        @var.link @program if @var is Node
        @val.link @program if @val is Node

    string: (tabs) -> 
        strTabs(tabs) + "IN:\n"  + strNode(tabs+1, @var) + 
        strTabs(tabs) + "PUT:\n" + strNode(tabs+1, @val)
    
    run: (reg) ->
        ind = @var.index reg
        val = if @val is Node then @val.run reg else @val
        if @var.useReg then reg.set ind, val else @program.tape.set ind, val

class types.SelfAssign extends Node
    constructor: (@var, @val, @op) -> super()
    string: (tabs) ->
        strTabs(tabs) + "CHANGE:\n"                + @var.string(tabs+1) +
        strTabs(tabs) + "BY #{op.getName(@op)}:\n" + @val.string(tabs+1)
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
    link: (@program) ->
    string: (tabs) -> strTabs(tabs) + "ACTION {@act}:\n" + @var.string(tabs+1)
    run: (reg) ->
        val = if @val is Node then @val.run reg else @val
        @act val

# conditional
class types.If extends Node
    constructor: (@conds, @blocks) ->
        super()
        if @conds.length != @blocks.length
            console.log "error in if statement"
    
    link: (@program) ->
        for cond in @conds
            cond.link @program if cond? and cond.link?()
        for block in @blocks
            if block?
                instr.link @program for instr in block
    
    string: (tabs) ->
        str = strTabs(tabs) + "IF:\n"
        for [cond, block] in zip(@conds, @blocks)
            str += if cond?
            then strTabs(tabs+1) + "ON CONDITION:\n" + cond.string(tabs+2) + strTabs(tabs+1) + "DO:\n"
            else strTabs(tabs+1) + "NO CONDITION DO:\n"
            str += stringBlock(tabs+2, block)
        return str
    
    run: (reg) ->
        for [cond, block] in zip(@conds, @blocks)
            val = if cond is Node then cond.run reg else cond
            unless val == 0
                if block?
                    instr.run reg for instr in block
                    break

# loop
class types.Loop extends Node
    constructor: (@cond, @block, @loopType) ->
        super()
        @stopLoop = 0

    link: (@program) ->
        @cond.link @program if  @cond is Node
        instr.link @program for instr in @block

    string: (tabs) ->
        return if cond != null
            strTabs(tabs) + "LOOP WHILE:\n" + @cond .string(tabs+1) +
            strTabs(tabs) + "DO:\n"         + @block.string(tabs+1)
        else
            strTabs(tabs) + "LOOP:\n" + @block.string(tabs+1)

    run: (reg) ->
        val = if @cond? and @cond.run?() then @cond.run reg else @cond
        until val == 0
            for instr in @block
                instr.run reg if instr? and instr.run?()
                if  @stopLoop !=  0 then break
            if      @stopLoop ==  1 then continue
            else if @stopLoop == -1 then break
            val = if @cond? and @cond.run?() then @cond.run reg else @cond
        @stopLoop = 0 # does it work with recursive function call ?

class types.Break extends Node
    constructor: (@isStop, @loopType) ->
        super()
        @loop = null

    link: (@program) ->

    string: (tabs) -> strTabs(tabs) + "BREAK " + if @isStop then "▼" else "▲"

    run: (reg) ->
        @loop.stopLoop = if @isStop then -1 else 1

# call function
class types.Call extends Node
    constructor: (@name, @params) ->
        super()
        @func = null

    link: (@program) ->
        @func = func if name == @name for name, func in @program.funcs
        if @func == null then console.log "function not found !"

    string: (tabs) -> strTabs(tabs) + "CALL #{@name} WITH PARAMS:\n" + stringBlock(tabs+1, @params)

    run: (reg) -> @func.run @params

# apply operations to values
class types.Monadic extends Node
    constructor: (@op, @expr) -> super()

    string: (tabs) -> strTabs(tabs) + "MONADIC #{op.getName(@op)}:\n" + @expr.string(tabs+1)

class types.Dyadic extends Node
    constructor: (@op, @left, @right) -> super()
    string: (tabs) ->
        strTabs(tabs  ) + "DYADIC #{op.getName(@op)}:\n" + 
        strTabs(tabs+1) + "LEFT:\n"  + strExpr(tabs+2, @left ) +
        strTabs(tabs+1) + "RIGHT:\n" + strExpr(tabs+2, @right)


### FORMATERS ###
formaters = {}

# store our functions into the global scope
GLOBAL = exports ? this
GLOBAL.TAPE = {op, types, formaters, actions, structs}

# program structure
formaters._program = (def, funcs) ->
    CONVERTER.init def
    program = new types.Program(def, funcs)
    GLOBAL.TAPE.program = program
    return program

# define the tape structure
formaters._define = (type) -> tape.init type

# gather functions
formaters._functions = (funcs, func) ->
    funcs = funcs or {}
    funcs[func.name] = func
    return funcs

# gather instructions
formaters._instructions = (instrs, instr) ->
    instrs = instrs or []
    instrs.push instr
    return instrs

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
findBreaks = (lp, block) ->
    for instr in block
        if instr is types.If
            findBreaks(lp.loopType, b) for b in instr.blocks
        else if instr is types.Break and instr.loopType == lp.loopType
            instr.loop = lp
        else if instr is types.Loop  and instr.loopType != lp.loopType
            findBreaks(lp.loopType, instr.block)
formaters._loop = (type, cond, block) ->
    lp = new types.Loop(cond, block, type)
    findBreaks lp, block
    return lp

# parse number
formaters._number = (type, value) ->
    val = value.substring 2
    return switch type
        when "decimal"     then parseInt(value)
        when "octal"       then parseInt(val,  8)
        when "hexadecimal" then parseInt(val, 16)
        when "binary"      then parseInt(val,  2)
        when "character"   then value.charCodeAt(1)
        else 0