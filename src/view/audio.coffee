### AUDIO ###

TAPE.audio =

	# control sound
	mute: no
	volume: 1

	# callback for playing sounds
	playSound: (pitch) ->
		# do not play sounds if muted
		if @mute then return

		# if the pitch is too low or too high,
		# it won't be audible anyway
		if pitch < 20 or pitch > 20000 then return

		# oscillation and gain
		osc	 = context.createOscillator()
		gain = context.createGain()
		# link them together
		osc .connect gain
		gain.connect context.destination

		# setup oscillation and gain
		osc.type = "sine"
		osc.frequency.setTargetAtTime(
			pitch, context.currentTime, 20
		)
		gain.gain.exponentialRampToValueAtTime(
			0.00001, context.currentTime + 1.5
		)
		osc.start(0) # start sound


## LOCAL SCOPE
# how to generate audio easily!
# http://marcgg.com/blog/2016/11/01/javascript-audio/
context = new AudioContext()


## CALLBACK
TAPE.playSound = (pitch) ->
	TAPE.audio.playSound pitch
