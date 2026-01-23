onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {ACCELERATOR TENSOR TRANSPOSE TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/CLK
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/RST
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/START
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/SIZE_I_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/SIZE_J_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/SIZE_K_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/DATA_IN_I_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/DATA_IN_J_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/DATA_IN_K_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/DATA_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/DATA_I_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/DATA_J_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/DATA_K_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/READY
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/DATA_OUT_I_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/DATA_OUT_J_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/DATA_OUT_K_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/DATA_OUT

add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/transpose_ctrl_fsm_int

add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/index_i_loop
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/index_j_loop
add wave -noupdate /accelerator_algebra_testbench/accelerator_tensor_transpose_test/tensor_transpose/index_k_loop

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