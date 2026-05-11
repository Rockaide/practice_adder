`ifndef SOMADOR_COV_SV
`define SOMADOR_COV_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class somador_cov extends uvm_subscriber #(somador_item);
    
    `uvm_component_utils(somador_cov)

    somador_item req;

    // Define the coverage rules
    covergroup cg_adder;
        option.per_instance = 1;

        // Check if extreme and mid values of A are tested
        cp_a: coverpoint req.a_i {
            bins min = {8'h00};
            bins max = {8'hFF};
            bins mid = {[8'h01:8'hFE]};
        }

        // Check if extreme and mid values of B are tested
        cp_b: coverpoint req.b_i {
            bins min = {8'h00};
            bins max = {8'hFF};
            bins mid = {[8'h01:8'hFE]};
        }

        // Check if both carry_in states are tested
        cp_cin: coverpoint req.carry_i {
            bins zero = {1'b0};
            bins one  = {1'b1};
        }

        // Check if carry_out is ever triggered
        cp_cout: coverpoint req.carry_o {
            bins zero = {1'b0};
            bins one  = {1'b1};
        }

        // Cross coverage: Ensure min/max A values are tested against min/max B values
        cross_ab: cross cp_a, cp_b;
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg_adder = new();
    endfunction

    // This function is automatically called by the monitor's analysis port
    virtual function void write(somador_item t);
        req = t;
        cg_adder.sample(); // Execute the coverage measurement
    endfunction
    
    // Extracts and prints the coverage percentage at the end of the simulation
    // virtual function void report_phase(uvm_phase phase);
     //    super.report_phase(phase);
    //     `uvm_info("COVERAGE", $sformatf("Adder Functional Coverage: %0.2f%%", cg_adder.get_inst_coverage()), UVM_NONE)
    // endfunction
    
    // Extracts and prints a detailed coverage breakdown at the end of the simulation
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        
        `uvm_info("COV_REPORT", "========================================", UVM_NONE)
        `uvm_info("COV_REPORT", "      UVM COVERAGE BREAKDOWN              ", UVM_NONE)
        `uvm_info("COV_REPORT", "========================================", UVM_NONE)
        `uvm_info("COV_REPORT", $sformatf("TOTAL ADDER COVERAGE : %0.2f%%", cg_adder.get_inst_coverage()), UVM_NONE)
        `uvm_info("COV_REPORT", "----------------------------------------", UVM_NONE)
        `uvm_info("COV_REPORT", $sformatf("-> Operand A (cp_a)  : %0.2f%%", cg_adder.cp_a.get_coverage()), UVM_NONE)
        `uvm_info("COV_REPORT", $sformatf("-> Operand B (cp_b)  : %0.2f%%", cg_adder.cp_b.get_coverage()), UVM_NONE)
        `uvm_info("COV_REPORT", $sformatf("-> Carry In (cp_cin) : %0.2f%%", cg_adder.cp_cin.get_coverage()), UVM_NONE)
        `uvm_info("COV_REPORT", $sformatf("-> Carry Out(cp_cout): %0.2f%%", cg_adder.cp_cout.get_coverage()), UVM_NONE)
        `uvm_info("COV_REPORT", $sformatf("-> Cross AxB         : %0.2f%%", cg_adder.cross_ab.get_coverage()), UVM_NONE)
        `uvm_info("COV_REPORT", "========================================", UVM_NONE)
    endfunction

endclass

`endif
