`ifndef SOMADOR_SEQ_SV
`define SOMADOR_SEQ_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class somador_seq extends uvm_sequence #(somador_item);
    
    `uvm_object_utils(somador_seq)

    function new(string name = "somador_seq");
        super.new(name);
    endfunction

    // The body task is where the sequence execution happens
    virtual task body();
        int fd;
        int a_val, b_val;
        int scan_result;
        bit current_carry = 0;
        somador_item req;
        string file_path;

        // Fetch the path from the simulator arguments. Default to local if not found.
        if (!$value$plusargs("VETOR_PATH=%s", file_path)) begin
            file_path = "vetor.txt"; 
        end

        fd = $fopen(file_path, "r");
        if (fd == 0) begin
            `uvm_fatal("SEQ", $sformatf("Could not open %s! Check the path.", file_path))
        end

        `uvm_info("SEQ", "Starting to read vetor.txt...", UVM_LOW)

        // Loop until end of file
        while (!$feof(fd)) begin
            // Read two hex values separated by a space
            scan_result = $fscanf(fd, "%h %h\n", a_val, b_val);
            
            if (scan_result == 2) begin
                // 1. Create the transaction item
                req = somador_item::type_id::create("req");
                
                // 2. Request permission from sequencer to send
                start_item(req);
                
                // 3. Populate the item with our file data
                req.a_i = a_val;
                req.b_i = b_val;
                req.carry_i = current_carry;
                
                // 4. Send the item to the driver
                finish_item(req);

                // Mimic the VHDL logic: toggle carry for the next iteration
                current_carry = ~current_carry;
            end
        end

        // Clean up
        $fclose(fd);
        `uvm_info("SEQ", "Finished reading vetor.txt.", UVM_LOW)
    endtask

endclass

`endif
