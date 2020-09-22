#!/usr/bin/env tclsh

#
# Скрипт для создания makefile, для использования в сборке проекта содержащего Altera QSYS
#
# Скрипт ищет результат генерации qsys:
# *generation*.rpt - наибольший по номеру, в текущей директории,
# на основе которого создается makefile, с правилом "qsys_synthesis".
# Полученное правило используется при сборке проекта (build.bat: make qsys_synthesis)
# Примечание: в директории должны быть репорты только по одной системе
#
# Пример использования:
#    source q2_make_makefile_qsys.tcl (из Quartus tcl console)
#    tclsh q2_make_makefile_qsys.tcl  (из tclsh)
#

# NOTE: *.qsys - расширение для системы
set file_make "Makefile.qsystem"
set script_name q2_make_makefile_qsys.tcl

puts "+-----------------------------------------------------------------------+"
puts "| It's running script '$script_name':                      |"
puts "|  to build $file_make for work with Altera QSystem               |"
puts "|-----------------------------------------------------------------------|"
puts "| Makefile target:                                                      |"
puts "|  qsys_synthesis  - to synthesis                                       |"
puts "|  qsys_simulation - to simulation                                      |"
puts "+-----------------------------------------------------------------------+"


proc find_generation_rpt_file { } {
    set oldest_file 0
    foreach file_name [glob -nocomplain {*generation*.rpt} ] {
        lappend files_list $file_name
        set files_list_sorted [ lsort -ascii -dictionary -decreasing $files_list ]
        set oldest_file [lindex $files_list_sorted 0]
    }
    if {$oldest_file==0} {
        puts "Error! Can't find QSYS generation report file (*.rpt)!"
        exit 1
    }
    return $oldest_file
}

proc find_generation_rpt_file_list { num_files files_list_sorted } {
    upvar $files_list_sorted files_list_sorted_
    upvar $num_files num_files_
    set files_list_sorted_ ""
    set num_files_ 0
    foreach file_name [glob -nocomplain {*generation*.rpt} ] {
        lappend files_list $file_name
        incr num_files_
        set files_list_sorted_ [ lsort -ascii -dictionary -decreasing $files_list ]
    }
}

set file_rpt [find_generation_rpt_file]
find_generation_rpt_file_list num_files files_list_sorted
if {$num_files>1} {
    puts ""
    puts " List of qsys report files    : $files_list_sorted"
}
puts ""
puts " Using generation report file : '$file_rpt'"
regsub {_generation[_]{0,1}[\d]{0,4}\.rpt} $file_rpt "" qsysname
puts ""
puts " QSYS component name          : '$qsysname'"

set p_file_rpt      [open $file_rpt r]
set p_file_make     [open $file_make w]
chan configure $p_file_make -translation lf

set rpt_data [read $p_file_rpt]
set split_rpt_data [split $rpt_data "\n"]

proc find_report_version {version} {
    upvar $version version_
    set version_ "unknown"
    global split_rpt_data
    set done 0
    foreach i $split_rpt_data {
        if [ string match "*--quartus_dir=*" $i ] {
            set str [split $i " "]
            foreach j $str {
                if [ string match "*--quartus_dir=*" $j ] {
                    set srt [split $j "/"]
                    set srt_length [llength $srt]
                    set version_ [lindex $srt [expr $srt_length - 2]]
                    set done 1
                    break
                }
            }
        }
        if {$done} {
            break
        }
    }
}

find_report_version qsys_version
set generation_time [clock format [clock sec] -format "%d/%m/%y; %H:%M:%S"]
set msg \
"#+-----------------------------------------------------------------------------------------------
#| NOTE: this file was auto-generated from: '$script_name'
#|       generation date and time:  $generation_time
#+-----------------------------------------------------------------------------------------------
#| Qsys file was made in Quartus version: \"$qsys_version\"
#| (you can edit/delete several string in target with code \"--report-file=\" for compatibility)
#+-----------------------------------------------------------------------------------------------
MAKE            = make --no-print-directory
PATH_SOPC_BIN   = \"\$(QUARTUS_ROOTDIR)\/sopc_builder\/bin\"
ifeq (\$(OS),Windows_NT)
  WD=`pwd -W`
else
  WD=.
endif

.PHONY: help_qsys
help_qsys:
    @echo \"\"
    @echo \" Usage:  make \[target(s)\]\"
    @echo \" where target is any of:\"
    @echo \"\"
    @echo \"  qsys_synthesis  - Create HDL design files for synthesis\"
    @echo \"  qsys_simulation - Create HDL design files for simulation\"
    @echo \"  clean_qsys      - Remove qsys directory\"
    @echo \"\"
"


proc lremove {list args} {
    foreach toRemove $args {
        set index [lsearch -exact $list $toRemove]
        set list [lreplace $list $index $index]
    }
    return $list
}

proc find_and_add_path {data pattern} {
    set n_str [lsearch $data $pattern]
    if {$n_str < 0} {
        puts "Error! Can't find pattern!"
        exit 1
    }
    set str [lindex $data [expr $n_str + 1] ]
    set data [lremove $str "Info:"]
    set data "\$(PATH_SOPC_BIN)\/$data"
    return $data
}

proc del_char_from_string {str char} {
    upvar $str str_
    set first 0
    set first [string first $char $str_]
    set str_ [string replace $str_ $first $first {}]
    return $first
}

