onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_arithmetic_pkg/MONITOR_TEST
add wave -noupdate /ntm_arithmetic_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM VECTOR GCD TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/CLK
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/RST
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/START
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/MODULO_IN
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/SIZE_IN
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/DATA_A_IN_ENABLE
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/DATA_A_IN
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/DATA_B_IN_ENABLE
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/DATA_B_IN
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/READY
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/DATA_OUT_ENABLE
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/DATA_OUT

add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/gcd_ctrl_fsm_int
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/index_loop
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/data_a_in_gcd_int
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/data_b_in_gcd_int

add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/start_scalar_gcd
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/modulo_in_scalar_gcd
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/data_a_in_scalar_gcd
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/data_b_in_scalar_gcd
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/ready_scalar_gcd
add wave -noupdate /ntm_arithmetic_testbench/ntm_vector_gcd_test/vector_gcd/data_out_scalar_gcd

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