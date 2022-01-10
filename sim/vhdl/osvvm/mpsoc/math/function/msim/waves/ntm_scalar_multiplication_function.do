onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_function_pkg/MONITOR_TEST
add wave -noupdate /ntm_function_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM SCALAR MULTIPLICATION TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_function_testbench/ntm_scalar_multiplication_function_test/scalar_multiplication_function/CLK
add wave -noupdate /ntm_function_testbench/ntm_scalar_multiplication_function_test/scalar_multiplication_function/RST

add wave -noupdate /ntm_function_testbench/ntm_scalar_multiplication_function_test/scalar_multiplication_function/START
add wave -noupdate /ntm_function_testbench/ntm_scalar_multiplication_function_test/scalar_multiplication_function/LENGTH_IN
add wave -noupdate /ntm_function_testbench/ntm_scalar_multiplication_function_test/scalar_multiplication_function/DATA_IN_ENABLE
add wave -noupdate /ntm_function_testbench/ntm_scalar_multiplication_function_test/scalar_multiplication_function/DATA_IN
add wave -noupdate /ntm_function_testbench/ntm_scalar_multiplication_function_test/scalar_multiplication_function/READY
add wave -noupdate /ntm_function_testbench/ntm_scalar_multiplication_function_test/scalar_multiplication_function/DATA_OUT_ENABLE
add wave -noupdate /ntm_function_testbench/ntm_scalar_multiplication_function_test/scalar_multiplication_function/DATA_OUT

add wave -noupdate /ntm_function_testbench/ntm_scalar_multiplication_function_test/scalar_multiplication_function/multiplication_ctrl_fsm_int

add wave -noupdate /ntm_function_testbench/ntm_scalar_multiplication_function_test/scalar_multiplication_function/index_loop

add wave -noupdate /ntm_function_testbench/ntm_scalar_multiplication_function_test/scalar_multiplication_function/start_scalar_multiplier
add wave -noupdate /ntm_function_testbench/ntm_scalar_multiplication_function_test/scalar_multiplication_function/data_a_in_scalar_multiplier
add wave -noupdate /ntm_function_testbench/ntm_scalar_multiplication_function_test/scalar_multiplication_function/data_b_in_scalar_multiplier
add wave -noupdate /ntm_function_testbench/ntm_scalar_multiplication_function_test/scalar_multiplication_function/ready_scalar_multiplier
add wave -noupdate /ntm_function_testbench/ntm_scalar_multiplication_function_test/scalar_multiplication_function/data_out_scalar_multiplier

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