proc output_format {str} {
    upvar $str str_
    set names_index 0
    foreach i $str_ {
        if [lsearch $i "--*"] {
            if [lsearch $i "\$*"] {
                set names_index [lsearch $str_ "$i"]
                set names_index0 [expr $names_index - 1]
            }
        }
    }
    set k 0
    set index_end [expr [llength $str_] - 1]
    if { $names_index != 0 } {
        set s_device [lindex $str_ $names_index]
        foreach i $str_ {
            if { $k != $names_index } {
                if { $k == $names_index0 } {
                    append out "\t\"$i $s_device\" \\\n"
                } else {
                    if { $k != $index_end } {
                        append out "\t\"$i\" \\\n"
                    } else {
                        append out "\t\"$i\" \n"
                    }
                }
            }
            incr k
        }
    } else {
        foreach i $str_ {
            if { $k != $index_end } {
                append out "\t\"$i\" \\\n"
            } else {
                append out "\t\"$i\" \n"
            }
            incr k
        }
    }
    set str_ $out
}

append msg "\n
.PHONY: qsys_synthesis
qsys_synthesis:\n"

set str [find_and_add_path $split_rpt_data "*Create HDL design files for synthesis*"]
regsub -all -nocase {[\"\\]} $str "" filtered
output_format filtered
set path [pwd]
regsub -all -nocase "$path" $filtered "\$(WD)" filtered
append msg $filtered

# append msg "\n
# .PHONY: qsys_all
# "
# append msg "\n\n"
# append msg "qsys_all:\n"

# proc findcmd_and_add_path {data} {
#   foreach i $data {
#       if { [ regexp {(ip-generate --)} $i ]} {
#           regsub -all -nocase "Info: " $i "" i_
#           set i_ "\$(PATH_SOPC_BIN)\/$i_"
#           regsub -all -nocase {[\"\\]} $i_ "" filtered
#           output_format filtered
#           set path [pwd]
#           regsub -all -nocase "$path" $filtered "\$(WD)" filtered
#           append rpt "$filtered"
#       }
#       if { [ regexp {(ip-make-simscript --)} $i ] } {
#           regsub -all -nocase "Info: Doing: " $i "" i_
#           set i_ "\$(PATH_SOPC_BIN)\/$i_"
#           regsub -all -nocase {[\"\\]} $i_ "" filtered
#           output_format filtered
#           set path [pwd]
#           regsub -all -nocase "$path" $filtered "\$(WD)" filtered
#           append rpt "$filtered"
#       }
#       if { [ regexp {(sim-script-gen --)} $i ] } {
#           regsub -all -nocase "Info: " $i "" i_
#           set i_ "\$(PATH_SOPC_BIN)\/$i_"
#           regsub -all -nocase {[\"\\]} $i_ "" filtered
#           output_format filtered
#           set path [pwd]
#           regsub -all -nocase "$path" $filtered "\$(WD)" filtered
#           append rpt "$filtered"
#       }
#   }
#   if [info exists rpt] {
#       return $rpt
#   } else {
#       puts "Error! Can't find pattern 'ip-generate'"
#   }
# }
# set str [findcmd_and_add_path $split_rpt_data]
# append msg $str

append msg "\n
.PHONY: qsys_simulation
qsys_simulation:\n"

proc find_sim_cmd_and_add_path {data} {
    foreach i $data {
        if { [ regexp {(ip-generate --)} $i ]} {
            if {[ string match "*\/$::qsysname\/simulation\/*" $i ]} {
                regsub -all -nocase "Info: " $i "" i_
                set i_ "\$(PATH_SOPC_BIN)\/$i_"
                regsub -all -nocase {[\"\\]} $i_ "" filtered
                output_format filtered
                set path [pwd]
                regsub -all -nocase "$path" $filtered "\$(WD)" filtered
                append rpt "$filtered"
            }
        }
        if { [ regexp {(ip-make-simscript --)} $i ] } {
            if {[ string match "*\/$::qsysname\/simulation\/*" $i ]} {
                regsub -all -nocase "Info: Doing: " $i "" i_
                set i_ "\$(PATH_SOPC_BIN)\/$i_"
                regsub -all -nocase {[\"\\]} $i_ "" filtered
                output_format filtered
                set path [pwd]
                regsub -all -nocase "$path" $filtered "\$(WD)" filtered
                append rpt "$filtered"
            }
        }
        if { [ regexp {(sim-script-gen --)} $i ] } {
            if {[ string match "*\/$::qsysname\/simulation\/*" $i ]} {
                regsub -all -nocase "Info: " $i "" i_
                set i_ "\$(PATH_SOPC_BIN)\/$i_"
                regsub -all -nocase {[\"\\]} $i_ "" filtered
                output_format filtered
                set path [pwd]
                regsub -all -nocase "$path" $filtered "\$(WD)" filtered
                append rpt "$filtered"
            }
        }
    }
    if [info exists rpt] {
        return $rpt
    } else {
        puts "\n Error! Can't find pattern 'ip-generate'"
    }
}
set str [find_sim_cmd_and_add_path $split_rpt_data]
append msg $str




# append msg "\n\n"
# append msg "qsys2:\n"
# append msg "  \$(PATH_SOPC_BIN)/sopc_builder
#   --script=\$(PATH_SOPC_BIN)/tbgen.tcl
#   \$(WD)/controller.qsys
# "

append msg "\n
.PHONY: clean_qsys
clean_qsys:
    rm -rf $qsysname
"
puts $p_file_make $msg

close $p_file_rpt
close $p_file_make

puts ""
puts " File                         : '$file_make' was greated."
puts ""
puts "------------------------------------------------------------------------"
# puts " Press 'Enter' to exit ..."
# gets stdin
puts " Done!"
