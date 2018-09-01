### ACTIONS ###
action =

	# wait the given number of milliseconds before continuing
	wait: (v) ->
    	# tape 16-bits : milliseconds
    	# tape  8-bits : seconds
    	new Promise (resolve) ->
        	window.setTimeout resolve, TAPE.corrector.time(v)

	# play a bell sound of given note
	bell: (v) ->
    	# tape 16-bits : full range of frequencies
    	# tape  8-bits : indexed frequencies
    	TAPE.playSound? TAPE.corrector.pitch v

	# print the character in the console
	print: (v) ->
    	# tape 16-bits : UTF-8
    	# tape  8-bits : ASCII
    	TAPE.printChar? String.fromCharCode(TAPE.corrector.usign v)


###
	for actions 'bell' and 'print', it is necessary to provide a callback
	function to 'TAPE' because their implementation may vary from one platform
	to another.
###
