@echo off
setlocal

set "ID=Eq03-ULA"
set "TB_ENTITY=Ula_tb"
set "CFG=config.gtkw"

ghdl -a "%ID%.vhd" "%ID%_tb.vhd"        || exit /b 1
ghdl -r "%TB_ENTITY%" --wave="%ID%.ghw" || exit /b 1
gtkwave "%ID%.ghw" -a "%CFG%"

endlocal
