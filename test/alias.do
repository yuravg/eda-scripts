alias run_example1 {
    make compile
    make opt
    vsim example1_tb_opt
    view wave
    do wave_example1_tb.do
    onfinish stop
    run 1us
    wave zoom full
}

alias h {
    echo "   h                   - List of all user's aliases"
    echo "   run_example1 - Run simulation"
}

echo "Added user aliases:"
h
