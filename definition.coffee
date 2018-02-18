
# conver javascript numbers into expected format
CONVERTER =
    signedCell: null
    unsignedCell: null
    audioFactor: 1
    init: (type) ->
        if type == 16
            @signedCell   = new Int16Array  1
            @unsignedCell = new Uint16Array 1
            @audioFactor  = 1
        else
            @signedCell   = new Int8Array   1
            @unsignedCell = new Uint8Array  1
            @audioFactor  = 10
    int: (v) ->
        @signedCell[0] = v
        return @signedCell[0]
    uint: (v) ->
        @unsignedCell[0] = v
        return @unsignedCell[0]
    audio: (n) ->
        @unsignedCell[0] = n
        return @unsignedCell[0] * @audioFactor

# sleep function called with 'await sleep(ms)'
sleep = (ms) ->
  new Promise (resolve) ->
    window.setTimeout resolve, ms

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
    new Promise (resolve) ->
        window.setTimeout resolve, CONVERTER.uint(v)

# play a bell sound of given note
actions.BELL = (v) -> 
    PLAY_SOUND CONVERTER.audio v

# print the character in the console
actions.PRINT = (v) ->
    ADD_CHAR String.fromCharCode(CONVERTER.uint v)

### NODES TYPES ###
types = {}

# classes that define the nodes of our AST
class Node 
    link: () -> console.log "not implemented"
    run:  () -> console.log "not implemented"
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
    return n.string?(tabs) ? strTabs(tabs) + n + "\n"

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
        instr.link?(@program, @) for instr in @block
        return null

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
        await instr.run reg for instr in @block
        return @returnValue

class types.Return extends Node
    constructor: (@val) ->
        super()
        @func = null

    link: (@program, @func) -> @val.link?(@program, @func)

    string: (tabs) ->
        strTabs(tabs) + "RETURN:\n" + strNode(tabs+1, @val)

    run: (reg) -> @func.returnValue = await @val.run?(reg) ? @val
        

# access a variable
class types.Variable extends Node
    constructor: (@useReg, @ind) -> super()
    link: (@program, @func) -> @ind.link?(@program, @func)

    string: (tabs) ->
        str = stringTabs(tabs) + if @useReg then "REGISTER:\n" else "TAPE:\n"
        return str + strNode tabs+1, @ind

    index: (reg) -> await @ind.run?(reg) ? @ind

    run: (reg) -> await @get reg
        
    get: (reg) -> # get the value of the variable
        index = await @index reg
        return if @useReg then reg.get index else @program.tape.get index

    set: (reg, val) ->
        index = await @index reg
        if @useReg then reg.set(index, val) else @program.tape.set(index, val)
        return null

    incr: (reg) ->
        index = await @index reg
        if @useReg then reg.incr index else @program.tape.incr index
        return null
    
    decr: (reg) ->
        index = await @index reg
        if @useReg then reg.decr index else @program.tape.decr index
        return null


# change the value of a cell
class types.Assign extends Node
    constructor: (@var, @val) -> super()
    link: (@program, @func) ->
        @var.link?(@program, @func)
        @val.link?(@program, @func)

    string: (tabs) -> 
        strTabs(tabs) + "IN:\n"  + strNode(tabs+1, @var) + 
        strTabs(tabs) + "PUT:\n" + strNode(tabs+1, @val)
    
    run: (reg) ->
        ind = @var.index reg
        val = await @val.run?(reg) ? @val
        @var.set ind, val


class types.SelfAssign extends Node
    constructor: (@var, @val, @op) -> super()
    link: (@program, @func) ->
        @var.link?(@program, @func)
        @val.link?(@program, @func)

    string: (tabs) ->
        strTabs(tabs) + "CHANGE:\n"                + @var.string(tabs+1) +
        strTabs(tabs) + "BY #{op.getName(@op)}:\n" + @val.string(tabs+1)

    run: (reg) ->
        ind  = @var.index reg
        val1 = @var.get   reg
        val2 = await @val.run?(reg) ? @val
        val3 = @op val1, val2
        @var.set ind, @op(val1, val2)

class types.Increment extends Node
    constructor: (@var) -> super()
    link: (@program, @func) -> @var.link?(@program, @func)
    string: (tabs) -> strTabs(tabs) + "INCREMENT:\n" + @var.string(tabs+1)
    run: (reg) -> await @var.incr reg
    
class types.Decrement extends Node
    constructor: (@var) -> super()
    link: (@program, @func) -> @var.link?(@program, @func)
    string: (tabs) -> strTabs(tabs) + "DECREMENT:\n" + @var.string(tabs+1)
    run: (reg) -> await @var.decr reg

# do an action
class types.Action extends Node
    constructor: (@act, @val) ->
        super()
        @name = switch @act
            when actions.WAIT  then "WAIT"
            when actions.BELL  then "BELL"
            when actions.PRINT then "PRINT"
    link: (@program, @func) -> @val.link?(@program, @func)
    string: (tabs) -> strTabs(tabs) + "ACTION {@act}:\n" + @var.string(tabs+1)
    run: (reg) ->
        val = await @val.run?(reg) ? @val
        return await @act val

