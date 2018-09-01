### INTERFACE ###

# switch between light and dark style
TOGGLE_STYLE = ->
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

TOGGLE_DISPLAY = ->
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
