#!/usr/bin/env tclsh

# Script to make Quartus Qip-file

puts "+------------------------------------------------------+"
puts "| Make Quartus Qip-file                                |"
puts "+------------------------------------------------------+"

if {[llength $argv]>0} {
    puts "Input parameters:"
    set  file_name [lindex $argv 0]
    set  path0     [lindex $argv 1]
    set  path1     [lindex $argv 2]
    set  path2     [lindex $argv 3]
    set  path3     [lindex $argv 4]
    puts " file name : '$file_name'"
    puts " path0      : '$path0'"
    puts " path1      : '$path1'"
    puts " path2      : '$path2'"
    puts " path3      : '$path3'"
} else {
	puts "Usage example(s): <script_name> <qip-file-name> <path2dir0>"
	puts "                  <script_name> <qip-file-name> ."
	puts "                  <script_name> <qip-file-name> <path2dir0> ... <path2dir3> "
	exit 0
}

set p_file [open $file_name w]
set cnt 0

proc find { path pattern key_word  } {
    foreach i [ glob -nocomplain $path/$pattern ] {
        puts $::p_file "set_global_assignment -name $key_word \[file join \$::quartus(qip_path) \"$i\"\]"
		puts "$i\t\t$key_word"
        global cnt
        incr cnt
    }
}

proc find_in_path { path } {
    find  $path *.sv   SYSTEMVERILOG_FILE
    find  $path *.svh  SYSTEMVERILOG_FILE
    find  $path *.v    VERILOG_FILE
    find  $path *.sdc  SDC_FILE
    find  $path *.vhd  VHDL_FILE
    find  $path *.vhdl VHDL_FILE
    find  $path *.tdf  AHDL_FILE
    find  $path *.hex  SOURCE_FILE
    find  $path *.ppf  SOURCE_FILE
    find  $path *.c    SOURCE_FILE
    find  $path *.h    SOURCE_FILE
    find  $path *.tcl  TCL_FILE
    find  $path *.iv   MISC_FILE
    find  $path *.qip  QIP_FILE
    find  $path *.qsys QSYS_FILE
    # TODO: how usage *.ip files?
    # find  $path *.ip   MISC_FILE
}

foreach p $path0 {
    find_in_path $p
    puts $::p_file ""
}

foreach p $path1 {
    find_in_path $p
    puts $::p_file ""
}

foreach p $path2 {
    find_in_path $p
    puts $::p_file ""
}

foreach p $path3 {
    find_in_path $p
    puts $::p_file ""
}

close $p_file
puts "----------------------------------"
puts " Find $cnt files"
puts " Write file '$file_name'"
# puts " Press 'Enter' to exit ..."
# gets stdin
