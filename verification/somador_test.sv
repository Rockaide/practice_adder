`ifndef SOMADOR_TEST_SV
`define SOMADOR_TEST_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class somador_test extends uvm_test;
    
    `uvm_component_utils(somador_test)

    somador_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = somador_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        somador_seq seq;
        
        // Prevent the simulation from ending
        phase.raise_objection(this);
        
        // Create and start the sequence
        `uvm_info("TEST", "Starting the somador sequence...", UVM_LOW)
        seq = somador_seq::type_id::create("seq");
        seq.start(env.agent.sequencer);
        
        // Allow time for the final transaction to propagate through the DUV
        #500ns; 
        
        // Allow the simulation to end
        phase.drop_objection(this);
    endtask

endclass

`endif
