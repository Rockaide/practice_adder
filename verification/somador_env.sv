`ifndef SOMADOR_ENV_SV
`define SOMADOR_ENV_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class somador_env extends uvm_env;
    
    `uvm_component_utils(somador_env)

    somador_agent agent;
    somador_cov   cov;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = somador_agent::type_id::create("agent", this);
        cov   = somador_cov::type_id::create("cov", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Connect the monitor's broadcast port to the coverage subscriber's input
        agent.monitor.ap.connect(cov.analysis_export);
    endfunction

endclass

`endif
