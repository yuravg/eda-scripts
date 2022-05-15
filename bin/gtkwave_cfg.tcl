# gtkwave_cfg.tcl --
#
#   Tcl command script file for execution GTKWave
#
# Load the trace with `gtkwave -S gtkwave_cfg.tcl yourtrace.vcd`
#
# User's Guide: http://gtkwave.sourceforge.net/gtkwave.pdf

# Contents:
#
#  Customize view settings
#  Add all signals to Wave
#  Zoom full
#  Print to PDF
#  Notes on toggle menu items


# * Customize view settings
# Show full signal hierarchy
gtkwave::/Edit/Set_Trace_Max_Hier 1
gtkwave::/View/Show_Filled_High_Values 1
gtkwave::/View/Show_Wave_Highlight 1
gtkwave::/View/Show_Mouseover 1


# * Add all signals to Wave
# Facility name
set numFacility [gtkwave::getNumFacs]
set numCnt 0
set curretInstName ""
for {set i 0} {$i < $numFacility} {incr i} {
    # Get full path to Facility - instance name,
    # and insert it before its facilities
    set fullName [gtkwave::getFacName $i]
    set splitName [split $fullName "."]
    set facIndex [expr [llength $splitName] - 1]
    set facName [lindex $splitName $facIndex]
    set instanceName [string trimright $fullName ".$facName"]
    # Insert instance name
    if {[string compare $curretInstName $instanceName] != 0} {
        set curretInstName $instanceName
        gtkwave::/Edit/Insert_Comment $instanceName
    }
    # Insert Facility name
    gtkwave::addSignalsFromList $fullName
    incr numCnt
}
puts "Num signals added: $numCnt"


# * Zoom full
# gtkwave::/View/Scale_To_Time_Dimension/ns
gtkwave::/Time/Zoom/Zoom_Full


# * Print to PDF
# set dumpname [gtkwave::getDumpFileName]
# gtkwave::/File/Print_To_File PDF {Letter (A4)} Minimal $dumpname.pdf


# * Notes on toggle menu items
# without an argument these toggle, otherwise with an argument it sets the value to 1 or 0
# gtkwave::/Edit/Color_Format/Keep_xz_Colors
# gtkwave::/Search/Autocoalesce
# gtkwave::/Search/Autocoalesce_Reversal
# gtkwave::/Search/Autoname_Bundles
# gtkwave::/Search/Search_Hierarchy_Grouping
# gtkwave::/Markers/Alternate_Wheel_Mode
# gtkwave::/Markers/Wave_Scrolling
# gtkwave::/View/Fullscreen
# gtkwave::/View/Show_Toolbar
# gtkwave::/View/Show_Grid
# gtkwave::/View/Show_Wave_Highlight
# gtkwave::/View/Show_Filled_High_Values
# gtkwave::/View/Leading_Zero_Removal
# gtkwave::/View/Show_Mouseover
# gtkwave::/View/Mouseover_Copies_To_Clipboard
# gtkwave::/View/Show_Base_Symbols
# gtkwave::/View/Standard_Trace_Select
# gtkwave::/View/Dynamic_Resize
# gtkwave::/View/Center_Zooms
# gtkwave::/View/Constant_Marker_Update
# gtkwave::/View/Draw_Roundcapped_Vectors
# gtkwave::/View/Zoom_Pow10_Snap
# gtkwave::/View/Partial_VCD_Dynamic_Zoom_Full
# gtkwave::/View/Partial_VCD_Dynamic_Zoom_To_End
# gtkwave::/View/Full_Precision
# gtkwave::/View/LXT_Clock_Compress_to_Z

# these can only set to the one selected
# gtkwave::/View/Scale_To_Time_Dimension/None
# gtkwave::/View/Scale_To_Time_Dimension/sec
# gtkwave::/View/Scale_To_Time_Dimension/ms
# gtkwave::/View/Scale_To_Time_Dimension/us
# gtkwave::/View/Scale_To_Time_Dimension/ns
# gtkwave::/View/Scale_To_Time_Dimension/ps
# gtkwave::/View/Scale_To_Time_Dimension/fs
