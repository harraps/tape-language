### INTERFACE ###

###
	- execute the program
	- clean console and dataTable
	- change the color scheme (light & dark)
	- change the display mode (decimal, hexa, character)
###

TAPE.interface = {

	style: "light"
	mode:  "decimal"

	# execute the program
	run: ->
		@clean()                         # clean   the interface
		program = TAPE.editor.getValue() # get     the program
		tapeParser.parse program         # parse   the program
		TAPE.program.run()               # execute the program

	# clean console and data table
	clean: ->
		TAPE.console  .clean()
		TAPE.dataTable.clean()

	# set the style of the interface
	setStyle: (style) ->
		switch style
			when "light"
				@style = "light"
				TAPE.editor.setOption "theme", editor_light

			when "dark"
				@style = "dark"
				TAPE.editor.setOption "theme", editor_dark


	# set the display mode to use for the data table
	setDisplay: (mode) ->
		prev = TAPE.dataTable.mode

		# change the display mode of the memory view
		switch mode
			when "decimal", "dec"
				@mode = "decimal"
				TAPE.dataTable.mode = 0
			when "hexadecimal", "hexa"
				@mode = "hexadecimal"
				TAPE.dataTable.mode = 1
			when "character", "char"
				@mode = "character"
				TAPE.dataTable.mode = 2

		# if the mode has changed, reprint the memory
		if TAPE.dataTable.mode isnt prev
			if TAPE.program?.tape?
				TAPE.dataTable.refresh()
			else
				TAPE.dataTable.clean()

}

## LOCAL SCOPE

editor_light = "base16-light"
editor_dark  = "base16-dark"

body = document.body
