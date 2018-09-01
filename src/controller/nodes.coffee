### NODES TYPES ###
node = {}

# classes that define the nodes of our AST
class Node
    link: () -> console.log "not implemented"
    run:  () -> console.log "not implemented"
    string: (tabs) -> str_tabs(tabs) + "[UNDEFINED!]\n"

# helper functions to print the AST
str_tabs = (tabs) ->
    str  = ""
    str += '\t' for [0 ... tabs]
    return str
str_block = (tabs, block) ->
    str  = ""
    str += e.string tabs for e in block
    return str
str_node = (tabs, n) -> n.string?(tabs) ? (str_tabs tabs + n + "\n")


### AST NODES ###

### Base ###

# program
class node.Program extends Node
    constructor: (@def, @funcs) ->
        super()
        # correct the definition if there was an error
        if @def isnt 8 and @def isnt 16 then @def = 8
        # generate a new tape using the definition provided
        @tape = new TAPE.memory.Tape @def
        # provide a pointer to the program to every node of the tree
        for name of @funcs
            @funcs[name].link @

    run: (...params) -> @funcs[null].run @, params

	string: (tabs) -> "PROGRAM #{@def}:\n" + str_block 0, @funcs

# declare a function
class node.Function extends Node
    constructor: (@name, @block) ->
        super()
        @returnValue = 0

    link: (@program) ->
        instr.link? @program,this for instr in @block
        return null

    run: (params) ->
        # generate a register for the function
        reg = @program.tape.makeReg params
        # execute instructions
        await instr.run reg for instr in @block
        return @returnValue

	string: (tabs) ->
        # print function name and content
        str = if @name != null
        then "FUNCTION #{@name}:\n"
        else "MAIN FUNCTION:\n"
        str += str_block tabs, @block
        return str

class node.Return extends Node
    constructor: (@val) ->
        super()
        @func = null

    link: (@program, @func) -> @val.link? @program,@func

    run: (reg) -> @func.returnValue = await @val.run?(reg) ? @val

	string: (tabs) -> str_tabs(tabs) + "RETURN:\n" + str_node(tabs+1, @val)


# access a variable
class node.Variable extends Node
    constructor: (@useReg, @ind) -> super()
    link: (@program, @func) -> @ind.link? @program,@func

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

    # special set value for strings
    set_str: (reg, text) ->
        index = await @index reg
        array = if @useReg then reg else @program.tape
        for i in [0...text.length]
            array.set(index+i, text.charCodeAt(i))

	string: (tabs) ->
        str = stringTabs(tabs) + if @useReg then "REGISTER:\n" else "TAPE:\n"
        return str + str_node tabs+1, @ind


### Assignements ###

# change the value of a cell
class node.Assign extends Node
    constructor: (@var, @val) -> super()

    link: (@program, @func) ->
        @var.link? @program,@func
        @val.link? @program,@func

    run: (reg) ->
        val = await @val.run?(reg) ? @val
        @var.set reg, val

	string: (tabs) ->
        str_tabs(tabs) +  "IN:\n" + str_node(tabs+1, @var) +
        str_tabs(tabs) + "PUT:\n" + str_node(tabs+1, @val)

class node.SelfAssign extends Node
    constructor: (@var, @val, @op) -> super()

    link: (@program, @func) ->
        @var.link? @program,@func
        @val.link? @program,@func

    run: (reg) ->
        ind  = @var.index reg
        val1 = @var.get   reg
        val2 = await @val.run?(reg) ? @val
        val3 = @op val1, val2
        @var.set ind, @op(val1, val2)

	string: (tabs) ->
        str_tabs(tabs) + "CHANGE:\n"                + @var.string(tabs+1) +
        str_tabs(tabs) + "BY #{op.getName(@op)}:\n" + @val.string(tabs+1)

class node.Increment extends Node
    constructor: (@var) -> super()
    link:   (@program, @func) -> @var.link? @program,@func
    run:    (reg) -> await @var.incr reg
	string: (tabs) -> str_tabs(tabs) + "INCREMENT:\n" + @var.string(tabs+1)

class node.Decrement extends Node
    constructor: (@var) -> super()
    link:   (@program, @func) -> @var.link? @program,@func
    run:    (reg) -> await @var.decr reg
	string: (tabs) -> str_tabs(tabs) + "DECREMENT:\n" + @var.string(tabs+1)

