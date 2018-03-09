GLOBAL = exports ? this

# mute the sound
GLOBAL.mute   = false
GLOBAL.volume = 1

# get divs
div_editor = document.getElementById "editor"
div_memory = document.getElementById "memory"
div_output = document.getElementById "output"
# buttons
div_btn_style  = document.getElementById "style"
div_btn_values = document.getElementById "values"

# generate the text editor
def_prog = """
[8] {
    @0 = "Hello World!".
    $0 < 12 [
        (%) 5.
        (&) @$0.
        $0 = $0 + 1.
    ]
}
"""
options =
    value: def_prog,
    mode:  "json",
    theme: "3024-day",
    lineNumbers: true,
    smartIndent: true
GLOBAL.editor = CodeMirror div_editor, options

# generate the memory table
div_table = document.createElement "table"
div_table.className = "table table-striped table-sm"
cells = [] # store html cells in an array
for i in [0..15]
    row = div_table.insertRow i
    for j in [0..15]
        cell = row.insertCell j
        cells[j + i*16] = cell
        cell.innerHTML = '0' # start empty
div_memory.appendChild div_table

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
    osc.frequency.setTargetAtTime(
        pitch, context.currentTime, 20
    )
    gain.gain.exponentialRampToValueAtTime(
        0.00001, context.currentTime + 1.5
    )
    osc.start(0) # start sound

# clean the display
GLOBAL.CLEAN = ->
    # clean memory display
    for i in [0..255]
        cells[i].innerHTML = ''
    # clean console output
    div_output.textContent = ""

# print the character to the console output
GLOBAL.ADD_CHAR = (char) ->
    div_output.textContent += char
    return char

# define the way we want to display the memory
memory_display = 0
# 0 : decimal
# 1 : hexadecimal
# 2 : character

# print the value of the character in the table
GLOBAL.UPDATE_CELL = (index, value) ->
    if memory_display == 1
        value = value.toString(16).toUpperCase()
        if value.length == 1 then value = '0' + value
    else if memory_display == 2
        value = String.fromCharCode(value)
    cells[index].innerHTML = value

# parse and run the program
GLOBAL.RUN = ->
    @CLEAN()
    # get program and parse it
    src = @editor.getValue()
    tape.parse src
    TAPE.program.run()

# false : light, true : dark
curr_style = false

# switch between light and dark style
GLOBAL.TOGGLE_STYLE = ->
    curr_style = not curr_style
    if curr_style # dark
        theme = "3024-night"
        div_btn_style.innerHTML = "DARK"
        div_btn_style.className = "btn btn-dark"
        div_table.className     = "table table-dark table-striped table-sm"
        document.body.className = "bg-dark"
    else # light
        theme = "3024-day"
        div_btn_style.innerHTML = "LIGHT"
        div_btn_style.className = "btn btn-light"
        div_table.className     = "table table-striped table-sm"
        document.body.className = "bg-white"
    @editor.setOption "theme", theme

GLOBAL.TOGGLE_DISPLAY = ->
    # change mode of display
    memory_display = (memory_display + 1) % 3
    # change label of button
    div_btn_values.innerHTML = switch memory_display
        when 0 then "DEC"
        when 1 then "HEXA"
        when 2 then "CHAR"
    # redraw memory display
    if TAPE.program?
        for i in [0..255]
            @UPDATE_CELL i, TAPE.program.tape.get(i)
    else
        value = switch memory_display
            when 0 then "0"
            when 1 then "00"
            when 2 then ""
        for i in [0..255]
            cells[i].innerHTML = value
    