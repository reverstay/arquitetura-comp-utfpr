ID   = Eq03
CFG  = config.gtkw
TGT  = RegFile
SRC  = $(ID)-Dec16.vhd $(ID)-Mux16.vhd $(ID)-Reg20.vhd $(ID)-$(TGT).vhd $(ID)-$(TGT)_tb.vhd
WAVE = $(ID)-$(TGT).ghw

all: run $(WAVE)

$(WAVE): $(SRC)
	for src in $(SRC); do \
		ghdl -a $$src; \
	done
	ghdl -r RegFile_tb --wave=$(WAVE)

run: $(WAVE)
	gtkwave $(WAVE) -a $(CFG)
