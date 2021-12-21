onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_modular_pkg/MONITOR_TEST
add wave -noupdate /ntm_modular_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM MATRIX EXPONENTIATOR TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/CLK
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/RST
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/START
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/MODULO_IN
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/SIZE_I_IN
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/SIZE_J_IN
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/DATA_A_IN_I_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/DATA_A_IN_J_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/DATA_A_IN
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/DATA_B_IN_I_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/DATA_B_IN_J_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/DATA_B_IN
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/READY
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/DATA_OUT_I_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/index_i_loop
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/DATA_OUT_J_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/index_j_loop
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/DATA_OUT

add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/exponentiator_ctrl_fsm_int

add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/start_vector_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/modulo_in_vector_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/size_in_vector_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/data_a_in_i_exponentiator_int
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/data_a_in_j_exponentiator_int
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/data_a_in_enable_vector_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/data_a_in_vector_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/data_b_in_i_exponentiator_int
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/data_b_in_j_exponentiator_int
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/data_b_in_enable_vector_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/data_b_in_vector_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/ready_vector_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/data_out_enable_vector_exponentiator
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_exponentiator_test/matrix_modular_exponentiator/data_out_vector_exponentiator

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