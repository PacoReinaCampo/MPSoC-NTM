onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_arithmetic_pkg/MONITOR_TEST
add wave -noupdate /ntm_arithmetic_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM VECTOR LCM TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/CLK
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/RST
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/START
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/MODULO_IN
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/SIZE_IN
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/DATA_A_IN_ENABLE
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/DATA_A_IN
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/DATA_B_IN_ENABLE
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/DATA_B_IN
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/READY
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/DATA_OUT_ENABLE
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/DATA_OUT

add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/lcm_ctrl_fsm_int
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/index_loop
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/data_a_in_lcm_int
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/data_b_in_lcm_int

add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/start_scalar_lcm
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/modulo_in_scalar_lcm
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/data_a_in_scalar_lcm
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/data_b_in_scalar_lcm
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/ready_scalar_lcm
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_lcm_test/vector_lcm/data_out_scalar_lcm

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