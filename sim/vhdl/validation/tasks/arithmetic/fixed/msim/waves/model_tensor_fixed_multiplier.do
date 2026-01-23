onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {ACCELERATOR TENSOR FIXED MULTIPLIER TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/CLK
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/RST
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/START
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/SIZE_I_IN
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/SIZE_J_IN
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/SIZE_K_IN
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/DATA_A_IN_I_ENABLE
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/DATA_A_IN_J_ENABLE
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/DATA_A_IN_K_ENABLE
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/DATA_A_IN
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/DATA_B_IN_I_ENABLE
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/DATA_B_IN_J_ENABLE
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/DATA_B_IN_K_ENABLE
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/DATA_B_IN
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/READY
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/DATA_OUT_I_ENABLE
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/index_i_loop
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/DATA_OUT_J_ENABLE
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/index_j_loop
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/DATA_OUT_K_ENABLE
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/index_k_loop
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/DATA_OUT
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/OVERFLOW_OUT

add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/multiplier_ctrl_fsm_int

add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/start_scalar_fixed_multiplier
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/data_a_in_i_fixed_multiplier_int
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/data_a_in_j_fixed_multiplier_int
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/data_a_in_k_fixed_multiplier_int
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/data_a_in_scalar_fixed_multiplier
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/data_b_in_i_fixed_multiplier_int
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/data_b_in_j_fixed_multiplier_int
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/data_b_in_k_fixed_multiplier_int
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/data_b_in_scalar_fixed_multiplier
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/ready_scalar_fixed_multiplier
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/data_out_scalar_fixed_multiplier
add wave -noupdate /model_fixed_testbench/model_tensor_fixed_multiplier_test/tensor_fixed_multiplier/overflow_out_scalar_fixed_multiplier

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