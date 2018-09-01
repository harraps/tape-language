#!/bin/bash

jison parser/tape-parser.jison parser/tape-lexer.jisonlex --outfile tape-parser.js

cat controller/*.coffee | coffee --compile --stdio >  tape-ctrl.js

cat view/*.coffee | coffee --compile --stdio >  tape-view.js