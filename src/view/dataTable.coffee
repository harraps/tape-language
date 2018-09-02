### DATA TABLE ###
TAPE.dataTable = {

	# define the way we want to display the memory
	mode: 0
	# 0 : decimal
	# 1 : hexadecimal
	# 2 : character

	# print the value of the character in the table
	updateCell: (index, value) ->
		table_cells[index].innerHTML = @printableValue value

	# clean memory display
	clean: ->
		value = @defaultValue()
		for i in [0...256]
			table_cells[i].innerHTML = value

	# refresh the view
	refresh: ->
		for i in [0...256]
			v = TAPE.program.tape.get i
			v = @printableValue v
			table_cells[i].innerHTML = v

	# default value to use when cleaning the view
	defaultValue: ->
		return switch @mode
			when 0 then '0'
			when 1 then '00'
			when 2 then ' '

	# return printable value
	printableValue: (value) ->
		switch @mode
			when 0 then return value
			when 1
				v = value.toString(16).toUpperCase()
				v = '0' + v if v.length == 1
				return v
			when 2
				# TODO: handle non displayed chars too
				v = String.fromCharCode value
				return v
		return ' '
}

## LOCAL SCOPE
table_memory = document.getElementById "tape-memory"
table_cells = []

# generate the table
value = TAPE.dataTable.defaultValue()
for i in [0...16]
	row = table_memory.insertRow i
	for j in [0...16]
		cell = row.insertCell j
		cell.innerHTML = value
		table_cells[j + i*16] = cell

## CALLBACK
TAPE.updateCell = (index, value) ->
	TAPE.dataTable.updateCell index, value
