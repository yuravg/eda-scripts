
MAKE = make --no-print-directory

QUIET_OPTION = -quiet
SCHEMATIC_OPTION = -debugdb

VLOG = vlog -incr -sv +acc -timescale 1ns/1ps $(QUIET_OPTION)
VOPT = vopt $(SCHEMATIC_OPTION) $(QUIET_OPTION)

VSIM_MODE ?= "-c"
END_TIME_VSIM ?= 1us

VSIM = $(if $(findstring -c,$(VSIM_MODE)),\
vsim $(QUIET_OPTION) -c $(DUT)_tb_opt -do "run $(END_TIME_VSIM); exit",\
vsim $(QUIET_OPTION) $(SCHEMATIC_OPTION) $(DUT)_tb_opt -do "source ./wave_$(DUT)_tb.do; run $(END_TIME_VSIM); -onfinish stop" &)

.PHONY: h compile_rtl compile_tb compile opt sim all rall clean
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
	@echo "  sim         - run simulation project (set VSIM_MODE=-c to Command line mode)"
	@echo "  clean       - remove derived files"
	@echo ""

DUT = example1
LIBS =
RTL = ../

compile_rtl:
	@echo "Compiling the RTL..."
	@$(VLOG) $(LIBS) $(RTL)/$(DUT).sv

compile_tb:
	@echo "Compiling the TB..."
	@$(VLOG) ./$(DUT)_tb.sv

compile:
	@$(MAKE) compile_rtl
	@$(MAKE) compile_tb

opt@:
	@echo "Optimizing the TB..."
	@$(VOPT) $(DUT)_tb $(LIBS) -o $(DUT)_tb_opt

sim@:
	@echo "Running simulation..."
	@$(VSIM)

all:
	@$(MAKE) compile
	@$(MAKE) opt
	@$(MAKE) sim

rall:
	@$(MAKE) clean
	@$(MAKE) all

clean:
	@echo "Cleaning derived files..."
	@rm -rf *~ work *.wlf* questa.tops transcript *.vstf wlft??????
