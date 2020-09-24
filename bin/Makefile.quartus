#------------------------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------------------------

####### MAKE VARIABLES: ####################
THIS_FILE = ~/altera/Makefile
MAKE      = make --no-print-directory -f $(THIS_FILE)

####### COMPILER VARIABLES: ################
ifeq ($(OS),Windows_NT)
  ifeq ($(QUARTUS_64BIT),1)
    QUARTUS_BIN_DIR=$(QUARTUS_ROOTDIR)/bin64
  else
    QUARTUS_BIN_DIR=$(QUARTUS_ROOTDIR)/bin
  endif
else
  QUARTUS_BIN_DIR=$(QUARTUS_ROOTDIR)/bin
endif

READ_ON   = --read_settings_files=on
READ_OFF  = --read_settings_files=off
WRITE_ON  = --write_settings_files=on
WRITE_OFF = --write_settings_files=off

####### PROJECT VARIABLES: #################
PROJECT  ?= $(wildcard *.qpf)
REVISION ?= $(wildcard *.qsf)
PROJECT_REVISION = $(PROJECT) -c $(REVISION)
CNT_PROJECT  = $(words $(PROJECT))
CNT_REVISION = $(words $(REVISION))
ifneq ($(CNT_PROJECT),1)
  $(warning There are project = $(PROJECT))
  $(warning You should setup (input) parameter PROJECT=<file_name.qpf>)
  $(error ERROR! Must be only one revisions!)
endif
ifneq ($(CNT_REVISION),1)
  $(warning There are revisions = $(REVISION))
  $(warning You should setup (input) parameter REVISION=<file_name.qsf>)
  $(error ERROR! Must be only one revisions!)
endif

.PHONY: help
help:
	@echo "+----------------------------------------------------+"
	@echo "| qmake - Altera Quartus make file                   |"
	@echo "+----------------------------------------------------+"
	@echo "Usage:  qmake [target(s)]"
	@echo "where target is any of Running Quartus II 64-Bit:"
	@echo ""
	@echo "  map          - Analysis & Synthesis"
	@echo "  fit          - Fitter"
	@echo "  asm          - Assembler"
	@echo "  sta          - TimeQuest Timing Analyzer"
	@echo "  all          - map, fit, asm, sta"
	@echo ""
	@echo "  ch           - TimeQuest checking"
	@echo ""
	@echo "  eda          - EDA Netlist Writer"
	@echo "  io_analisis  - I/O Assignmetn Analysis"
	@echo "  sh           - Quartus II Shell"
	@echo ""
	@echo "  debug        - Debug (temp)"
	@echo "  variable     - List of variable for makefile"
	@echo ""

.PHONY: debug
debug:
	@echo ""
	@echo " PROJECT  = $(PROJECT)"
	@echo " REVISION = $(REVISION)"
	@echo ""

.PHONY: map
map:
	$(QUARTUS_BIN_DIR)/quartus_map \
	$(READ_ON) \
	$(WRITE_OFF) \
	$(PROJECT_REVISION)

.PHONY: fit
fit:
	$(QUARTUS_BIN_DIR)/quartus_fit \
	$(READ_OFF) \
	$(WRITE_OFF) \
	$(PROJECT_REVISION) \

.PHONY: asm
asm:
	$(QUARTUS_BIN_DIR)/quartus_asm \
	$(READ_OFF) \
	$(WRITE_OFF) \
	$(PROJECT_REVISION)

.PHONY: sta
sta:
	$(QUARTUS_BIN_DIR)/quartus_sta \
	$(PROJECT_REVISION)

.PHONY: all
all:
	$(MAKE) map
	$(MAKE) fit
	$(MAKE) asm
	$(MAKE) sta

F_CHECK=checking.rpt
.PHONY: ch
ch:
	@echo "Run quartus_sta:"
	$(QUARTUS_BIN_DIR)/quartus_sta -t ~/altera/failures.tcl $(PROJECT) $(REVISION) | tee $(F_CHECK)
	@echo "+--------------------------------------------------------------------+"
	@grep -s violated $(F_CHECK) 2> /dev/null && echo "ERROR! TimeQuest Checking." \
	|| echo "TimeQuest Checking OK!"
	@echo "+--------------------------------------------------------------------+"

.PHONY: eda
eda:
	$(QUARTUS_BIN_DIR)/quartus_eda \
	$(READ_OFF) \
	$(WRITE_OFF) \
	$(PROJECT_REVISION)

.PHONY: io_analisis
io_analisis:
	$(QUARTUS_BIN_DIR)/quartus_fit \
	$(READ_ON) \
	$(WRITE_OFF) \
	$(PROJECT_REVISION) \
	--check_ios

.PHONY: sh
sh:
	$(QUARTUS_BIN_DIR)/quartus_sh -s

.PHONY: clean
clean:
	rm -rf $(F_CHECK)

.PHONY: test1
test1:
	@echo "CNT_REVISION = $(CNT_REVISION)"
	@-if [ $(CNT_REVISION) -gt 1 ] ; then \
		echo "+++ MORE!!! +++";            \
	  fi
	@echo ""

# @-if [ $(CNT_REVISION) -gt 1 ] ; then \
# $(error ERROR! There are more then one revisions: $(REVISION)! You should setup (input) parameter REVISION=<file_name.qsf>!) \
# fi

MSG_EN    ?= 0
.PHONY: test
test:
	@echo "HI"
	@-if [ $(MSG_EN) -eq 1 ] ; then \
		echo "++++++";            \
		fun_win_msg "green" "COMPILATION FINISHED" "......." "......." ; \
	  fi
	@echo "end"

.PHONY: variable
variable:
	@echo "QUARTUS_ROOTDIR = $(QUARTUS_ROOTDIR)"
	@echo "QUARTUS_BIN_DIR = $(QUARTUS_BIN_DIR)"
	@echo "PROJECT         = $(PROJECT)"
	@echo "REVISION        = $(REVISION)"
	@echo "CNT_PROJECT     = $(CNT_PROJECT)"
	@echo "CNT_REVISION    = $(CNT_REVISION)"

# NOTE: example run analysis one file in Quartus:
# Command: quartus_map --read_settings_files=on
#   --write_settings_files=off FObusPCIe -c FObusPCIe4x --analyze_file=<file_name>
