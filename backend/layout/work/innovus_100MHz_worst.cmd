#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Mon May  4 12:40:32 2026                
#                                                     
#######################################################

#@(#)CDS: Innovus v25.13-s088_1 (64bit) 03/26/2026 12:37 (Linux 4.18.0-305.el8.x86_64)
#@(#)CDS: NanoRoute 25.13-s088_1 NR260309-1855/25_13-UB (database version 18.20.683) {superthreading v2.20}
#@(#)CDS: AAE 25.13-s023 (64bit) 03/26/2026 (Linux 4.18.0-305.el8.x86_64)
#@(#)CDS: CTE 25.13-s044_1 () Mar 24 2026 17:45:14 ( )
#@(#)CDS: SYNTECH 25.13-s012_1 () Mar 10 2026 03:01:02 ( )
#@(#)CDS: CPE v25.13-s019
#@(#)CDS: IQuantus/TQuantus 24.1.0-s476 (64bit) Wed Feb 11 22:11:27 PST 2026 (Linux 4.18.0-305.el8.x86_64)

#@ source /home/ufsm00291/ufsm00291-lima202020189/projetos/somador/backend/synthesis/scripts/layout.tcl
#@ Begin verbose source (pre): source /home/ufsm00291/ufsm00291-lima202020189/projetos/somador/backend/synthesis/scripts/layout.tcl
set design      $env(DESIGNS)
set freq        $env(FREQ_MHZ)
set lib         $env(LIB_TYPE)
set runtime     $env(RUNTIME)
set PROJECT_DIR $env(PROJECT_DIR)
set BACKEND_DIR $env(BACKEND_DIR)
set LAYOUT_DIR  $env(LAYOUT_DIR)
set LEF_DIR     $env(LEF_DIR)
set TECH_DIR    $env(TECH_DIR)
set OUT_DELIV   "${LAYOUT_DIR}/deliverables/${design}_${lib}_${freq}_${runtime}"
set OUT_RPT     "${LAYOUT_DIR}/reports/${design}_${lib}_${freq}_${runtime}"
set period_clk  [expr {1000.0 / $freq}]
#@ source ${BACKEND_DIR}/synthesis/scripts/common/path.tcl
#@ Begin verbose source /home/ufsm00291/ufsm00291-lima202020189/projetos/somador/backend/synthesis/scripts/common/path.tcl (pre)
set PROJECT_DIR $env(PROJECT_DIR)
set TECH_DIR $env(TECH_DIR)
set BACKEND_DIR ${PROJECT_DIR}/backend
set SYNT_DIR ${BACKEND_DIR}/synthesis
set SCRIPT_DIR ${SYNT_DIR}/scripts
set RPT_DIR ${SYNT_DIR}/reports
set DEV_DIR ${SYNT_DIR}/deliverables
set LAYOUT_DIR ${BACKEND_DIR}/layout
set FRONTEND_DIR ${PROJECT_DIR}/frontend
set OTHERS ""
lappend FRONTEND_DIR $OTHERS
set LIB_DIR ${TECH_DIR}/gsclib045_svt_v4.4/gsclib045/timing
lappend LEF_DIR ${TECH_DIR}/giolib045_v3.3/lef
#@ End verbose source /home/ufsm00291/ufsm00291-lima202020189/projetos/somador/backend/synthesis/scripts/common/path.tcl
#@ source ${BACKEND_DIR}/synthesis/scripts/common/variables.tcl
#@ Begin verbose source /home/ufsm00291/ufsm00291-lima202020189/projetos/somador/backend/synthesis/scripts/common/variables.tcl (pre)
set PROJECT_DIR $env(PROJECT_DIR)
set TECH_DIR $env(TECH_DIR)
set LEF_DIR $env(LEF_DIR)
set DESIGNS $env(DESIGNS)
set DESIGNS $env(DESIGNS)
set HDL_NAME $env(HDL_NAME)
set RTL_FILES $env(RTL_FILES)
set INTERCONNECT_MODE ple
set MAIN_CLOCK_NAME $env(MAIN_CLOCK_NAME)
set MAIN_RST_NAME $env(MAIN_RST_NAME)
set BEST_LIB_OPERATING_CONDITION $env(BEST_LIB_OPERATING_CONDITION)
set WORST_LIB_OPERATING_CONDITION $env(WORST_LIB_OPERATING_CONDITION)
set period_clk $env(period_clk)
set clk_uncertainty $env(clk_uncertainty)
set clk_latency $env(clk_latency)
set in_delay $env(in_delay)
set out_delay $env(out_delay)
set out_load $env(out_load)
set slew $env(slew)
set slew_min_rise $env(slew_min_rise)
set slew_min_fall $env(slew_min_fall)
set slew_max_rise $env(slew_max_rise)
set slew_max_fall $env(slew_max_fall)
set WORST_LIST $env(WORST_LIST)
set BEST_LIST $env(BEST_LIST)
set LEF_LIST $env(LEF_LIST)
set WORST_CAP_LIST $env(WORST_CAP_LIST)
set QRC_LIST $env(QRC_LIST)
set CAP_MAX $env(CAP_MAX)
set CAP_MIN $env(CAP_MIN)
set NET_ZERO $env(NET_ZERO)
set NET_ONE $env(NET_ONE)
set BUFFERS_CTS $env(BUFFERS_CTS)
set INVERTERS_CTS $env(INVERTERS_CTS)
set LEFT_CORE_PINS $env(LEFT_CORE_PINS)
set TOP_CORE_PINS $env(TOP_CORE_PINS)
set RIGHT_CORE_PINS $env(RIGHT_CORE_PINS)
set BOTTOM_CORE_PINS $env(BOTTOM_CORE_PINS)
#@ End verbose source /home/ufsm00291/ufsm00291-lima202020189/projetos/somador/backend/synthesis/scripts/common/variables.tcl
set_message -id TECHLIB-302 -suppress
set_message -id IMPDB-6501 -suppress 
set_message -id IMPFP-3961 -suppress 
set_message -id IMPOPT-3195 -suppress
set_message -id IMPSP-9025 -suppress 
set_message -id IMPLF-200 -suppress 
set_message -id IMPEXT-3493 -suppress 
set_message -id IMPEXT-6166 -suppress 
set_message -id IMPSP-5217 -suppress 
set_db init_power_nets $NET_ONE
set_db init_ground_nets $NET_ZERO
read_mmmc ${LAYOUT_DIR}/scripts/${design}.view
#@ Begin verbose source /home/ufsm00291/ufsm00291-lima202020189/projetos/somador/backend/layout/scripts/somador.view (pre)
create_library_set -name fast -timing $BEST_LIST
create_library_set -name slow -timing $WORST_LIST
create_rc_corner -name rc_best -cap_table $CAP_MIN -temperature 0
create_rc_corner -name rc_worst -cap_table $CAP_MAX -temperature 125
create_opcond -name oc_slow -process {1.0} -voltage {0.90} -temperature {125} 
create_opcond -name oc_fast -process {1.0} -voltage {1.32} -temperature {0} 
create_timing_condition -name slow_timing -library_sets [list slow] -opcond oc_slow
create_timing_condition -name fast_timing -library_sets [list fast] -opcond oc_fast
create_delay_corner -name slow_max -timing_condition slow_timing -rc_corner rc_worst
create_delay_corner -name fast_min -timing_condition fast_timing -rc_corner rc_best
create_constraint_mode -name normal_genus_slow_max -sdc_files ${PROJECT_DIR}/backend/synthesis/constraints/$DESIGNS.sdc
create_analysis_view -name analysis_normal_slow_max -constraint_mode {normal_genus_slow_max} -delay_corner slow_max
create_analysis_view -name analysis_normal_fast_min -constraint_mode {normal_genus_slow_max} -delay_corner fast_min
set_analysis_view -setup [list analysis_normal_slow_max] -hold [list analysis_normal_fast_min]
#@ End verbose source /home/ufsm00291/ufsm00291-lima202020189/projetos/somador/backend/layout/scripts/somador.view
read_physical -lef $LEF_LIST
read_netlist ${BACKEND_DIR}/synthesis/deliverables/${design}_${lib}_${freq}_base/${design}.v
init_design
get_db design_top_routing_layer
set_db design_top_routing_layer 11
delete_global_net_connections
connect_global_net $NET_ONE -type pg_pin -pin_base_name $NET_ONE -inst_base_name *
connect_global_net $NET_ZERO -type pg_pin -pin_base_name $NET_ZERO -inst_base_name *
connect_global_net $NET_ONE -type tie_hi
connect_global_net $NET_ZERO -type tie_lo
connect_global_net $NET_ONE -type tie_hi -pin $NET_ONE -inst *
connect_global_net $NET_ZERO -type tie_lo  -pin $NET_ZERO -inst *
get_db design_process_node
set_db design_process_node 45
get_db designs .name
create_floorplan -core_margins_by die -core_density_size 1 0.7 2.5 2.5 2.5 2.5
check_floorplan
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
place_opt_design
set_db extract_rc_engine pre_route
extract_rc
set_db opt_drv_fix_max_cap true ;
set_db opt_drv_fix_max_tran true ;
set_db opt_fix_fanout_load false
opt_design -pre_cts
set_db timing_analysis_type best_case_worst_case
time_design -pre_cts
set_interactive_constraint_modes {normal_genus_slow_max}
reset_ideal_network $MAIN_CLOCK_NAME
set_db cts_buffer_cells $BUFFERS_CTS
set_db cts_inverter_cells $INVERTERS_CTS
create_clock_tree_spec
clock_opt_design
set_db extract_rc_engine pre_route
extract_rc
#@ source ${LAYOUT_DIR}/scripts/user_statCCOpt_cui.tcl
#@ Begin verbose source /home/ufsm00291/ufsm00291-lima202020189/projetos/somador/backend/layout/scripts/user_statCCOpt_cui.tcl (pre)
proc user_statCCOpt {args} {
    set procname [dict get [info frame [info frame]] proc]
    set ARGS(-output) "log"
    parse_proc_arguments -args $args ARGS
    switch $ARGS(-output) {
        "log" {interp alias {} write_cmd {} puts}
        "logv" {interp alias {} write_cmd {} vputs}
        "stdout" {interp alias {} write_cmd {} puts}
        default {error}
    }
    ## listup ccopt cell naming
    redirect -variable show_ccopt_cell_name_info_result {puts [report_cts_cell_name_info]}
    set cell_prefix_list ""
    foreach line [split $show_ccopt_cell_name_info_result "\n"] {
        if {[regexp {Creators:} $line]} {continue}
        if {[lindex $line 0] != ""} {lappend cell_prefix_list "[get_db cts_inst_name_prefix]_[lindex $line 0]"}
    }
    if {[info exists ARGS(-clock_trees)]} {
        set effective_clock_trees ""
        foreach i $ARGS(-clock_trees) {
            if {[get_ccopt_clock_trees $ARGS(-clock_trees)] == ""} {
                puts "WARN($procname): specified clock_tree $ARGS(-clock_tree) not found, ignore"
            } else {
                lappend effective_clock_trees $i
            }
        }
        if {$effective_clock_trees == ""} {
            puts "ERROR($procname): no effective clock_trees found, exit"
            return
        }
       set all_clock_tree_insts [get_db clock_tree:$effective_clock_trees .insts.name ]
       set all_clock_tree_sinks [ get_db clock_tree:$effective_clock_trees .sinks.name ]
    } else {
        set effective_clock_trees "all"
	set all_clock_tree_insts [get_db clock_trees .insts.name]
        set all_clock_tree_sinks [get_db clock_trees .sinks.name]
            }
    set total_num_insts [llength $all_clock_tree_insts]
    set counter 0
    foreach i $all_clock_tree_insts {
        set cell [get_db [get_db inst:$i] .base_cell.name]
        set prefix "OTHER"
        foreach j $cell_prefix_list {
            if {[string match *$j* $i]} {
                set prefix $j
                break
            }
        }
        incr STAT_CCOPT($cell,$prefix)
        incr counter
        puts -nonewline "\r processing  $counter / $total_num_insts"
 flush stdout
    }
    puts ""
    set prop_cell_list ""
    set cell_buf_list ""
       foreach i [get_db cts_buffer_cells] {
         foreach j [get_db base_cells .name $i] {
             lappend cell_buf_list $j
             lappend prop_cell_list $j
        }
     }
    set cell_inv_list ""
         foreach i [get_db cts_inverter_cells] {
         foreach j [get_db base_cells .name $i] {
             lappend cell_inv_list $j
             lappend prop_cell_list $j
         }        
     }
    set cell_oth_list ""
        foreach i [get_db cts_clock_gating_cells] {
         foreach j [get_db base_cells .name $i] {
             lappend cell_oth_list $j
             lappend prop_cell_list $j
         }
     }
    set prop_cell_ulist [lsort -unique $prop_cell_list]
    set prefix_list ""
    set value_list ""
    foreach i [array names STAT_CCOPT] {
        if {[regexp {(\S+)\,(\S+)} $i matchVar cell prefix]} { 
             if {[get_db [get_db base_cell:$cell  ] .is_buffer]} {
                 lappend cell_buf_list $cell
             } elseif {[get_db [get_db base_cell:$cell ] .is_inverter]} {
                 lappend cell_inv_list $cell
             } else {
                 lappend cell_oth_list $cell
             }
            lappend prefix_list $prefix
            lappend value_list $STAT_CCOPT($i)
        } else {
            error "unexpected array prefix_listnames $i"
        }
    }
    set cell_buf_ulist [lsort -unique $cell_buf_list]
    set cell_inv_ulist [lsort -unique $cell_inv_list]
    set cell_oth_ulist [lsort -unique $cell_oth_list]
    set prefix_ulist   [lsort -unique $prefix_list]
    write_cmd "### \[\[ clock_tree(s) tree stats : $effective_clock_trees (# of sinks = [llength $all_clock_tree_sinks]) \]\] ###"
    set max_cell_string_length 0
    foreach i [concat $cell_buf_ulist $cell_inv_ulist $cell_oth_ulist "TOTAL"] {
        if {[string length $i] > $max_cell_string_length} {
            set max_cell_string_length [string length $i]
        }
    }
    set max_result_string_length 0
    foreach i [concat $prefix_ulist $value_list "TOTAL"] {
        if {[string length $i] > $max_result_string_length} {
            set max_result_string_length [string length $i]
        }
    }
    set lenc [expr $max_cell_string_length + 2]
    set lenr [expr $max_result_string_length + 1]
    ## prepare real final_col_key / row_key
    if {[info exists ARGS(-keep_empty)]} {
        set row_keys [concat $cell_buf_ulist $cell_inv_ulist $cell_oth_ulist]
    } else {
        set row_keys ""
        foreach i [concat $cell_buf_ulist $cell_inv_ulist $cell_oth_ulist] {
            foreach j [array names STAT_CCOPT $i,*] {
                if {$STAT_CCOPT($j) > 0} {
                    lappend row_keys $i
                    break
                }
            }
        }
    }
    set col_keys $prefix_ulist
    ## write
    # fisrt row
    write_cmd -nonewline "|[format "%${lenc}s" ""]"
    set avoid_dup ""
    foreach i $col_keys {
        if {[lsearch $avoid_dup $i] > -1} {continue}
        write_cmd -nonewline "|[format "%${lenr}s"  $i]"
        lappend avoid_dup $i
    }
    write_cmd "|[format "%${lenr}s" "TOTAL"]|"
    # second row
    write_cmd -nonewline "+[string repeat "-" ${lenc}]"
    set avoid_dup ""
    foreach i $col_keys {
        if {[lsearch $avoid_dup $i] > -1} {continue}
        write_cmd -nonewline "+[string repeat "-" ${lenr}]"
        lappend avoid_dup $i
    }
    write_cmd "+[string repeat "-" ${lenr}]+"
    # middle row
    set avoid_dup ""
    foreach i $row_keys {
        if {[lsearch $avoid_dup $i] > -1} {continue}
        if {[lsearch $prop_cell_ulist $i] > -1} {
            write_cmd -nonewline "|[format "%${lenc}s" "@:$i"]"
        } else {
            write_cmd -nonewline "|[format "%${lenc}s" $i]"
        }
        set row_total 0
        foreach j $col_keys {
            if {[info exists STAT_CCOPT($i,$j)]} {
                write_cmd -nonewline "|[format "%${lenr}s" $STAT_CCOPT($i,$j)]"
                incr row_total $STAT_CCOPT($i,$j)
            } else {
                write_cmd -nonewline "|[format "%${lenr}s" "0"]"
            }
        }
        write_cmd "|[format "%${lenr}s" $row_total]|"
        lappend avoid_dup $i
    }
    # before last row
    write_cmd -nonewline "+[string repeat "-" ${lenc}]"
    set avoid_dup ""
    foreach i $col_keys {
        if {[lsearch $avoid_dup $i] > -1} {continue}
        write_cmd -nonewline "+[string repeat "-" ${lenr}]"
        lappend avoid_dup $i
    }
    write_cmd "+[string repeat "-" ${lenr}]+"
    # last row
    write_cmd -nonewline "|[format "%${lenc}s" "TOTAL"]"
    set avoid_dup ""
    set total_total 0
    foreach i $col_keys {
        if {[lsearch $avoid_dup $i] > -1} {continue}
        set col_total 0
        foreach j [array names STAT_CCOPT *,$i] {
            incr col_total $STAT_CCOPT($j)
        }
        write_cmd -nonewline "|[format "%${lenr}s" $col_total]"
        lappend avoid_dup $i
        incr total_total $col_total
    }
    write_cmd "|[format "%${lenr}s" $total_total]|"
}
define_proc_arguments user_statCCOpt  \
-info "report overview of CCOpt cell name code usage"  \
-define_args { {-clock_trees "specify clock_trees to report cell name code usage
 if not specified, all clock_tree are checked" "" string optional}
        {-keep_empty "display empty col/row
 default=empty col/row is not printed" "" boolean optional}
        {-output "output command
 default=log" "" one_of_string {optional value_help {values "log logv stdout"}}}
    }
#@ End verbose source /home/ufsm00291/ufsm00291-lima202020189/projetos/somador/backend/layout/scripts/user_statCCOpt_cui.tcl
user_statCCOpt
set_db timing_analysis_type best_case_worst_case
set_db timing_analysis_clock_propagation_mode sdc_control
time_design -post_cts
time_design -post_cts -hold
opt_design -post_cts
opt_design -post_cts -hold
route_design
set_db timing_analysis_type ocv
time_design -post_route
set_interactive_constraint_modes {normal_genus_slow_max}
set_propagated_clock [all_clocks] 
set_db timing_analysis_check_type setup
report_timing > ${OUT_RPT}/${design}_setup_timing.rpt
set_db timing_analysis_check_type hold
report_timing > ${OUT_RPT}/${design}_hold_timing.rpt
add_fillers -base_cells {FILL8 FILL64 FILL4 FILL32 FILL2 FILL16 FILL1}
add_metal_fill -layers {Metal1 Metal2 Metal3 Metal4 Metal5 Metal6 Metal7 Metal8 Metal9 Metal10 Metal11}
write_db ${OUT_DELIV}/final.enc
write_netlist ${OUT_DELIV}/${design}_layout.v
write_sdf -edge check_edge -map_setuphold merge_always -map_recrem split -map_removal -version 3.0 ${OUT_DELIV}/${design}_layout.sdf
report_gates -out_file ${OUT_RPT}/${design}_gates_layout.rpt
set vcd_path "${PROJECT_DIR}/frontend/VCDs/${design}_lab8_${lib}_${freq}_${runtime}.vcd"
if { [file exists $vcd_path] } {...
} else {
puts "WARNING: VCD not found at $vcd_path. Skipping layout power analysis."
}
exit
