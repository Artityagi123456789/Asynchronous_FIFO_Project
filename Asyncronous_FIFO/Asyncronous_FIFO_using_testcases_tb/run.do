vlog tb.v
vsim tb +testname=test_empty_error
add wave tb/dut/*
run -all
