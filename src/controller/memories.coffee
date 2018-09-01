corrector### MEMORY TYPES ###
memory = {}

class memory.Register
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

    # access the array
    get: (i) -> @array[TAPE.corrector.uint(i) % @type]
    set: (i, x) ->
        i = TAPE.corrector.uint(i) % @type
        @array[i] = x
    incr: (i) ->
        i = TAPE.corrector.uint(i) % @type
        ++@array[i]
    decr: (i) ->
        i = TAPE.corrector.uint(i) % @type
        --@array[i]

class memory.Tape
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

    # make a register for a function
    makeReg: (params) ->
        reg = new structs.Register @type
        length = Math.min @type, params.length
        reg.set(i, params[i]) for i in [0...length]
        return reg

    # access the array
    get: (i) -> @array[TAPE.corrector.uint i]
    set: (i, x) ->
        i = TAPE.corrector.uint i
        @array[i] = x
        TAPE.updateCell? i, x
    incr: (i) ->
        i = TAPE.corrector.uint i
        TAPE.updateCell? i, ++@array[i]
    decr: (i) ->
        i = TAPE.corrector.uint i
        TAPE.updateCell? i, --@array[i]
