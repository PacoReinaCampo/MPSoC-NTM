onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {ACCELERATOR TENSOR SOFTMAX TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/CLK
add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/RST
add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/START
add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/SIZE_I_IN
add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/SIZE_J_IN
add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/SIZE_K_IN
add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/DATA_IN_I_ENABLE
add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/DATA_IN_J_ENABLE
add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/DATA_IN_K_ENABLE
add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/DATA_IN
add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/DATA_I_ENABLE
add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/DATA_J_ENABLE
add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/DATA_K_ENABLE
add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/READY
add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/DATA_OUT_I_ENABLE
add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/DATA_OUT_J_ENABLE
add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/DATA_OUT_K_ENABLE
add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/DATA_OUT

add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/softmax_ctrl_fsm_int

add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/index_i_loop
add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/index_j_loop
add wave -noupdate /accelerator_calculus_testbench/accelerator_tensor_softmax_test/tensor_softmax/index_k_loop

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