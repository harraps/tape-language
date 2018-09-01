REM echo building parser
jison parser/tape-parser.jison parser/tape-lexer.jisonlex --outfile tape-parser.js

echo building controller
REM coffee --output tape-ctrl.js --join --compile controller/*.coffee
coffee -cj tape-ctrl.js controller/*.coffee

echo building view
coffee -cj tape-view.js view/*.coffee

pause