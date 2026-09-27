ID   = Eq03
TGT  = ULARegs
SRC  = $(ID)-ULA.vhd \
			 $(ID)-Dec16.vhd \
			 $(ID)-Mux16.vhd \
			 $(ID)-Mux2.vhd \
			 $(ID)-Reg20.vhd \
			 $(ID)-RegFile.vhd \
			 $(ID)-$(TGT).vhd \
			 $(ID)-$(TGT)_tb.vhd
WAVE = $(ID)-$(TGT).ghw
CFG  = $(ID)-$(TGT).gtkw

all: $(WAVE)

$(WAVE): $(SRC)
	for src in $(SRC); do \
		ghdl -a $$src; \
	done
	ghdl -r $(TGT)_tb --wave=$(WAVE)

run: $(WAVE)
	exec gtkwave $(WAVE) -a $(CFG) & disown
