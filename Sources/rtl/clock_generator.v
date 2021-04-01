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
//      File:           Sources/rtl/clock_generator.v
//
//      Purpose:        generate clock by Ring Oscillator
//
//  ****************    IEEE Std 1364-2001 (Verilog HDL)    ************
//
//  ////////////////////////////////////////////////////////////////////
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


//  --------------------------------------------------------------------
//                      DESCRIPTION
//  --------------------------------------------------------------------

//  Principle Schematic of this configurable Ring Oscillator, check
//  https://en.wikipedia.org/wiki/Ring_oscillator
//                                                                /|
//  .-----------------------------------------------------------o< |--------.
//  |   +---+                                                     \|        |
//  '---| & |       |\  |\      |\                                      5   |
//      |   |o--*---| >o| >o----| \         |\  |\  |\  |\      |\   stages |
//    .-|   |   |   |/  |/      |  |o---*---| >o| >o| >o| >o----| \   more  |
//    | +---+   '---------------| /     |   |/  |/  |/  |/      |  |o--///--*
//    |                         |/|     '-----------------------| /         |   |\
//  +---+                         |                             |/|         '---| |o--> clk
//  |   |                       +---+                             |             |/
//  +---+                       |   |                           +---+
//  clkon                       +---+                           |   |
//                            clkdiv[1]                         +---+
//                                                            clkdiv[2]
//              |<----------------->|
//                   2exp1 stage        |<------------------------->|
//                  w/ 2 inverters              2exp2 stage
//                                             w/ 4 inverters
//
//  All stages can be bypassed. All bypasses can be configured - more or less -
//  dynamically. Assure that no wave front occures inside the inverter chain
//  while they are re-configured.
//  The recommended method is to switch off the oscillator with the clkon
//  configuration bit and wait at least half the last clock period to running out
//  all traveling wave fronts before changing the clkdiv configuration bits and
//  enable the ring oscillator with clkon again.
//
//  Configuration Table
//  stage      bit#      inverters
//  ----------------------------------
//  2exp1       1            2 + 9
//  2exp2       2            4 + 9
//  2exp3       3            8 + 9
//  2exp4       4           14 + 9
//  2exp5       5           32 + 9
//  2exp6       6           64 + 9
//  2exp7       7          128 + 9

//  --------------------------------------------------------------------
//                      CONFIGURATION
//  --------------------------------------------------------------------

//  ----------------    Debug Switches  --------------------------------

//`define               CODINGSTYLE_FPGA 1  // less global signal usage
//`define               TALKATIVE        1  // be more talkative

//  --------------------------------------------------------------------
//                      MODULE
//  --------------------------------------------------------------------

