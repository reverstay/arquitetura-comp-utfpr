ID   = Eq03-ULA
SRC  = $(ID).vhd
TB   = $(ID)_tb.vhd
WAVE = $(ID).ghw
CFG  = config.gtkw

all: run $(WAVE)

$(WAVE): $(SRC) $(TB)
	ghdl -a $(SRC) $(TB)
	ghdl -r Ula_tb --wave=$(WAVE)

run: $(WAVE)
	gtkwave $(WAVE) -a $(CFG)
