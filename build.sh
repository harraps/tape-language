#!/bin/bash

jison src/parser/tape-parser.jison src/parser/tape-lexer.jisonlex --outfile js/tape-parser.js

cat src/controller/*.coffee | coffee --compile --stdio > js/tape-controller.js

cat src/view/*.coffee | coffee --compile --stdio > js/tape-view.js

coffee --compile src/syntax.coffee
