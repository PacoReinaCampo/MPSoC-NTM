onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_float_pkg/MONITOR_TEST
add wave -noupdate /ntm_float_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM SCALAR DIVIDER TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/CLK
add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/RST
add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/START
add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/DATA_A_IN
add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/DATA_B_IN
add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/READY
add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/DATA_OUT
add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/REST_OUT

add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/divider_ctrl_fsm_int

add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/start_scalar_adder
add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/operation_scalar_adder
add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/data_a_in_scalar_adder
add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/data_b_in_scalar_adder
add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/ready_scalar_adder
add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/data_out_scalar_adder
add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/overflow_out_scalar_adder

add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/start_scalar_divider
add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/data_a_in_scalar_divider
add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/data_b_in_scalar_divider
add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/ready_scalar_divider
add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/data_out_scalar_divider
add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/rest_out_scalar_divider

add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/sign_int_scalar_divider
add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/exponent_int_scalar_divider
add wave -noupdate /ntm_float_testbench/ntm_scalar_divider_test/scalar_divider/mantissa_int_scalar_divider

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