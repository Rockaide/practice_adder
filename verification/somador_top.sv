`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

module somador_top;

    // Clock and Reset Generation
    logic clk;
    logic rst_n;

    initial begin
        clk = 0;
        forever #50ns clk = ~clk; // 10MHz clock for baseline testing
    end

    initial begin
        rst_n = 0;
        #25ns;
        rst_n = 1;
    end

    // Instantiate the Interface
    somador_if vif(clk, rst_n);

    // Instantiate the VHDL DUV
    somador #(
        .WIDTH(8)
    ) DUV (
        .clk     (vif.clk),
        .rst_n   (vif.rst_n),
        .carry_i (vif.carry_i),
        .a_i     (vif.a_i),
        .b_i     (vif.b_i),
        .carry_o (vif.carry_o),
        .sum_o   (vif.sum_o)
    );

    
    
    // Register the interface in the UVM Configuration Database and start the test
    initial begin
        uvm_config_db#(virtual somador_if)::set(null, "*", "vif", vif);
        
        // Start the UVM test
        run_test("somador_test"); 
    end

    // Waveform dumping for debugging
    initial begin
        $shm_open("uvm_waves.shm");
        $shm_probe("AC");
    end

endmodule
