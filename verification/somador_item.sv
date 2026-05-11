`ifndef SOMADOR_ITEM_SV
`define SOMADOR_ITEM_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class somador_item extends uvm_sequence_item;

    // -----------------------------------------
    // Inputs (Stimulus)
    // -----------------------------------------
    rand bit [7:0] a_i;
    rand bit [7:0] b_i;
    rand bit       carry_i;

    // -----------------------------------------
    // Outputs (Observed responses)
    // -----------------------------------------
    bit [7:0] sum_o;
    bit       carry_o;

    // UVM Automation Macros for easy copying, comparing, and printing
    `uvm_object_utils_begin(somador_item)
        `uvm_field_int(a_i, UVM_ALL_ON)
        `uvm_field_int(b_i, UVM_ALL_ON)
        `uvm_field_int(carry_i, UVM_ALL_ON)
        `uvm_field_int(sum_o, UVM_ALL_ON)
        `uvm_field_int(carry_o, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "somador_item");
        super.new(name);
    endfunction

endclass

`endif
