### CONSOLE ###

TAPE.console =

	# define the way we want to display the memory
	memoryDisplay: 0
	# 0 : decimal
	# 1 : hexadecimal
	# 2 : character

	# print the character to the console output
	printChar: (char) ->
	    div_output.textContent += char
	    return char

	# print the value of the character in the table
	updateCell: (index, value) ->
	    if memory_display == 1
	        value = value.toString(16).toUpperCase()
	        if value.length == 1 then value = '0' + value
	    else if memory_display == 2
	        value = String.fromCharCode(value)
	    cells[index].innerHTML = value

	# clean the display
	clean: ->
	    # clean memory display
	    for i in [0..255]
	        cells[i].innerHTML = '0'
	    # clean console output
	    div_output.textContent = ""

## LOCAL SCOPE


## CALLBACK
TAPE.printChar  = TAPE.console.printChar
TAPE.updateCell = TAPE.console.updateCell
