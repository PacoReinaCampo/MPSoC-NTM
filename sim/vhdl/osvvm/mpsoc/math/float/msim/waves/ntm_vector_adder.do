onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_float_pkg/MONITOR_TEST
add wave -noupdate /ntm_float_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM VECTOR ADDER TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/CLK
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/RST
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/START
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/OPERATION
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/SIZE_IN
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/DATA_A_IN_ENABLE
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/DATA_A_IN
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/DATA_B_IN_ENABLE
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/DATA_B_IN
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/READY
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/DATA_OUT_ENABLE
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/index_loop
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/DATA_OUT
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/OVERFLOW_OUT

add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/adder_ctrl_fsm_int

add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/start_scalar_adder
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/operation_scalar_adder
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/data_a_in_adder_int
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/data_a_in_scalar_adder
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/data_b_in_adder_int
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/data_b_in_scalar_adder
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/ready_scalar_adder
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/data_out_scalar_adder
add wave -noupdate /ntm_float_testbench/ntm_vector_adder_test/vector_adder/overflow_out_scalar_adder

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