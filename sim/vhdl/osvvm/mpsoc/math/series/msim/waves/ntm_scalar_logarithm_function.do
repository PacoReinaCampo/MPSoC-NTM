onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_series_pkg/MONITOR_TEST
add wave -noupdate /ntm_series_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM SCALAR LOGARITHM TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/CLK
add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/RST
add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/START
add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/DATA_IN
add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/READY
add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/DATA_OUT

add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/controller_ctrl_fsm_int

add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/index_adder_loop
add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/index_multiplier_loop

add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/start_scalar_integer_adder
add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/operation_scalar_integer_adder
add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/data_a_in_scalar_integer_adder
add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/data_b_in_scalar_integer_adder
add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/ready_scalar_integer_adder
add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/data_out_scalar_integer_adder

add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/start_scalar_integer_multiplier
add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/data_a_in_scalar_integer_multiplier
add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/data_b_in_scalar_integer_multiplier
add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/ready_scalar_integer_multiplier
add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/data_out_scalar_integer_multiplier

add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/start_scalar_integer_divider
add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/data_a_in_scalar_integer_divider
add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/data_b_in_scalar_integer_divider
add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/ready_scalar_integer_divider
add wave -noupdate /ntm_series_testbench/ntm_scalar_logarithm_function_test/scalar_logarithm_function/data_out_scalar_integer_divider

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