# conditional
class types.If extends Node
    constructor: (@conds, @blocks) ->
        super()
        if @conds.length != @blocks.length
            console.log "error in if statement"
    
    link: (@program, @func) ->
        for cond in @conds
            cond.link?(@program, @func)
        for block in @blocks
            if block?
                instr.link?(@program, @func) for instr in block
    
    string: (tabs) ->
        str = strTabs(tabs) + "IF:\n"
        for [cond, block] in zip(@conds, @blocks)
            str += if cond?
            then strTabs(tabs+1) + "ON CONDITION:\n" + cond.string(tabs+2) + strTabs(tabs+1) + "DO:\n"
            else strTabs(tabs+1) + "NO CONDITION DO:\n"
            str += stringBlock(tabs+2, block)
        return str
    
    run: (reg) ->
        i = 0
        while i < @conds.length
            cond  = @conds[i]
            block = @blocks[i++]
            val = await cond.run?(reg) ? cond
            unless val == 0
                if block?
                    await instr.run reg for instr in block
                    break

# loop
class types.Loop extends Node
    constructor: (@cond, @block, @loopType) ->
        super()
        @stopLoop = 0

    link: (@program, @func) ->
        @cond.link?(@program, @func)
        instr.link?(@program, @func) for instr in @block

    string: (tabs) ->
        return if cond != null
            strTabs(tabs) + "LOOP WHILE:\n" + @cond .string(tabs+1) +
            strTabs(tabs) + "DO:\n"         + @block.string(tabs+1)
        else
            strTabs(tabs) + "LOOP:\n" + @block.string(tabs+1)

    run: (reg) ->
        val = await @cond.run?(reg) ? @cond
        until val == 0
            for instr in @block
                await instr.run?(reg)
                if  @stopLoop !=  0 then break
            if      @stopLoop ==  1 then continue
            else if @stopLoop == -1 then break
            val = await @cond.run?(reg) ? @cond
        @stopLoop = 0 # does it work with recursive function call ?

class types.Break extends Node
    constructor: (@isStop, @loopType) ->
        super()
        @loop = null

    link: (@program, @func) ->

    string: (tabs) -> strTabs(tabs) + "BREAK " + if @isStop then "▼" else "▲"

    run: (reg) ->
        @loop.stopLoop = if @isStop then -1 else 1

# call function
class types.Call extends Node
    constructor: (@name, @params) ->
        super()
        @params = @params or []
        @call = null

    # prepare a pointer to the function to call
    # reduce a part of the AST if useless
    link: (@program, @func) ->
        for name of @program.funcs
            @call = @program.funcs[name] if name == @name
        if @call == null then console.log "function not found !"
        @params.splice @program.def, @params.length
        for param in @params
            param.link?(@program, @func)

    string: (tabs) -> strTabs(tabs) + "CALL #{@name} WITH PARAMS:\n" + stringBlock(tabs+1, @params)

    run: (reg) -> await @call.run?(@params)

# apply operations to values
class types.Monadic extends Node
    constructor: (@op, @expr) -> super()

    link: (@program, @func) -> @expr.link?(@program, @func)

    string: (tabs) -> strTabs(tabs) + "MONADIC #{op.getName(@op)}:\n" + @expr.string(tabs+1)

    run: (reg) ->
        val = await @expr.run?(reg) ? @expr 
        @op val

class types.Dyadic extends Node
    constructor: (@op, @left, @right) -> super()

    link: (@program, @func) ->
        @left .link?(@program, @func)
        @right.link?(@program, @func)

    string: (tabs) ->
        strTabs(tabs  ) + "DYADIC #{op.getName(@op)}:\n" + 
        strTabs(tabs+1) + "LEFT:\n"  + strExpr(tabs+2, @left ) +
        strTabs(tabs+1) + "RIGHT:\n" + strExpr(tabs+2, @right)
    
    run: (reg) ->
        left  = await @left.run?(reg)  ? @left
        right = await @right.run?(reg) ? @right 
        @op left, right

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

# gather functions
formaters.namedGather = (map, element) ->
    map = map or {}
    map[element.name] = element
    return map

# gather a list of elements
formaters.gather = (list, element) ->
    list = list or []
    list.push element
    return list

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
        conds:  [true]
        blocks: [block]

formaters._callDyadic = (name, params, param) ->
    fullList = @_callDyadicList name, params, param
    delete params.name
    return new types.Call name, params

formaters._callDyadicList = (name, params, param) ->
    if params instanceof Array # list of params
        if params.name == name # same operator
            params.push param
            return params
        else # different operators
            newList = [new types.Call(params.name, params), param]
            delete params.name
            newList.name = name
            return newList
    else # single param
        newList = [params, param]
        newList.name = name
        return newList

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