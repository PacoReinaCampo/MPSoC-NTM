onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_modular_pkg/MONITOR_TEST
add wave -noupdate /ntm_modular_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM TENSOR DIVIDER TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/CLK
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/RST
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/START
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/MODULO_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/SIZE_I_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/SIZE_J_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/SIZE_K_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/DATA_A_IN_I_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/DATA_A_IN_J_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/DATA_A_IN_K_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/DATA_A_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/DATA_B_IN_I_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/DATA_B_IN_J_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/DATA_B_IN_K_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/DATA_B_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/READY
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/DATA_OUT_I_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/index_i_loop
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/DATA_OUT_J_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/index_j_loop
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/DATA_OUT_K_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/index_k_loop
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/DATA_OUT

add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/divider_ctrl_fsm_int

add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/start_matrix_modular_divider
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/modulo_in_matrix_modular_divider
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/size_i_in_matrix_modular_divider
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/size_j_in_matrix_modular_divider
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/data_a_in_i_modular_divider_int
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/data_a_in_j_modular_divider_int
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/data_a_in_k_modular_divider_int
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/data_a_in_i_enable_matrix_modular_divider
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/data_a_in_j_enable_matrix_modular_divider
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/data_a_in_matrix_modular_divider
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/data_b_in_i_modular_divider_int
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/data_b_in_j_modular_divider_int
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/data_b_in_k_modular_divider_int
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/data_b_in_i_enable_matrix_modular_divider
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/data_b_in_j_enable_matrix_modular_divider
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/data_b_in_matrix_modular_divider
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/ready_matrix_modular_divider
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/data_out_i_enable_matrix_modular_divider
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/data_out_j_enable_matrix_modular_divider
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_divider_test/tensor_modular_divider/data_out_matrix_modular_divider

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