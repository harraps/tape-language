### FORMATERS ###
formater = {

	# program structure
	program: (def, funcs) ->
		TAPE.corrector.init def
		program = new TAPE.node.Program(def, funcs)
		TAPE.program = program
		return program

	# gather functions
	namedGather: (map, element) ->
		map = map or {}
		map[element.name] = element
		return map

	# gather a list of elements
	gather: (list, element) ->
		list = list or []
		list.push element
		return list

	# conditionals
	if_: (cond, block, elses) ->
		if elses?
			elses.conds .unshift cond
			elses.blocks.unshift block
		else return new TAPE.node.If([cond], [block])
		return new TAPE.node.If(elses.conds, elses.blocks)
	elseif: (cond, block, elses) ->
		unless elses?
			return {
				conds:  [cond]
				blocks: [block]
			}
		else
			elses.conds .unshift cond
			elses.blocks.unshift block
		return elses

	else_: (block) ->
		return {
			conds:  [true]
			blocks: [block]
		}

	callDyadic: (name, params, param) ->
		fullList = this.callDyadicList name, params, param
		delete params.name
		return new TAPE.node.Call name, params

	callDyadicList: (name, params, param) ->
		if params instanceof Array # list of params
			if params.name == name # same operator
				params.push param
				return params
			else # different operators
				newList = [new TAPE.node.Call(params.name, params), param]
				delete params.name
				newList.name = name
				return newList
		else # single param
			newList = [params, param]
			newList.name = name
			return newList


	loop: (type, cond, block) ->
		lp = new TAPE.node.Loop(cond, block, type)
		# find breaks recursively
		find_breaks lp, block
		return lp

	# parse number
	number: (type, value) ->
		val = value.substring 2
		return switch type
			when "decimal"     then parseInt(value)
			when "octal"       then parseInt(val,  8)
			when "hexadecimal" then parseInt(val, 16)
			when "binary"      then parseInt(val,  2)
			when "character"   then value.charCodeAt(1)
			else 0
}

# helper function to find breaks recursively
find_breaks = (lp, block) ->
	for instr in block
		if instr is TAPE.node.If
			find_breaks(lp.loopType, b) for b in instr.blocks
		else if instr is TAPE.node.Break and instr.loopType == lp.loopType
			instr.loop = lp
		else if instr is TAPE.node.Loop  and instr.loopType != lp.loopType
			find_breaks(lp.loopType, instr.block)
