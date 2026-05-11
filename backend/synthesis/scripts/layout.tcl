# Last update: 2026/03/08

#-----------------------------------------------------------------------------
# Fetch Dynamic Environment Variables from Makefile
#-----------------------------------------------------------------------------
set design      $env(DESIGNS)
set freq        $env(FREQ_MHZ)
set lib         $env(LIB_TYPE)
set runtime     $env(RUNTIME)
set PROJECT_DIR $env(PROJECT_DIR)
set BACKEND_DIR $env(BACKEND_DIR)
set LAYOUT_DIR  $env(LAYOUT_DIR)
set LEF_DIR     $env(LEF_DIR)
set TECH_DIR    $env(TECH_DIR)

# Define dynamic output paths for this specific run
set OUT_DELIV   "${LAYOUT_DIR}/deliverables/${design}_${lib}_${freq}_${runtime}"
set OUT_RPT     "${LAYOUT_DIR}/reports/${design}_${lib}_${freq}_${runtime}"

# Calculate clock period for reporting
set period_clk  [expr {1000.0 / $freq}]

#-----------------------------------------------------------------------------
# Load variables and paths
#-----------------------------------------------------------------------------
source ${BACKEND_DIR}/synthesis/scripts/common/path.tcl
source ${BACKEND_DIR}/synthesis/scripts/common/variables.tcl

#-----------------------------------------------------------------------------
# Suppressing messages
#-----------------------------------------------------------------------------
set_message -id TECHLIB-302 -suppress
set_message -id IMPDB-6501 -suppress 
set_message -id IMPFP-3961 -suppress 
set_message -id IMPOPT-3195 -suppress
set_message -id IMPSP-9025 -suppress 
set_message -id IMPLF-200 -suppress 
set_message -id IMPEXT-3493 -suppress 
set_message -id IMPEXT-6166 -suppress 
set_message -id IMPSP-5217 -suppress 

#-----------------------------------------------------------------------------
# Initiates the design files (netlist, LEFs, timing libraries)
#-----------------------------------------------------------------------------
set_db init_power_nets $NET_ONE
set_db init_ground_nets $NET_ZERO
read_mmmc ${LAYOUT_DIR}/scripts/${design}.view
read_physical -lef $LEF_LIST

# --> Point to the exact baseline netlist we generated in Genus
read_netlist ${BACKEND_DIR}/synthesis/deliverables/${design}_${lib}_${freq}_base/${design}.v
init_design

#-----------------------------------------------------------------------------
# General settings
#-----------------------------------------------------------------------------
get_db design_top_routing_layer
set_db design_top_routing_layer 11

#-----------------------------------------------------------------------------
# Net connections
#-----------------------------------------------------------------------------
delete_global_net_connections
connect_global_net $NET_ONE -type pg_pin -pin_base_name $NET_ONE -inst_base_name *
connect_global_net $NET_ZERO -type pg_pin -pin_base_name $NET_ZERO -inst_base_name *
connect_global_net $NET_ONE -type tie_hi
connect_global_net $NET_ZERO -type tie_lo
connect_global_net $NET_ONE -type tie_hi -pin $NET_ONE -inst *
connect_global_net $NET_ZERO -type tie_lo  -pin $NET_ZERO -inst *

#-----------------------------------------------------------------------------
# Technology setup & Floorplanning
#-----------------------------------------------------------------------------
get_db design_process_node
set_db design_process_node 45
get_db designs .name
create_floorplan -core_margins_by die -core_density_size 1 0.7 2.5 2.5 2.5 2.5
check_floorplan

#-----------------------------------------------------------------------------
# Pin Placement & Power Planning (Rings/Stripes)
#-----------------------------------------------------------------------------
edit_pin -fixed_pin 1 -unit micron -spread_direction clockwise -side Left -layer 1 -spread_type center -spacing 1.0 -pin $LEFT_CORE_PINS
edit_pin -fixed_pin 1 -unit micron -spread_direction clockwise -edge 1 -layer 1 -spread_type center -spacing 1.0 -pin $TOP_CORE_PINS
edit_pin -fixed_pin 1 -unit micron -spread_direction clockwise -edge 2 -layer 1 -spread_type center -spacing 1.0 -pin $RIGHT_CORE_PINS
edit_pin -fixed_pin 1 -unit micron -spread_direction clockwise -edge 3 -layer 1 -spread_type center -spacing 1.0 -pin $BOTTOM_CORE_PINS

