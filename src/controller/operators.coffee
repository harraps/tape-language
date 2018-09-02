### OPERATORS ###
op = {
	getName: (fun) -> name if fun2 == fun for name, fun2 of this

	# unary
	not_: (a) -> unless a then 0 else 1
	bnot: (a) -> corrector.sign(~a)
	abs:  (a) -> corrector.sign Math.abs a # special case |-128| -> 128 > 127 -> -128
	neg:  (a) -> corrector.sign(-a)        # we may have only positive numbers

	# arithmetic
	add: (a, b) -> corrector.sign(a +  b)
	sub: (a, b) -> corrector.sign(a -  b)
	mul: (a, b) -> corrector.sign(a *  b)
	div: (a, b) -> corrector.sign(a // b) # if b == 0 -> 0
	mod: (a, b) -> corrector.sign(a %% b)

	# logical
	and_: (a, b) -> if  a and b then 1 else 0
	nand: (a, b) -> if  a and b then 0 else 1
	or_:  (a, b) -> if  a or  b then 1 else 0
	nor:  (a, b) -> if  a or  b then 0 else 1
	xor:  (a, b) -> if not a isnt not b then 1 else 0
	xnor: (a, b) -> if not a isnt not b then 0 else 1

	# bitwise
	band:   (a, b) -> corrector.sign(a & b)
	bor:    (a, b) -> corrector.sign(a | b)
	bxor:   (a, b) -> corrector.sign(a ^ b)
	bnand:  (a, b) -> corrector.sign(~(a & b))
	bnor:   (a, b) -> corrector.sign(~(a | b))
	bxnor:  (a, b) -> corrector.sign(~(a ^ b))
	lshift: (a, b) -> corrector.sign(a << b)
	rshift: (a, b) -> corrector.sign(a >> b)

	# comparator
	equ: (a, b) -> if a is   b then 1 else 0
	dif: (a, b) -> if a isnt b then 1 else 0
	grt: (a, b) -> if a >    b then 1 else 0
	lst: (a, b) -> if a <    b then 1 else 0
	gte: (a, b) -> if a >=   b then 1 else 0
	lte: (a, b) -> if a <=   b then 1 else 0
}
