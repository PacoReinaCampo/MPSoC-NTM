onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM TENSOR FLOAT DIVIDER TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/CLK
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/RST
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/START
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/SIZE_I_IN
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/SIZE_J_IN
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/SIZE_K_IN
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/DATA_A_IN_I_ENABLE
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/DATA_A_IN_J_ENABLE
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/DATA_A_IN_K_ENABLE
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/DATA_A_IN
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/DATA_B_IN_I_ENABLE
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/DATA_B_IN_J_ENABLE
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/DATA_B_IN_K_ENABLE
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/DATA_B_IN
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/READY
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/DATA_OUT_I_ENABLE
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/index_i_loop
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/DATA_OUT_J_ENABLE
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/index_j_loop
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/DATA_OUT_K_ENABLE
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/index_k_loop
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/DATA_OUT
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/OVERFLOW_OUT

add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/divider_ctrl_fsm_int

add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/start_scalar_float_divider
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/data_a_in_i_float_divider_int
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/data_a_in_j_float_divider_int
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/data_a_in_k_float_divider_int
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/data_a_in_scalar_float_divider
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/data_b_in_i_float_divider_int
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/data_b_in_j_float_divider_int
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/data_b_in_k_float_divider_int
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/data_b_in_scalar_float_divider
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/ready_scalar_float_divider
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/data_out_scalar_float_divider
add wave -noupdate /model_float_testbench/model_tensor_float_divider_test/tensor_float_divider/overflow_out_scalar_float_divider

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