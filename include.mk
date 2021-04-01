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
#       File:           $(PROJECT)/include.mk
#
#       Purpose:        include common definitions
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

#   ----------------------------------------------------------------
#                       DEFINITIONS
#   ----------------------------------------------------------------

#   project name

PROJECT =       KlondikeRiver
PROJECT_DEFINES =

#   directory paths

DOCUMENTSDIR =  $(PRD)/Documents
INCLUDEDIR =    $(PRD)/Sources
LIBRARYDIR =    $(PRD)/Library
SIMULATIONDIR = $(PRD)/Simulation
SOURCESDIR =    $(PRD)/Sources
SYNTHESISDIR =  $(PRD)/Synthesis
TBENCHDIR =     $(PRD)/TBench

#   processing variables
STEP ?= rtl
MODE ?= batch

#   tool variables

CAT ?=          @cat
MV ?=           mv
RM ?=           rm -f
TAR ?=          tar -zh
GREP ?=         grep
SED ?=          sed
MKDIR ?=        mkdir -p
DATE :=         $(shell date +%Y%m%d)

#   collect available tests

TESTS := $(notdir $(basename $(wildcard $(TBENCHDIR)/$(STEP)/tc_*.v)))

#             ;;       .;;;. ;; ;; ;; ;;;;. ;;;; ;;;. ;;;;. .;;;. ;;;;
#             ;;;;;;   ;; ;; ;; ;; ;; ;; ;; ;;  ;; ;; ;; ;; ;; ;; ;;
#          ;, ;;       ;;    ;;;;; ;; ;; ;; ;;; ;; ;; ;;;;' ;;,,, ;;;
#       ;;;;;;;;;;;;   ;; ;; ;; ;; ;; ;;;;' ;;  ;; ;; ;;';; ;; ;; ;;
#          :' ;;       ';;;' ;; ;; ;; ;;    ;;  ';;;' ;; ;; ';;;; ;;;;
