`ifndef SOMADOR_IF_SV
`define SOMADOR_IF_SV

`timescale 1ns/1ps

interface somador_if (input logic clk, input logic rst_n);

    // -----------------------------------------
    // Signals matching the VHDL DUV ports
    // -----------------------------------------
    logic       carry_i;
    logic [7:0] a_i;
    logic [7:0] b_i;
    logic       carry_o;
    logic [7:0] sum_o;

    // -----------------------------------------
    // Clocking block for the Driver
    // Ensures inputs are driven synchronously
    // -----------------------------------------
    clocking cb_drv @(posedge clk);
        default input #1step output #1ns;
        output carry_i, a_i, b_i;
        input  carry_o, sum_o;
    endclocking

    // -----------------------------------------
    // Clocking block for the Monitor
    // Ensures signals are sampled cleanly
    // -----------------------------------------
    clocking cb_mon @(posedge clk);
        default input #1step;
        input carry_i, a_i, b_i, carry_o, sum_o;
    endclocking

endinterface

`endif
