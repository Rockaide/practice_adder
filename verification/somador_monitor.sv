`ifndef SOMADOR_MONITOR_SV
`define SOMADOR_MONITOR_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class somador_monitor extends uvm_monitor;
    
    `uvm_component_utils(somador_monitor)

    virtual somador_if vif;
    uvm_analysis_port #(somador_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if (!uvm_config_db#(virtual somador_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("MON", "Could not get vif")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        somador_item item;
        forever begin
            @(vif.cb_mon);
            
            // Wait a brief moment to ensure outputs have settled (post-clock edge)
            #1ns; 
            
            item = somador_item::type_id::create("item");
            item.a_i = vif.cb_mon.a_i;
            item.b_i = vif.cb_mon.b_i;
            item.carry_i = vif.cb_mon.carry_i;
            item.sum_o = vif.cb_mon.sum_o;
            item.carry_o = vif.cb_mon.carry_o;
            
            // Broadcast the sampled transaction
            ap.write(item);
        end
    endtask

endclass

`endif
