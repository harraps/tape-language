// Generated by CoffeeScript 2.3.1
(function() {
  /* AUDIO */
  var body, cell, context, div_console, div_editor, editor_dark, editor_light, i, j, k, l, options, row, start_program, table_cells, table_memory, value;

  TAPE.audio = {
    // control sound
    mute: false,
    volume: 1,
    // callback for playing sounds
    playSound: function(pitch) {
      var gain, osc;
      // do not play sounds if muted
      if (this.mute) {
        return;
      }
      // if the pitch is too low or too high,
      // it won't be audible anyway
      if (pitch < 20 || pitch > 20000) {
        return;
      }
      // oscillation and gain
      osc = context.createOscillator();
      gain = context.createGain();
      // link them together
      osc.connect(gain);
      gain.connect(context.destination);
      // setup oscillation and gain
      osc.type = "sine";
      osc.frequency.setTargetAtTime(pitch, context.currentTime, 20);
      gain.gain.exponentialRampToValueAtTime(0.00001, context.currentTime + 1.5);
      return osc.start(0); // start sound
    }
  };

  
  //# LOCAL SCOPE
  // how to generate audio easily!
  // http://marcgg.com/blog/2016/11/01/javascript-audio/
  context = new AudioContext();

  //# CALLBACK
  TAPE.playSound = function(pitch) {
    return TAPE.audio.playSound(pitch);
  };

  /* CONSOLE */
  TAPE.console = {
    // print the character to the console output
    printChar: function(char) {
      div_console.textContent += char;
      return char;
    },
    // clean console output
    clean: function() {
      return div_console.textContent = "";
    }
  };

  //# LOCAL SCOPE
  div_console = document.getElementById("tape-console");

  //# CALLBACK
  TAPE.printChar = function(char) {
    return TAPE.console.printChar(char);
  };

  /* DATA TABLE */
  TAPE.dataTable = {
    // define the way we want to display the memory
    mode: 0,
    // 0 : decimal
    // 1 : hexadecimal
    // 2 : character

    // print the value of the character in the table
    updateCell: function(index, value) {
      return table_cells[index].innerHTML = this.printableValue(value);
    },
    // clean memory display
    clean: function() {
      var i, k, results, value;
      value = this.defaultValue();
      results = [];
      for (i = k = 0; k < 256; i = ++k) {
        results.push(table_cells[i].innerHTML = value);
      }
      return results;
    },
    // refresh the view
    refresh: function() {
      var i, k, results, v;
      results = [];
      for (i = k = 0; k < 256; i = ++k) {
        v = TAPE.program.tape.get(i);
        v = this.printableValue(v);
        results.push(table_cells[i].innerHTML = v);
      }
      return results;
    },
    // default value to use when cleaning the view
    defaultValue: function() {
      switch (this.mode) {
        case 0:
          return '0';
        case 1:
          return '00';
        case 2:
          return ' ';
      }
    },
    // return printable value
    printableValue: function(value) {
      var v;
      switch (this.mode) {
        case 0:
          return value;
        case 1:
          v = value.toString(16).toUpperCase();
          if (v.length === 1) {
            v = '0' + v;
          }
          return v;
        case 2:
          // TODO: handle non displayed chars too
          v = String.fromCharCode(value);
          return v;
      }
      return ' ';
    }
  };

  //# LOCAL SCOPE
  table_memory = document.getElementById("tape-memory");

  table_cells = [];

  // generate the table
  value = TAPE.dataTable.defaultValue();

  for (i = k = 0; k < 16; i = ++k) {
    row = table_memory.insertRow(i);
    for (j = l = 0; l < 16; j = ++l) {
      cell = row.insertCell(j);
      cell.innerHTML = value;
      table_cells[j + i * 16] = cell;
    }
  }

  //# CALLBACK
  TAPE.updateCell = function(index, value) {
    return TAPE.dataTable.updateCell(index, value);
  };

  /* EDITOR */
  //# LOCAL SCOPE
  editor_light = "duotone-light";

  editor_dark = "duotone-dark";

  div_editor = document.getElementById("tape-editor");

  start_program = "[8] {\n    @0 = \"Hello World!\".\n    $0 < 0xC [\n        (%) 5.\n        (&) @$0.\n        ++$0.\n    ]\n}";

  options = {
    value: start_program,
    mode: {
      name: "tape"
    },
    theme: editor_light,
    lineNumbers: true,
    smartIndent: true
  };

  TAPE.editor = CodeMirror(div_editor, options);

  TAPE.editor.setSize(500, 500);

  /* INTERFACE */
  /*
  	- execute the program
  	- clean console and dataTable
  	- change the color scheme (light & dark)
  	- change the display mode (decimal, hexa, character)
  */
  TAPE.interface = {
    style: "light",
    mode: "decimal",
    // execute the program
    run: function() {
      var program;
      this.clean(); // clean   the interface
      program = TAPE.editor.getValue(); // get     the program
      tapeParser.parse(program); // parse   the program
      return TAPE.program.run(); // execute the program
    },
    
    // clean console and data table
    clean: function() {
      TAPE.console.clean();
      return TAPE.dataTable.clean();
    },
    // set the style of the interface
    setStyle: function(style) {
      switch (style) {
        case "light":
          this.style = "light";
          return TAPE.editor.setOption("theme", editor_light);
        case "dark":
          this.style = "dark";
          return TAPE.editor.setOption("theme", editor_dark);
      }
    },
    // set the display mode to use for the data table
    setDisplay: function(mode) {
      var prev, ref;
      prev = TAPE.dataTable.mode;
      // change the display mode of the memory view
      switch (mode) {
        case "decimal":
        case "dec":
          this.mode = "decimal";
          TAPE.dataTable.mode = 0;
          break;
        case "hexadecimal":
        case "hexa":
          this.mode = "hexadecimal";
          TAPE.dataTable.mode = 1;
          break;
        case "character":
        case "char":
          this.mode = "character";
          TAPE.dataTable.mode = 2;
      }
      // if the mode has changed, reprint the memory
      if (TAPE.dataTable.mode !== prev) {
        if (((ref = TAPE.program) != null ? ref.tape : void 0) != null) {
          return TAPE.dataTable.refresh();
        } else {
          return TAPE.dataTable.clean();
        }
      }
    }
  };

  //# LOCAL SCOPE
  editor_light = "duotone-light";

  editor_dark = "duotone-dark";

  body = document.body;

}).call(this);
