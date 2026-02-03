# .modelsim.tcl
# Setting for ModelSim/QuestaSim
set f2load "./alias.do"
if {[file exists $f2load]} {
    do $f2load
    echo "Loaded: $f2load"
}
