@echo off
setlocal

ghdl -a Eq03-Dec16.vhd
ghdl -a Eq03-Mux16.vhd
ghdl -a Eq03-Reg20.vhd
ghdl -a Eq03-RegFile.vhd
ghdl -a Eq03-RegFile_tb.vhd

ghdl -r RegFile_tb --wave=Eq03-RegFile.ghw

gtkwave Eq03-RegFile.ghw -a Eq03-RegFile.gtkw

endlocal
