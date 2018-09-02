### CONSOLE ###

TAPE.console = {

	# print the character to the console output
	printChar: (char) ->
		div_console.textContent += char
		return char

	# clean console output
	clean: -> div_console.textContent = ""
}

## LOCAL SCOPE
div_console = document.getElementById "tape-console"

## CALLBACK
TAPE.printChar = (char) ->
	TAPE.console.printChar char
