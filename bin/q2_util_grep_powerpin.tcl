#!/usr/bin/env tclsh

#
# Make different files with content power pins from Altera Quartus pin file
#
# Parameters:
#   <file_name> - input file name
# Example usage:
# 1. <script_name>
# 2. <script_name> <input_file_name>

proc check_file_exist { fname } {
    if { ![file exist $fname] } {
        puts "Error: Can't open specified file: $fname"
        puts "Exit with error!"
        exit 1
    }
}

set input_file_en 0
if {[llength $argv]>0} {
    set file_name [lindex $argv 0]
    check_file_exist $file_name
    set input_file_en 1
}

set pwr { 5.0V 3.3V 3.0V 2.5V 1.8V 1.5V 1.35V 1.25V 1.2V 1.1V 1.0V 0.9V 0.8V 0.75V 0.675V GND }
if { !$input_file_en } {
    set file_name {MergedQC.rpt}
    check_file_exist $file_name
}
set file_name_out   {pins_signal.log}
set file_name_tmp   {pins_signal_tmp.log}
set file_tmp        {pins_tmp.log}

file copy -force $file_name $file_name_out

# puts "Clean dir from files: 'pins_power_*.log'"
# exec rm -rf pins_power_*.log

puts "+-------------------------------------------------------------------------+"
puts "| Make files (sorted by power pin content) from Altera Quartus pin file   |"
puts "+-------------------------------------------------------------------------+"
puts "input file name : '$file_name'"
puts ""
foreach i $pwr {
    if { ![catch {exec grep -s $i $file_name > $file_tmp} msg] } {
        puts -nonewline " Find power pins: '$i' \t"
        exec grep -s $i $file_name > pins_power_$i.log
        exec grep -v $i $file_name_out > $file_name_tmp
        file copy -force $file_name_tmp $file_name_out
        file delete $file_name_tmp
        puts "Write file: 'pins_power_$i.log'"
    }
}
file delete $file_tmp
puts ""
puts "Write file: '$file_name_out' - list of pins without power pins."
puts ""
puts "Done!"
