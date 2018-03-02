GLOBAL = exports ? this

# get divs
GLOBAL.div_program = document.getElementById "program"
GLOBAL.div_output  = document.getElementById "output"

# mute the sound
GLOBAL.mute   = true
GLOBAL.volume = 1

# how to generate audio easily!
# http://marcgg.com/blog/2016/11/01/javascript-audio/
context = new AudioContext()

# play a sound
GLOBAL.PLAY_SOUND = (pitch) ->
    # do not play sounds if muted
    if @mute then return

    # if the pitch is too low or too high,
    # it won't be audible anyway
    if pitch < 20 or pitch > 20000 then return

    # oscillation and gain
    osc  = context.createOscillator()
    gain = context.createGain()
    # link them together
    osc .connect gain
    gain.connect context.destination

    # setup oscillation and gain
    osc.type = "sine"
    osc.frequency.value = pitch
    gain.gain.exponentialRampToValueAtTime(
        0.00001, context.currentTime + 1.5
    )
    
    # start sound
    osc.start(0)

# print the character to the console output
GLOBAL.ADD_CHAR = (char) ->
    @div_output.textContent += char
    return char
