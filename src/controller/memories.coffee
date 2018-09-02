### MEMORY TYPES ###
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
	get: (i) -> @array[TAPE.corrector.unsign(i) % @type]
	set: (i, x) ->
		i = TAPE.corrector.unsign(i) % @type
		@array[i] = x
	incr: (i) ->
		i = TAPE.corrector.unsign(i) % @type
		++@array[i]
	decr: (i) ->
		i = TAPE.corrector.unsign(i) % @type
		--@array[i]
	repl: (i, x, op) ->
		i = TAPE.corrector.unsign(i) % @type
		@array[i] = op @array[i], x

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
		reg = new memory.Register @type
		length = Math.min @type, params?.length ? 0
		for i in [0...length]
			reg.set i, params[i]
		return reg

	# access the array
	get: (i) -> @array[TAPE.corrector.unsign i]
	set: (i, x) ->
		i = TAPE.corrector.unsign i
		@array[i] = x
		TAPE.updateCell? i, x
	incr: (i) ->
		i = TAPE.corrector.unsign i
		TAPE.updateCell? i, ++@array[i]
	decr: (i) ->
		i = TAPE.corrector.unsign i
		TAPE.updateCell? i, --@array[i]
	repl: (i, x, op) ->
		i = TAPE.corrector.unsign i
		y = op @array[i], x
		@array[i] = y
		TAPE.updateCell? i, y
