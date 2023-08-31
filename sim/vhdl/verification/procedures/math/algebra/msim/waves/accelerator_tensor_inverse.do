onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /accelerator_algebra_pkg/MONITOR_TEST
add wave -noupdate /accelerator_algebra_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM TENSOR INVERSE TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/CLK
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/RST
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/START
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/SIZE_I_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/SIZE_J_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/SIZE_K_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/DATA_IN_I_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/DATA_IN_J_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/DATA_IN_K_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/DATA_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/DATA_I_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/DATA_J_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/DATA_K_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/READY
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/DATA_OUT_I_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/DATA_OUT_J_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/DATA_OUT_K_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/DATA_OUT

add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/inverse_ctrl_fsm_int

add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/index_i_loop
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/index_j_loop
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_inverse_test/tensor_inverse/index_k_loop

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