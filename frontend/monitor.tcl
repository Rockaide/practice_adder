# frontend/monitor.tcl

set freq $::env(FREQ_MHZ)
set lib  $::env(LIB_TYPE)

# Point the output to the new subdirectory
set filename "dump_files/signal_dump_${lib}_${freq}.txt"

set ::dump_file [open $filename w]

# 1. Open the dynamically named text file for writing
set ::dump_file [open $filename w]

# 2. Log the initial value at time 0
set initial_val [value {DUV.\sum_temp_reg[2] .D}]
set initial_time [time]
puts $::dump_file "$initial_time : $initial_val"

# 3. Create a stop callback
stop -create -object {DUV.\sum_temp_reg[2] .D} -execute {
    set current_val  [value {DUV.\sum_temp_reg[2] .D}]
    set current_time [time]
    puts $::dump_file "$current_time : $current_val"
}

# 4. Run the simulation
run 100ns

# 5. Clean up and exit
close $::dump_file
exit
