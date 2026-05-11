`ifndef SOMADOR_DRIVER_SV
`define SOMADOR_DRIVER_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class somador_driver extends uvm_driver #(somador_item);
    
    `uvm_component_utils(somador_driver)

    virtual somador_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual somador_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("DRV", "Could not get vif")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            // Wait for the next item from the sequence
            seq_item_port.get_next_item(req);
            
            // Drive the signals synchronously using the clocking block
            @(vif.cb_drv);
            vif.cb_drv.a_i <= req.a_i;
            vif.cb_drv.b_i <= req.b_i;
            vif.cb_drv.carry_i <= req.carry_i;
            
            // Notify sequence that the item is done
            seq_item_port.item_done();
        end
    endtask

endclass

`endif
