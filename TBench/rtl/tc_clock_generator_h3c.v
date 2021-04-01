//  ****************    Klondike River die      ************************
//
//      Organisation:   Chipforge
//                      Germany / European Union
//
//      Profile:        Chipforge focus on fine System-on-Chip Cores in
//                      Verilog HDL Code which are easy understandable and
//                      adjustable. For further information see
//                              www.chipforge.org
//                      there are projects from small cores up to PCBs, too.
//
//      File:           TBench/rtl/tc_clock_generator_h3c.v
//
//      Purpose:        Clock Generation Testcase with 'h3c divider
//
//  ****************    IEEE Std 1364-2001 (Verilog HDL)    ************
//
//  ///////////////////////////////////////////////////////////////////
//
//      Copyright (c) 2021 by
//                      SANKOWSKI, Hagen - klondike@nospam.chipforge.org
//
//      This Source Code Library is licensed under the Libre Silicon
//      public license; you can redistribute it and/or modify it under
//      the terms of the Libre Silicon public license as published by
//      the Libre Silicon alliance, either version 1 of the License, or
//      (at your option) any later version.
//
//      This design is distributed in the hope that it will be useful,
//      but WITHOUT ANY WARRANTY; without even the implied warranty of
//      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//      See the Libre Silicon Public License for more details.
//
//  ////////////////////////////////////////////////////////////////////

//  -------------------------------------------------------------------
//                      TEST
//  -------------------------------------------------------------------

module tc_clock_generator_h3c(
    // tests do not have ports
);

    localparam          UNITDELAY = 1;

    // values to test
    localparam [7:1]    c_clkdiv = 7'h3c;

    // calculate number of inverting gates with
    // regular inverters + enabling NAND2 + inverting multiplexors + feedback driver
    localparam [63:0]   c_number_of_inverters = {c_clkdiv,1'b1} + 7 + 1;

    // expected result, two half-waves
    localparam [63:0]   c_clkperiod = (2*c_number_of_inverters * UNITDELAY);

//      ------------    test bench  -------------------------------

tb_clock_generator tbench (
    .i_clkdiv           (c_clkdiv),
    .i_clkperiod        (c_clkperiod));

endmodule

//            ;;       .;;;. ;; ;; ;; ;;;;. ;;;; ;;;. ;;;;. .;;;. ;;;;
//            ;;;;;;   ;; ;; ;; ;; ;; ;; ;; ;;  ;; ;; ;; ;; ;; ;; ;;
//         ;, ;;       ;;    ;;;;; ;; ;; ;; ;;; ;; ;; ;;;;' ;;,,, ;;;
//      ;;;;;;;;;;;;   ;; ;; ;; ;; ;; ;;;;' ;;  ;; ;; ;;';; ;; ;; ;;
//         :' ;;       ';;;' ;; ;; ;; ;;    ;;  ';;;' ;; ;; ';;;; ;;;;
