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
#       File:           $(PROJECT)/Simulation/simulation.mk
#
#       Purpose:        Makefile for Simulation stuff
#
#   ****************    GNU Make 3.80 Source Code       ****************
#
#   ///////////////////////////////////////////////////////////////////
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
#   ///////////////////////////////////////////////////////////////////

#   project root directory, relative, used inside include.mk file
PRD =               ..

#   common definitions

include $(PRD)/include.mk

#   3rd party simulation tool variables

ICARUS ?=       iverilog -g2 # -Wall
VPP ?=          vvp # -v
GTKWAVE ?=      gtkwave

#   other simulation stuff

DUMPPATH ?=     $(SIMULATIONDIR)/$(STEP)

.PHONY: clean
clean:
	-$(RM) $(SIMULATIONDIR)/*/*.vcd
	-$(RM) $(SIMULATIONDIR)/*/*.vpp
	-$(RM) $(SIMULATIONDIR)/*/*.log

#   ----------------------------------------------------------------
#                       RUN VERILOG SIMULATION
#   ----------------------------------------------------------------

tc_clock_generator_%:   PROJECT_DEFINES += -DDUMPFILE=\"$(DUMPPATH)/$@.vcd\" -DTALKATIVE_ENGINE
tc_clock_generator_%:   $(TBENCHDIR)/$(STEP)/tb_clock_generator.v
	$(ICARUS) $(PROJECT_DEFINES) -I $(INCLUDEDIR)/$(STEP) -y $(LIBRARYDIR)/$(STEP) -y $(SOURCESDIR)/$(STEP) -y $(TBENCHDIR)/$(STEP) -o $(SIMULATIONDIR)/$(STEP)/$@.vpp $< $(TBENCHDIR)/$(STEP)/$@.v
	$(VPP) $(SIMULATIONDIR)/$(STEP)/$@.vpp
ifeq ($(MODE), gui)
	$(GTKWAVE) -f $(DUMPPATH)/$@.vcd -a $(SIMULATIONDIR)/$(STEP)/$@.do
endif

#             ;;       .;;;. ;; ;; ;; ;;;;. ;;;; ;;;. ;;;;. .;;;. ;;;;
#             ;;;;;;   ;; ;; ;; ;; ;; ;; ;; ;;  ;; ;; ;; ;; ;; ;; ;;
#          ;, ;;       ;;    ;;;;; ;; ;; ;; ;;; ;; ;; ;;;;' ;;,,, ;;;
#       ;;;;;;;;;;;;   ;; ;; ;; ;; ;; ;;;;' ;;  ;; ;; ;;';; ;; ;; ;;
#          :' ;;       ';;;' ;; ;; ;; ;;    ;;  ';;;' ;; ;; ';;;; ;;;;
