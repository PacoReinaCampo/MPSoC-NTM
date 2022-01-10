onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_function_pkg/MONITOR_TEST
add wave -noupdate /ntm_function_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM SCALAR SUMMATION TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_function_testbench/ntm_scalar_summation_function_test/scalar_summation_function/CLK
add wave -noupdate /ntm_function_testbench/ntm_scalar_summation_function_test/scalar_summation_function/RST

add wave -noupdate /ntm_function_testbench/ntm_scalar_summation_function_test/scalar_summation_function/START
add wave -noupdate /ntm_function_testbench/ntm_scalar_summation_function_test/scalar_summation_function/LENGTH_IN
add wave -noupdate /ntm_function_testbench/ntm_scalar_summation_function_test/scalar_summation_function/DATA_IN_ENABLE
add wave -noupdate /ntm_function_testbench/ntm_scalar_summation_function_test/scalar_summation_function/DATA_IN
add wave -noupdate /ntm_function_testbench/ntm_scalar_summation_function_test/scalar_summation_function/READY
add wave -noupdate /ntm_function_testbench/ntm_scalar_summation_function_test/scalar_summation_function/DATA_OUT_ENABLE
add wave -noupdate /ntm_function_testbench/ntm_scalar_summation_function_test/scalar_summation_function/DATA_OUT

add wave -noupdate /ntm_function_testbench/ntm_scalar_summation_function_test/scalar_summation_function/summation_ctrl_fsm_int

add wave -noupdate /ntm_function_testbench/ntm_scalar_summation_function_test/scalar_summation_function/index_loop

add wave -noupdate /ntm_function_testbench/ntm_scalar_summation_function_test/scalar_summation_function/start_scalar_adder
add wave -noupdate /ntm_function_testbench/ntm_scalar_summation_function_test/scalar_summation_function/operation_scalar_adder
add wave -noupdate /ntm_function_testbench/ntm_scalar_summation_function_test/scalar_summation_function/data_a_in_scalar_adder
add wave -noupdate /ntm_function_testbench/ntm_scalar_summation_function_test/scalar_summation_function/data_b_in_scalar_adder
add wave -noupdate /ntm_function_testbench/ntm_scalar_summation_function_test/scalar_summation_function/ready_scalar_adder
add wave -noupdate /ntm_function_testbench/ntm_scalar_summation_function_test/scalar_summation_function/data_out_scalar_adder

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1042309203 ps} 0} {{Cursor 2} {7446987402 ps} 0}
configure wave -namecolwidth 305
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1134027470 ps} {1150214364 ps}