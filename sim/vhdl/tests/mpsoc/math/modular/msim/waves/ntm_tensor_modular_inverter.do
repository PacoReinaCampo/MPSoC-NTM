onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_modular_pkg/MONITOR_TEST
add wave -noupdate /ntm_modular_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM TENSOR INVERTER TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/CLK
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/RST
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/START
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/MODULO_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/SIZE_I_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/SIZE_J_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/SIZE_K_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/DATA_IN_I_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/DATA_IN_J_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/DATA_IN_K_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/DATA_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/READY
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/DATA_OUT_I_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/index_i_loop
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/DATA_OUT_J_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/index_j_loop
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/DATA_OUT_K_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/index_k_loop
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/DATA_OUT

add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/inverter_ctrl_fsm_int

add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/start_matrix_modular_inverter
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/modulo_in_matrix_modular_inverter
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/size_i_in_matrix_modular_inverter
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/size_j_in_matrix_modular_inverter
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/data_in_i_enable_matrix_modular_inverter
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/data_in_j_enable_matrix_modular_inverter
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/data_in_matrix_modular_inverter
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/ready_matrix_modular_inverter
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/data_out_i_enable_matrix_modular_inverter
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/data_out_j_enable_matrix_modular_inverter
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_inverter_test/tensor_modular_inverter/data_out_matrix_modular_inverter

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