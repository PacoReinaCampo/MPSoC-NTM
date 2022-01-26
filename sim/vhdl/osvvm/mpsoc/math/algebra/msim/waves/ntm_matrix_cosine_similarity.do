onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_algebra_pkg/MONITOR_TEST
add wave -noupdate /ntm_algebra_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM MATRIX COSINE_SIMILARITY TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/CLK
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/RST
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/START
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/SIZE_A_I_IN
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/SIZE_A_J_IN
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/SIZE_B_I_IN
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/SIZE_B_J_IN
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/DATA_A_IN_I_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/DATA_A_IN_J_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/DATA_A_IN
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/DATA_B_IN_I_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/DATA_B_IN_J_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/DATA_B_IN
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/DATA_I_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/DATA_J_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/READY
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/DATA_OUT_I_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/DATA_OUT_J_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/DATA_OUT

add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/cosine_similarity_ctrl_fsm_int

add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/index_i_loop
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/index_j_loop
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/index_k_loop

add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/data_a_in_i_cosine_similarity_int
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/data_a_in_j_cosine_similarity_int
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/data_b_in_i_cosine_similarity_int
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/data_b_in_j_cosine_similarity_int

add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/start_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/operation_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/data_a_in_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/data_b_in_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/ready_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/data_out_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/overflow_out_scalar_adder

add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/start_scalar_multiplier
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/data_a_in_scalar_multiplier
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/data_b_in_scalar_multiplier
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/ready_scalar_multiplier
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/data_out_scalar_multiplier
add wave -noupdate /ntm_algebra_testbench/ntm_matrix_cosine_similarity_test/matrix_cosine_similarity/overflow_out_scalar_multiplier

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
