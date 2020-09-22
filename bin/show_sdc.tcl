# Show Quartus Timing Analyzer Summary

if { $argc != 2} {
    error "Error: Usage: quartus_sta -t <script.tcl> <project_name> <project_revision>"
}

set project [lindex $argv 0]
set revision [lindex $argv 1]

project_open $project -revision $revision

create_timing_netlist

read_sdc

# do report timing for different operating conditions
foreach_in_collection op [get_available_operating_conditions] {
    post_message "Operation conditions: $op"
    set_operating_conditions $op
    update_timing_netlist
    qsta_utility::generate_top_failures_per_clock "Top Failing Paths" 200
}

project_close
