### EDITOR ###

## LOCAL SCOPE

editor_light = "base16-light"
editor_dark  = "base16-dark"

div_editor = document.getElementById "tape-editor"

start_program = """
[8] {
    @0 = "Hello World!".
    $0 < 0xC [
        (%) 5.
        (&) @$0.
        ++$0.
    ]
}
"""

options = {
	value: start_program
	mode:  "tape"
	theme: editor_light
	lineNumbers: true
	smartIndent: true
}
TAPE.editor = CodeMirror div_editor, options

TAPE.editor.setSize 500, 500
