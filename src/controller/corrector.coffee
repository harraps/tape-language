### CORRECTOR ###
corrector = {

	# cells to perform value correction
	sCell: null #   signed cell
	uCell: null # unsigned cell

	# centiseconds
	timeUnit: 10

	# indexed frequencies
	frequencies: [
		440.00, # A
		466.16, # A#
		493.88, # B
		523.25, # C
		554.37, # C#
		587.37, # D
		622.25, # D#
		659.25, # E
		698.46, # F
		739.99, # F#
		783.99, # G
		830.61, # G#
	]

	# initialize the corrector with the program type
	init: (type) ->
		if type == 16
			@timeUnit    = 1  # milliseconds
			@frequencies = null # full range of frequencies
			@sCell = new Int16Array  1
			@uCell = new Uint16Array 1
		else
			@sCell = new Int8Array   1
			@uCell = new Uint8Array  1

	# signed correction
	sign: (v) ->
		@sCell[0] = v
		return @sCell[0]

	# unsigned correction
	unsign: (v) ->
		@uCell[0] = v
		return @uCell[0]

	# value correction for timed function
	time: (n) ->
		@uCell[0] = n
		return @uCell[0] * @timeUnit

	# value correction for audio player
	pitch: (n) ->
		@sCell[0] = n
		if @frequencies?
			n = @sCell[0]
			l = @frequencies.length
			return @frequencies[n %% l] * Math.pow(2, n // l)
		return @sCell[0]

}
