@echo off
setlocal

set "ID=Eq03-RegFile"
set "REG=Eq03-reg20its"
set "TB_ENTITY=RegFile_tb"
set "CFG=%ID%.gtkw"

ghdl -a "%REG%.vhd" "%ID%.vhd" "%ID%_tb.vhd" || exit /b 1
ghdl -e "%TB_ENTITY%"                        || exit /b 1
ghdl -r "%TB_ENTITY%" --wave="%ID%.ghw"      || exit /b 1
gtkwave "%ID%.ghw" -a "%CFG%"

endlocal
