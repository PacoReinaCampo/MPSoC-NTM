onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_modular_pkg/MONITOR_TEST
add wave -noupdate /ntm_modular_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM TENSOR ADDER TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/CLK
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/RST
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/START
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/OPERATION
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/MODULO_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/SIZE_I_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/SIZE_J_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/SIZE_K_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/DATA_A_IN_I_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/DATA_A_IN_J_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/DATA_A_IN_K_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/DATA_A_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/DATA_B_IN_I_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/DATA_B_IN_J_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/DATA_B_IN_K_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/DATA_B_IN
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/READY
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/DATA_OUT_I_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/index_i_loop
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/DATA_OUT_J_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/index_j_loop
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/DATA_OUT_K_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/index_k_loop
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/DATA_OUT

add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/adder_ctrl_fsm_int

add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/start_scalar_modular_adder
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/operation_scalar_modular_adder
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/modulo_in_scalar_modular_adder
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/data_a_in_scalar_modular_adder
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/data_b_in_scalar_modular_adder
add wave -noupdate /ntm_modular_testbench/ntm_tensor_modular_adder_test/tensor_modular_adder/data_out_scalar_modular_adder

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