onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_function_pkg/MONITOR_TEST
add wave -noupdate /ntm_function_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM SCALAR EXPONENTIATOR TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/CLK
add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/RST
add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/START
add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/DATA_IN
add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/READY
add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/DATA_OUT

add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/controller_ctrl_fsm_int

add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/data_int_scalar_multiplier

add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/index_adder_loop
add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/index_first_multiplier_loop
add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/index_second_multiplier_loop

add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/start_scalar_adder
add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/operation_scalar_adder
add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/data_a_in_scalar_adder
add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/data_b_in_scalar_adder
add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/ready_scalar_adder
add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/data_out_scalar_adder

add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/start_scalar_multiplier
add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/data_a_in_scalar_multiplier
add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/data_b_in_scalar_multiplier
add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/ready_scalar_multiplier
add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/data_out_scalar_multiplier

add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/start_scalar_divider
add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/data_a_in_scalar_divider
add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/data_b_in_scalar_divider
add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/ready_scalar_divider
add wave -noupdate /ntm_function_testbench/ntm_scalar_exponentiator_test/scalar_exponentiator/data_out_scalar_divider

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