set_db add_rings_skip_shared_inner_ring none
set_db add_rings_avoid_short 1
set_db add_rings_ignore_rows 0
set_db add_rings_extend_over_row 0
add_rings -type core_rings -jog_distance 0.6 -threshold 0.6 -nets "$NET_ONE $NET_ZERO" -follow core -layer {bottom Metal11 top Metal11 right Metal10 left Metal10} -width 0.7 -spacing 0.4 -offset 0.6

add_stripes -nets "$NET_ONE $NET_ZERO" -layer Metal6 -direction vertical -width 0.28 -spacing 0.8 -set_to_set_distance 6 -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit Metal11 -pad_core_ring_bottom_layer_limit Metal1 -block_ring_top_layer_limit Metal11 -block_ring_bottom_layer_limit Metal1 -use_wire_group 0 -snap_wire_center_to_grid none -start_offset 1

route_special -connect core_pin -layer_change_range { Metal1(1) Metal11(11) } -block_pin_target nearest_target -core_pin_target first_after_row_end -allow_jogging 1 -crossover_via_layer_range { Metal1(1) Metal11(11) } -nets "$NET_ONE $NET_ZERO" -allow_layer_change 1 -target_via_layer_range { Metal1(1) Metal11(11) } -stripe_layer_range {1 11}

#-----------------------------------------------------------------------------
# Placement & Pre-CTS
#-----------------------------------------------------------------------------
place_opt_design
set_db extract_rc_engine pre_route
extract_rc
set_db opt_drv_fix_max_cap true ; set_db opt_drv_fix_max_tran true ; set_db opt_fix_fanout_load false
opt_design -pre_cts
set_db timing_analysis_type best_case_worst_case
time_design -pre_cts

#-----------------------------------------------------------------------------
# CTS & Post-CTS
#-----------------------------------------------------------------------------
set_interactive_constraint_modes {normal_genus_slow_max}
reset_ideal_network $MAIN_CLOCK_NAME
set_db cts_buffer_cells $BUFFERS_CTS
set_db cts_inverter_cells $INVERTERS_CTS
create_clock_tree_spec
clock_opt_design

set_db extract_rc_engine pre_route
extract_rc

# Assuming this script is in the same directory
source ${LAYOUT_DIR}/scripts/user_statCCOpt_cui.tcl
user_statCCOpt

set_db timing_analysis_type best_case_worst_case
set_db timing_analysis_clock_propagation_mode sdc_control
time_design -post_cts
time_design -post_cts -hold
opt_design -post_cts
opt_design -post_cts -hold

#-----------------------------------------------------------------------------
# Routing & Post-Route Timing
#-----------------------------------------------------------------------------
route_design
set_db timing_analysis_type ocv
time_design -post_route
set_interactive_constraint_modes {normal_genus_slow_max}
set_propagated_clock [all_clocks] 

set_db timing_analysis_check_type setup
report_timing > ${OUT_RPT}/${design}_setup_timing.rpt
set_db timing_analysis_check_type hold
report_timing > ${OUT_RPT}/${design}_hold_timing.rpt

#-----------------------------------------------------------------------------
# Fillers & DB Save
#-----------------------------------------------------------------------------
add_fillers -base_cells {FILL8 FILL64 FILL4 FILL32 FILL2 FILL16 FILL1}
add_metal_fill -layers {Metal1 Metal2 Metal3 Metal4 Metal5 Metal6 Metal7 Metal8 Metal9 Metal10 Metal11}
write_db ${OUT_DELIV}/final.enc

#-----------------------------------------------------------------------------
# Write Verilog & SDF
#-----------------------------------------------------------------------------
write_netlist ${OUT_DELIV}/${design}_layout.v
write_sdf -edge check_edge -map_setuphold merge_always -map_recrem split -map_removal -version 3.0 ${OUT_DELIV}/${design}_layout.sdf
report_gates -out_file ${OUT_RPT}/${design}_gates_layout.rpt

#-----------------------------------------------------------------------------
# Power Analysis (Using the dynamic VCD file)
#-----------------------------------------------------------------------------
set vcd_path "${PROJECT_DIR}/frontend/VCDs/${design}_lab8_${lib}_${freq}_${runtime}.vcd"

if { [file exists $vcd_path] } {
    puts "VCD found! Running power analysis..."
    read_activity_file -format VCD -scope ${design}_tb(verification)/DUV $vcd_path -reset 
    report_power -power_unit uW -view analysis_normal_fast_min > ${OUT_RPT}/${design}_power_${runtime}ns.rpt
} else {
    puts "WARNING: VCD not found at $vcd_path. Skipping layout power analysis."
}

exit
