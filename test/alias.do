alias run_example1 {
    make compile
    make opt
    vsim example1_tb_opt
    view wave
    do wave_example1_tb.do
    run 1us
}

alias h {
    puts "User alases:"
    help run_example1
}

puts "Add aliases:"
puts "   h         - List of all user's aliases"
puts "   run_example1 - Run simulation"
