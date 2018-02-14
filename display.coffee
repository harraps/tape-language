GLOBAL = exports ? this

div_program = document.getElementById "program"
div_output  = document.getElementById "output"

# get source from div
GLOBAL.program_src = div_program.innerHTML
#program_src = div_program.textContent

# how to generate audio easily!
# http://marcgg.com/blog/2016/11/01/javascript-audio/
context = new AudioContext()
GLOBAL.PLAY_SOUND = (pitch) ->
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

GLOBAL.ADD_CHAR = (char) ->
    div_output.textContent += char
    return char