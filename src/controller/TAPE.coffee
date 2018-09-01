### TAPE ###

# store our functions into the global scope
GLOBAL = exports ? this
GLOBAL.TAPE = {action, corrector, formater, memory, node, op}


###
	Callbacks that can be implemented:

	playSound(pitch)         : to play a sound at given pitch
	printChar(charCode)      : to print the character to the console
	updateCell(index, value) : change the value of cell
###
