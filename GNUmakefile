#   ****************    Klondike River die      ************************
#
#       Organisation:   Chipforge
#                       Germany / European Union
#
#       Profile:        Chipforge focus on fine System-on-Chip Cores in
#                       Verilog HDL Code which are easy understandable and
#                       adjustable. For further information see
#                               www.chipforge.org
#                       there are projects from small cores up to PCBs, too.
#
#       File:           $(PROJECT)/GNUmakefile
#
#       Purpose:        Root Makefile
#
#   ****************    GNU Make 3.80 Source Code       ****************
#
#   ////////////////////////////////////////////////////////////////////
#
#       Copyright (c) 2021 by
#                       SANKOWSKI, Hagen - klondike@nospam.chipforge.org
#
#       This Source Code Library is licensed under the Libre Silicon
#       public license; you can redistribute it and/or modify it under
#       the terms of the Libre Silicon public license as published by
#       the Libre Silicon alliance, either version 1 of the License, or
#       (at your option) any later version.
#
#       This design is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#       See the Libre Silicon Public License for more details.
#
#   ////////////////////////////////////////////////////////////////////

#   project root directory, relative, used inside include.mk file
PRD =               .

#   common definitions

include $(PRD)/include.mk

#   ----------------------------------------------------------------
#                       DEFAULT TARGETS
#   ----------------------------------------------------------------

#   display help screen if no target is specified

.PHONY: help
help:
	#   ----------------------------------------------------------
	#              available targets:
	#   ----------------------------------------------------------
	#
	#   help       - print this help screen
	#   dist       - build a tarball with all important files
	#   clean      - clean up all intermediate files
	#
	#   <testcase> - run this specified test case (see list below)
	#   <testcase> [MODE=batch|report|gui] - run test in batch mode (default: $(MODE))
	#   <testcase> [STEP=rtl|pre|post] - run test on rtl step (default: $(STEP))
	#   tests      - run all test cases (see list below)
	#
	#   ----------------------------------------------------------
	#              available testcases:
	#   ----------------------------------------------------------
	#
	#   $(TESTS)
	#

#   make archiv by building a tarball with all important files

DISTRIBUTION =  ./include.mk \
                ./GNUmakefile \
                $(SOURCEDIR) \
                $(TBENCHDIR)

.PHONY: dist
dist: clean
	#   ---- build a tarball with all important files ----
	$(TAR) -cvf $(PROJECT)_$(DATE).tgz $(DISTRIBUTION)

.PHONY: clean
clean:
	#   ---- clean up all intermediate files ----
	$(MAKE) -C $(SIMULATIONDIR) -f simulation.mk clean 
#	$(MAKE) -C $(SYNTHESISDIR) -f synthesis.mk clean
#	$(MAKE) -C $(BACKENDDIR) -f backend.mk clean

#   ----------------------------------------------------------------
#                       BUILD MAIN TARGETS 
#   ----------------------------------------------------------------

.PHONY: tests
tests: $(TESTS)

.PHONY: netlist
netlist:
	$(MAKE) -C $(SYNTHESISDIR) -f synthesis.mk $@

.PHONY: par
par:
	$(MAKE) -C $(BACKENDDIR) -f backend.mk $@

.PHONY: backend
backend:
	$(MAKE) -C $(BACKENDDIR) -f backend.mk $@

.PHONY: all
all: netlist par backend

%:
ifeq ($(MODE), report)
	$(MAKE) -C $(SIMULATIONDIR) -f simulation.mk STEP=$(STEP) MODE=$(MODE) $@  > $(SIMULATIONDIR)/$(STEP)/$@.log
else
	$(MAKE) -C $(SIMULATIONDIR) -f simulation.mk STEP=$(STEP) MODE=$(MODE) $@
endif

#             ;;       .;;;. ;; ;; ;; ;;;;. ;;;; ;;;. ;;;;. .;;;. ;;;;
#             ;;;;;;   ;; ;; ;; ;; ;; ;; ;; ;;  ;; ;; ;; ;; ;; ;; ;;
#          ;, ;;       ;;    ;;;;; ;; ;; ;; ;;; ;; ;; ;;;;' ;;,,, ;;;
#       ;;;;;;;;;;;;   ;; ;; ;; ;; ;; ;;;;' ;;  ;; ;; ;;';; ;; ;; ;;
#          :' ;;       ';;;' ;; ;; ;; ;;    ;;  ';;;' ;; ;; ';;;; ;;;;