`include "timescale.v"

module clock_generator (

    //  ----    configuration   ------------

    input [7:1]         i_clkdiv,
    input               i_clkon,

    //  ----    global signals  ------------

    output              clk,
    input               rst);

    wire                w_feedback;

//  ------------    ring oscillator (enable)    -----------------------

    wire                w_enabled;

    // enable chain of inverters to toggle
    NAND2 u_nand (w_enabled, i_clkon, w_feedback);

//  ------------    ring oscillator (2 exp 1)   -----------------------

    localparam          c_stages_2exp1 = 2;

    wire [c_stages_2exp1:0] w_inverter_2exp1;
    wire                w_2exp1;

assign w_inverter_2exp1[c_stages_2exp1] = w_enabled;

genvar j;

generate for (j=0; j<c_stages_2exp1; j=j+1)
begin: exp1

    // chain of inverters
    NOT u_not (w_inverter_2exp1[j], w_inverter_2exp1[j+1]);

end
endgenerate

    // bypass this part with clkdiv[1] == 'b0
    MUXI21 u_2exp1 (w_2exp1, w_inverter_2exp1[0], w_enabled, i_clkdiv[1]);

//  ------------    ring oscillator (2 exp 2)   -----------------------

    localparam          c_stages_2exp2 = 4;

    wire [c_stages_2exp2:0] w_inverter_2exp2;
    wire                w_2exp2;

assign w_inverter_2exp2[c_stages_2exp2] = w_2exp1;

generate for (j=0; j<c_stages_2exp2; j=j+1)
begin: exp2

    // chain of inverters
    NOT u_not (w_inverter_2exp2[j], w_inverter_2exp2[j+1]);

end
endgenerate

    // bypass this part with clkdiv[2] == 'b0
    MUXI21 u_2exp2 (w_2exp2, w_inverter_2exp2[0], w_2exp1, i_clkdiv[2]);

//  ------------    ring oscillator (2 exp 3)   -----------------------

    localparam          c_stages_2exp3 = 8;

    wire [c_stages_2exp3:0] w_inverter_2exp3;
    wire                w_2exp3;

assign w_inverter_2exp3[c_stages_2exp3] = w_2exp2;

generate for (j=0; j<c_stages_2exp3; j=j+1)
begin: exp3

    // chain of inverters
    NOT u_not (w_inverter_2exp3[j], w_inverter_2exp3[j+1]);

end
endgenerate

    // bypass this part with clkdiv[3] == 'b0
    MUXI21 u_2exp3 (w_2exp3, w_inverter_2exp3[0], w_2exp2, i_clkdiv[3]);

//  ------------    ring oscillator (2 exp 4)   -----------------------

    localparam          c_stages_2exp4 = 16;

    wire [c_stages_2exp4:0] w_inverter_2exp4;
    wire                w_2exp4;

assign w_inverter_2exp4[c_stages_2exp4] = w_2exp3;

generate for (j=0; j<c_stages_2exp4; j=j+1)
begin: exp4

    // chain of inverters
    NOT u_not (w_inverter_2exp4[j], w_inverter_2exp4[j+1]);

end
endgenerate

    // bypass this part with clkdiv[4] == 'b0
    MUXI21 u_2exp4 (w_2exp4, w_inverter_2exp4[0], w_2exp3, i_clkdiv[4]);

//  ------------    ring oscillator (2 exp 5)   -----------------------

    localparam          c_stages_2exp5 = 32;

    wire [c_stages_2exp5:0] w_inverter_2exp5;
    wire                w_2exp5;

assign w_inverter_2exp5[c_stages_2exp5] = w_2exp4;

generate for (j=0; j<c_stages_2exp5; j=j+1)
begin: exp5

    // chain of inverters
    NOT u_not (w_inverter_2exp5[j], w_inverter_2exp5[j+1]);

end
endgenerate

    // bypass this part with clkdiv[5] == 'b0
    MUXI21 u_2exp5 (w_2exp5, w_inverter_2exp5[0], w_2exp4, i_clkdiv[5]);

//  ------------    ring oscillator (2 exp 6)   -----------------------

    localparam          c_stages_2exp6 = 64;

    wire [c_stages_2exp6:0] w_inverter_2exp6;
    wire                w_2exp6;

assign w_inverter_2exp6[c_stages_2exp6] = w_2exp5;

generate for (j=0; j<c_stages_2exp6; j=j+1)
begin: exp6

    // chain of inverters
    NOT u_not (w_inverter_2exp6[j], w_inverter_2exp6[j+1]);

end
endgenerate

    // bypass this part with clkdiv[6] == 'b0
    MUXI21 u_2exp6 (w_2exp6, w_inverter_2exp6[0], w_2exp5, i_clkdiv[6]);

//  ------------    ring oscillator (2 exp 7)   -----------------------

    localparam          c_stages_2exp7 = 128;

    wire [c_stages_2exp7:0] w_inverter_2exp7;
    wire                w_2exp7;

assign w_inverter_2exp7[c_stages_2exp7] = w_2exp6;

generate for (j=0; j<c_stages_2exp7; j=j+1)
begin: exp7

    // chain of inverters
    NOT u_not (w_inverter_2exp7[j], w_inverter_2exp7[j+1]);

end
endgenerate

    // bypass this part with clkdiv[7] == 'b0
    MUXI21 u_2exp7 (w_2exp7, w_inverter_2exp7[0], w_2exp6, i_clkdiv[7]);

//  ------------    output matching     -------------------------------

//assign w_feedback = w_2exp7;
    NOT u_feedback (w_feedback, w_2exp7);

//assign clk = w_feedback;
    NOT u_clk (clk, w_feedback);

endmodule

//            ;;       .;;;. ;; ;; ;; ;;;;. ;;;; ;;;. ;;;;. .;;;. ;;;;
//            ;;;;;;   ;; ;; ;; ;; ;; ;; ;; ;;  ;; ;; ;; ;; ;; ;; ;;
//         ;, ;;       ;;    ;;;;; ;; ;; ;; ;;; ;; ;; ;;;;' ;;,,, ;;;
//      ;;;;;;;;;;;;   ;; ;; ;; ;; ;; ;;;;' ;;  ;; ;; ;;';; ;; ;; ;;
//         :' ;;       ';;;' ;; ;; ;; ;;    ;;  ';;;' ;; ;; ';;;; ;;;;
