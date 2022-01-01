onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_integer_pkg/MONITOR_TEST
add wave -noupdate /ntm_integer_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM MATRIX FULL DIVIDER TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/CLK
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/RST
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/START
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/SIZE_I_IN
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/SIZE_J_IN
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/DATA_A_IN_I_ENABLE
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/DATA_A_IN_J_ENABLE
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/DATA_A_IN
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/DATA_B_IN_I_ENABLE
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/DATA_B_IN_J_ENABLE
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/DATA_B_IN
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/READY
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/DATA_OUT_I_ENABLE
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/index_i_loop
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/DATA_OUT_J_ENABLE
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/index_j_loop
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/DATA_INTEGER_OUT
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/DATA_FRACTIONAL_OUT

add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/divider_ctrl_fsm_int

add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/start_vector_full_divider
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/size_in_vector_full_divider
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/data_a_in_i_full_divider_int
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/data_a_in_j_full_divider_int
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/data_a_in_enable_vector_full_divider
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/data_a_in_vector_full_divider
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/data_b_in_i_full_divider_int
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/data_b_in_j_full_divider_int
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/data_b_in_enable_vector_full_divider
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/data_b_in_vector_full_divider
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/ready_vector_full_divider
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/data_out_enable_vector_full_divider
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/data_integer_out_vector_full_divider
add wave -noupdate /ntm_integer_testbench/ntm_matrix_integer_full_divider_test/matrix_integer_full_divider/data_fractional_out_vector_full_divider

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