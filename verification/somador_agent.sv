`ifndef SOMADOR_AGENT_SV
`define SOMADOR_AGENT_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class somador_agent extends uvm_agent;
    
    `uvm_component_utils(somador_agent)

    somador_driver driver;
    somador_monitor monitor;
    uvm_sequencer #(somador_item) sequencer;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        monitor = somador_monitor::type_id::create("monitor", this);
        
        // Only build driver and sequencer if the agent is active
        if (get_is_active() == UVM_ACTIVE) begin
            driver = somador_driver::type_id::create("driver", this);
            sequencer = uvm_sequencer#(somador_item)::type_id::create("sequencer", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (get_is_active() == UVM_ACTIVE) begin
            // Connect the driver to the sequencer
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction

endclass

`endif
