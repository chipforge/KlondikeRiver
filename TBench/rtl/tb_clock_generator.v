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
//      File:           TBench/verilog/tb_clock_generator.v
//
//      Purpose:        Clock Generator testbench
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

//  Event principles:
//
//       one clock cycle
//      |---------------|
//       _______         _______         _______
//      ||      |       ||      |       ||      |
//      ||      |       ||      |       ||      |       clk_tb
//  ____||      |_______||      |_______||      |_____
//
//                   ^ STROBE        ^ STROBE
//
//                   ^ write here    ^ write here
//                                   ^ read here
//                   |---------------|
//                    one task cycle

`include "timescale.v"

//  --------------------------------------------------------------------
//                          CONFIGURATION
//  --------------------------------------------------------------------

`define                 TIMELIMIT       1_000_000

//  ----------------    global signal   --------------------------------

`define                 CLK_PERIOD      10
`define                 STROBE          (0.8 * `CLK_PERIOD)
`define                 RST_PERIOD      (10  * `CLK_PERIOD)

module tb_clock_generator (
    input [7:1]         i_clkdiv,
    input [63:0]        i_clkperiod
);

//  ----------------    TBench signal   --------------------------------

    reg                 clk_tb = ~0;        // start with falling edge

always @ (clk_tb)
begin
    clk_tb <= #(`CLK_PERIOD/2) ~clk_tb;
end

    reg                 rst_tb = ~0;        // start inactive

initial
begin
    #1;
    // activate reset
    rst_tb <= ~0;
    rst_tb <= #(`RST_PERIOD) 0;
end

//  ----------------    TBench logic signal     ------------------------

    // configuration signals
    reg                 r_clkon = 'b0;      // start disabled

    wire                w_clk;

//  ----------------    device-under-test (DUT) ------------------------

clock_generator dut (
    //  ----    configuration   ------------
    .i_clkdiv           (i_clkdiv),
    .i_clkon            (r_clkon),
    //  ----    global signals  ------------
    .clk                (w_clk),
    .rst                (rst_tb));

//  ----------------    auxilaries  ------------------------------------

    reg time            current, last;

always @ (posedge w_clk)
begin
    last <= current;
    current <= $time;
end

//  calculate output clock period out of measured delay between to posedges
    wire [63:0]         clkperiod;

assign clkperiod = (current - last);

//  ----------------    test functionality  ----------------------------

    integer             failed = 0;         // failed test item counter

task t_initialize;
begin
    #1;
    @ (negedge rst_tb);
    @ (posedge clk_tb);
    #(`STROBE);
end
endtask

task t_idle;
    input integer loops;
begin
    repeat (loops)
        begin
        @ (posedge clk_tb);
        #(`STROBE);
        end
end
endtask

task t_enable;
begin
    @ (posedge clk_tb);
    #(`STROBE);
    r_clkon <= 'b1;
    $display("\t%m: expected clock period: %d", i_clkperiod);
end
endtask

task t_disable;
begin
    @ (posedge clk_tb);
    #(`STROBE);
    r_clkon <= 'b0;
    $display("\t%m: oscillator switched off");
end
endtask

function f_check;
    input [63:0] target;
    input [63:0] result;
begin
    if (result < (0.95 * target))
        f_check = 1;
    else if (result > (1.05 * target))
        f_check = 1;
    else
        f_check = 0;
    $display("\t%m: measured clock period: %d", result);
end
endfunction

initial
begin
    t_initialize;

    t_enable;
    t_idle(1_000);
    failed = failed + f_check(i_clkperiod, clkperiod);
    t_idle(1_000);
    failed = failed + f_check(i_clkperiod, clkperiod);
    t_disable;


    #1;
    if (failed)
        $display("\t%m: *failed* %d times", failed);
    else
        $display("\t%m: *well done*");
    $finish;
end

//  ----------------    testbench flow control  ------------------------

initial
begin
    $dumpfile(`DUMPFILE);
    $dumpvars;

    #(`TIMELIMIT);
    $display("\t%m: *time limit (%t) reached*", $time);
    $finish;
end

endmodule

//            ;;       .;;;. ;; ;; ;; ;;;;. ;;;; ;;;. ;;;;. .;;;. ;;;;
//            ;;;;;;   ;; ;; ;; ;; ;; ;; ;; ;;  ;; ;; ;; ;; ;; ;; ;;
//         ;, ;;       ;;    ;;;;; ;; ;; ;; ;;; ;; ;; ;;;;' ;;,,, ;;;
//      ;;;;;;;;;;;;   ;; ;; ;; ;; ;; ;;;;' ;;  ;; ;; ;;';; ;; ;; ;;
//         :' ;;       ';;;' ;; ;; ;; ;;    ;;  ';;;' ;; ;; ';;;; ;;;;
