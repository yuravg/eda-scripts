
MAKE = make --no-print-directory

QUIET_OPTION = -quiet
SCHEMATIC_OP = -debugdb

VLOG = vlog -incr -sv +acc -timescale 1ns/1ps $(QUIET_OPTION)
VOPT = vopt $(SCHEMATIC_OP) $(QUIET_OPTION)
END_TIME_VSIM ?= 1us
VSIM_MODE ?= "-c"
ifeq ($(VSIM_MODE),"-c")
  VSIM =vsim $(QUIET_OPTION) -c $(DUT)_tb_opt -do "run $(END_TIME_VSIM); exit"
else
  VSIM =vsim $(QUIET_OPTION) $(SCHEMATIC_OP) $(DUT)_tb_opt -do "source ./wave_$(DUT)_tb.do; run $(END_TIME_VSIM)" &
endif

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
	$(VLOG) $(LIBS) $(RTL)/$(DUT).sv

compile_tb:
	$(VLOG) ./$(DUT)_tb.sv

compile:
	$(MAKE) compile_rtl
	$(MAKE) compile_tb

opt:
	$(VOPT) $(DUT)_tb $(LIBS) -o $(DUT)_tb_opt

sim:
	$(VSIM)

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
