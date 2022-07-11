
MAKE = make --no-print-directory

VLOG_OPTIONS = -incr -sv +acc -timescale 1ns/1ps
VSIM_OPTIONS =
VLOG = vlog $(VLOG_OPTIONS)
VSIM_MODE ?= "-c"
END_TIME_VSIM ?= 1us

DUT = example1

.PHONY: h
h:
	@echo ""
	@echo "Usage:  make [target(s)]"
	@echo "where target is any of:"
	@echo ""
	@echo "  all         - compilation, optimization, simulation DUT project"
	@echo "  rall        - run 'clean' and 'all' target"
	@echo "  compile_rtl - compile all rtl"
	@echo "  compile_tb  - compile all testbench"
	@echo "  compile     - compile all rtl and testbench"
	@echo "  opt         - optimization project"
	@echo "  sim         - run simulation project (in 'VSIM_MODE' - variable)"
	@echo "  clean       - remove derived files"
	@echo ""

.PHONY: compile_rtl compile_tb compile opt sim sim_cmd sim_gui all rall clean

LIBS =
RTL = ../

compile_rtl:
	$(VLOG) $(LIBS) $(RTL)/$(DUT).sv

compile_tb:
	$(VLOG) ./$(DUT)_tb.sv

compile:
	$(MAKE) compile_rtl
	$(MAKE) compile_tb

opt:
	@vopt $(DUT)_tb $(LIBS) -o $(DUT)_tb_opt

sim:
	@-if [ "$(VSIM_MODE)" = "-c" ]; then \
		$(MAKE) sim_cmd;                 \
	  else                               \
		$(MAKE) sim_gui;                 \
	  fi

sim_cmd:
	vsim $(VSIM_OPTIONS) -c $(DUT)_tb_opt -do "run $(END_TIME_VSIM); exit"

sim_gui:
	vsim $(VSIM_OPTIONS) $(DUT)_tb_opt -do "source ./wave_$(DUT)_tb.do; run $(END_TIME_VSIM)" &

all:
	$(MAKE) compile
	$(MAKE) opt
	$(MAKE) sim

rall:
	$(MAKE) clean
	$(MAKE) all

clean:
	@echo "Clean ..."
	@rm -rf *~ work *.wlf* questa.tops transcript *.vstf wlft??????
