// Generated by CoffeeScript 2.0.2
(function() {
  // get access to the global scope
  var Assign, Decrement, Flag, GLOBAL, Goto, If, Increment, Instruction, Loop, Op, Print, Stop, Tape, cls, funcs, op, parseBinary, t;

  GLOBAL = window || exports;

  Tape = class Tape {
    constructor() {
      console.log("TAPE CREATED!");
    }

    init(type) {
      // used to store the data
      this.array = (function() {
        switch (type) {
          case 8:
            return new Uint8Array(0x100);
          case -8:
            return new Int8Array(0x100);
          case 16:
            return new Uint16Array(0x10000);
          case -16:
            return new Int16Array(0x10000);
        }
      })();
      // used for keeping numbers in the expected range
      this.byte = (function() {
        switch (type) {
          case 8:
            return new Uint8Array(1);
          case -8:
            return new Int8Array(1);
          case 16:
            return new Uint16Array(1);
          case -16:
            return new Int16Array(1);
        }
      })();
      // used to correctly index the array
      return this.index = (function() {
        switch (Math.abs(type)) {
          case 8:
            return new Uint8Array(1);
          case 16:
            return new Uint16Array(1);
        }
      })();
    }

    // convert to the numerical type chosen
    c(x) {
      this.byte[0] = x;
      return this.byte[0];
    }

    // set the value in the array
    s(i, x) {
      this.index[0] = i;
      return this.array[this.index[0]] = x;
    }

    // get the value from the array
    g(i) {
      this.index[0] = i;
      return this.array[this.index[0]];
    }

  };

  // declare a tape
  t = new Tape();

  op = {};

  funcs = {};

  cls = {};

  GLOBAL.TAPE = {
    tape: t,
    op: op,
    func: funcs,
    inst: cls,
    instructions: []
  };

  // unary
  op.AT = function(i) {
    return t.g(i);
  };

  op.NOT = function(a) {
    if (!a) {
      return 0;
    } else {
      return 1;
    }
  };

  op.BNOT = function(a) {
    return t.c(~a);
  };

  op.INCR = function(a) {
    return t.c(a + 1);
  };

  op.DECR = function(a) {
    return t.c(a - 1);
  };

  op.INCR_ = function(i) {
    t.index[0] = i;
    return ++t.array[t.index[0]];
  };

  op.DECR_ = function(i) {
    t.index[0] = i;
    return --t.array[t.index[0]];
  };

  op.ABS = function(a) {
    return t.c(Math.abs(a)); // special case |-128| -> 128 > 127 -> -128
  };

  op.NEG = function(a) {
    return t.c(-a); // we may have only positive numbers
  };

  // arithmetic
  op.ADD = function(a, b) {
    return t.c(a + b);
  };

  op.SUB = function(a, b) {
    return t.c(a - b);
  };

  op.MUL = function(a, b) {
    return t.c(a * b);
  };

  op.DIV = function(a, b) {
    return t.c(a / b); // if b == 0 -> 0
  };

  op.MOD = function(a, b) {
    return t.c(a % b);
  };

  
  // logical
  op.AND = function(a, b) {
    if (a && b) {
      return 1;
    } else {
      return 0;
    }
  };

  op.OR = function(a, b) {
    if (a || b) {
      return 1;
    } else {
      return 0;
    }
  };

  op.XOR = function(a, b) {
    if (!a !== !b) {
      return 1;
    } else {
      return 0;
    }
  };

  op.NAND = function(a, b) {
    if (a && b) {
      return 0;
    } else {
      return 1;
    }
  };

  op.NOR = function(a, b) {
    if (a || b) {
      return 0;
    } else {
      return 1;
    }
  };

  op.XNOR = function(a, b) {
    if (!a !== !b) {
      return 0;
    } else {
      return 1;
    }
  };

  // bitwise
  op.BAND = function(a, b) {
    return t.c(a & b);
  };

  op.BOR = function(a, b) {
    return t.c(a | b);
  };

  op.BXOR = function(a, b) {
    return t.c(a ^ b);
  };

  op.BNAND = function(a, b) {
    return t.c(~(a & b));
  };

  op.BNOR = function(a, b) {
    return t.c(~(a | b));
  };

  op.BXNOR = function(a, b) {
    return t.c(~(a ^ b));
  };

  op.LSHIFT = function(a, b) {
    return t.c(a << b);
  };

  op.RSHIFT = function(a, b) {
    return t.c(a >> b);
  };

  // comparator
  op.EQU = function(a, b) {
    if (a === b) {
      return 1;
    } else {
      return 0;
    }
  };

  op.DIF = function(a, b) {
    if (a !== b) {
      return 1;
    } else {
      return 0;
    }
  };

  op.GRT = function(a, b) {
    if (a > b) {
      return 1;
    } else {
      return 0;
    }
  };

  op.LST = function(a, b) {
    if (a < b) {
      return 1;
    } else {
      return 0;
    }
  };

  op.GTE = function(a, b) {
    if (a >= b) {
      return 1;
    } else {
      return 0;
    }
  };

  op.LSE = function(a, b) {
    if (a <= b) {
      return 1;
    } else {
      return 0;
    }
  };

  Instruction = class Instruction {
    print() {
      return "instruction undefined";
    }

  };

  Assign = class Assign extends Instruction {
    constructor(cell, value1) {
      super();
      this.cell = cell;
      this.value = value1;
    }

    print() {
      return `at ${this.cell} assign ${this.value.print()}`;
    }

  };

  Increment = class Increment extends Instruction {
    constructor(cell) {
      super();
      this.cell = cell;
    }

    print() {
      return `increment value at ${this.cell}`;
    }

  };

  Decrement = class Decrement extends Instruction {
    constructor(cell) {
      super();
      this.cell = cell;
    }

    print() {
      return `decrement value at ${this.cell}`;
    }

  };

  Flag = class Flag extends Instruction {
    constructor(id) {
      super();
      this.id = id;
    }

    print() {
      return `flag ${this.id.print()}`;
    }

  };

  Goto = class Goto extends Instruction {
    constructor(id) {
      super();
      this.id = id;
    }

    print() {
      return `go to flag ${this.id.print()}`;
    }

  };

  Print = class Print extends Instruction {
    constructor(type1, value1, range) {
      super();
      this.type = type1;
      this.value = value1;
      this.range = range;
    }

    print() {
      switch (this.type) {
        case 0:
          return `display ${this.value.print() // display
}`;
        case 1:
          return `print ${this.value.print() // print char
}`;
        case 2:
          return `print starting at ${this.value.print()} up to ${this.range.print()
      // print range
} characters`;
      }
    }

  };

  If = class If extends Instruction {
    constructor(conds, blocks) {
      super();
      this.conds = conds;
      this.blocks = blocks;
    }

    print() {
      var block, cond, j, len, ref, strings;
      strings = [];
      ref = zip(this.conds, this.blocks);
      for (j = 0, len = ref.length; j < len; j++) {
        [cond, block] = ref[j];
        strings.push(`if ${cond.print()} then do ${block.print()} \n`);
      }
      return strings.join();
    }

  };

  Loop = class Loop extends Instruction {
    constructor(cond1, block1) {
      super();
      this.cond = cond1;
      this.block = block1;
    }

    print() {
      return `loop while ${this.cond.print()} and do ${block.print()}`;
    }

  };

  Stop = class Stop extends Instruction {
    print() {
      return "stop";
    }

  };

  Op = class Op {
    constructor(op1, left, right) {
      this.op = op1;
      this.left = left;
      this.right = right;
    }

    print() {
      return `operate ${this.op} on ${this.left.print()} and ${this.right.print()}`;
    }

  };

  cls.Assign = Assign;

  cls.Increment = Increment;

  cls.Decrement = Decrement;

  cls.Flag = Flag;

  cls.Goto = Goto;

  cls.Print = Print;

  cls.If = If;

  cls.Loop = Loop;

  cls.Stop = Stop;

  cls.Op = Op;

  funcs._program = function(def, instrs) {
    return GLOBAL.TAPE.instructions = instrs;
  };

  funcs._define = function(value) {
    return t = t.init(value);
  };

  funcs._instrs = function(instrs, instr) {
    instrs = instrs || [];
    instrs.push(instr);
    return instrs;
  };

  // group cond and blocks in arrays
  funcs._if = function(cond, block, elses) {
    if (elses != null) {
      elses.conds.unshift(cond);
      elses.blocks.unshift(block);
    } else {
      return new If([cond], [block]);
    }
    return new If(elses.conds, elses.blocks);
  };

  // group cond and blocks in arrays
  funcs._elseif = function(cond, block, elses) {
    if (elses != null) {
      elses.conds.unshift(cond);
      elses.blocks.unshift(block);
    } else {
      return {
        conds: [cond],
        blocks: [block]
      };
    }
    return elses;
  };

  // group cond and blocks in arrays
  funcs._else = function(block) {
    return {
      conds: [null],
      blocks: [block]
    };
  };

  funcs._incr = function(type, value) {
    switch (type) {
      case 0:
        return new Op(op.INCR, value);
      case 1:
        return new Op(op.INCR_, value);
    }
  };

  funcs._decr = function(type, value) {
    switch (type) {
      case 0:
        return new Op(op.DECR, value);
      case 1:
        return new Op(op.DECR_, value);
    }
  };

  
  // TODO
  parseBinary = function(string) {
    return parseInt(string);
  };

  funcs._number = function(type, value) {
    switch (type) {
      case "decimal":
        return parseInt(value);
      case "octal":
        return parseInt('0' + value);
      case "hexadecimal":
        return parseInt('0x' + value);
      case "binary":
        return parseBinary(value);
      default:
        return 0;
    }
  };

}).call(this);