class node.StringAssign extends Node
    constructor: (@var, @text) -> super()
    link:   (@program, @func) -> @var.link? @program,@func
    run:    (reg) -> await @var.set_str(reg, @text)
	string: (tabs) -> str_tabs(tabs) + "ASSIGN STRING '#{text}':\n" + @var.string(tabs+1)


### Control flow ###

# conditional
class node.If extends Node
    constructor: (@conds, @blocks) ->
        super()
        if @conds.length != @blocks.length
            console.log "error in if statement"

    link: (@program, @func) ->
        for cond in @conds
            cond.link? @program,@func
        for block in @blocks
            if block?
                instr.link? @program,@func for instr in block

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

	string: (tabs) ->
        str = str_tabs(tabs) + "IF:\n"
        i = 0
        while i < @conds.length
            cond  = @conds[i]
            block = @blocks[i++]
            if cond != true # condition declared
                str += str_tabs(tabs+1) + "ON CONDITION:\n" + cond.string(tabs+2) + str_tabs(tabs+1) + "DO:\n"
            else # no condition
                str += str_tabs(tabs+1) + "NO CONDITION DO:\n"
            str += str_block(tabs+2, block)
        return str

# loop
class node.Loop extends Node
    constructor: (@cond, @block, @loopType) ->
        super()
        @stopLoop = 0

    link: (@program, @func) ->
        @cond.link? @program,@func
        instr.link? @program,@func for instr in @block

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

	string: (tabs) ->
        return if cond != null
            str_tabs(tabs) + "LOOP WHILE:\n" + @cond .string(tabs+1) +
            str_tabs(tabs) + "DO:\n"         + @block.string(tabs+1)
        else
            str_tabs(tabs) + "LOOP:\n" + @block.string(tabs+1)

class node.Break extends Node
    constructor: (@isStop, @loopType) ->
        super()
        @loop = null

    link: (@program, @func) ->

    run: (reg) ->
        @loop.stopLoop = if @isStop then -1 else 1

	string: (tabs) -> str_tabs(tabs) + "BREAK " + if @isStop then "▼" else "▲"


### Operations ###

# call function
class node.Call extends Node
    constructor: (@name, @params) ->
        super()
        @params = @params or []
        @call = null

    # prepare a pointer to the function to call
    # reduce a part of the AST if useless
    link: (@program, @func) ->
        for name of @program.funcs
            @call = @program.funcs[name] if name == @name
        unless @call? then console.log "function #{@name} not found !"
        @params.splice @program.def, @params.length
        for param in @params
            param.link? @program,@func

    run: (reg) -> await @call.run?(@params)

	string: (tabs) -> str_tabs(tabs) + "CALL #{@name} WITH PARAMS:\n" + str_block(tabs+1, @params)

# apply operations to values
class node.Monadic extends Node
    constructor: (@op, @expr) -> super()

    link: (@program, @func) -> @expr.link? @program,@func

    run: (reg) ->
        val = await @expr.run?(reg) ? @expr
        @op val

	string: (tabs) -> str_tabs(tabs) + "MONADIC #{TAPE.op.getName(@op)}:\n" + @expr.string(tabs+1)

class node.Dyadic extends Node
    constructor: (@op, @left, @right) -> super()

    link: (@program, @func) ->
        @left .link? @program,@func
        @right.link? @program,@func

    run: (reg) ->
        left  = await @left .run?(reg) ? @left
        right = await @right.run?(reg) ? @right
        @op left, right

	string: (tabs) ->
        str_tabs(tabs  ) + "DYADIC #{TAPE.op.getName(@op)}:\n" +
        str_tabs(tabs+1) +  "LEFT:\n" + strExpr(tabs+2, @left ) +
        str_tabs(tabs+1) + "RIGHT:\n" + strExpr(tabs+2, @right)

# do an action
class node.Action extends Node
    constructor: (@act, @val) ->
        super()

    link: (@program, @func) -> @val.link? @program,@func

    run: (reg) ->
        val = await @val.run?(reg) ? @val
        return await @act val

	string: (tabs) ->
		name = switch @act
            when TAPE.action.wait  then "WAIT"
            when TAPE.action.bell  then "BELL"
            when TAPE.action.print then "PRINT"
		return str_tabs(tabs) + "ACTION #{name}:\n" + @var.string(tabs+1)
