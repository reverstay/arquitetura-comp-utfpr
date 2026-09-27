ghdl -a Eq03-ULA.vhd
ghdl -a Eq03-Dec16.vhd
ghdl -a Eq03-Mux16.vhd
ghdl -a Eq03-Mux2.vhd
ghdl -a Eq03-Reg20.vhd
ghdl -a Eq03-RegFile.vhd
ghdl -a Eq03-ULARegs.vhd
ghdl -a Eq03-ULARegs_tb.vhd

ghdl -r ULARegs_tb --wave=Eq03-ULARegs.ghw
