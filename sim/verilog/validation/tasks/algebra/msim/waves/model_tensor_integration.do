onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {ACCELERATOR TENSOR INTEGRATION TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/CLK
add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/RST
add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/START
add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/SIZE_I_IN
add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/SIZE_J_IN
add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/SIZE_K_IN
add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/LENGTH_IN
add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/DATA_IN_I_ENABLE
add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/DATA_IN_J_ENABLE
add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/DATA_IN_K_ENABLE
add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/DATA_IN
add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/DATA_I_ENABLE
add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/DATA_J_ENABLE
add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/DATA_K_ENABLE
add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/READY
add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/DATA_OUT_I_ENABLE
add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/DATA_OUT_J_ENABLE
add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/DATA_OUT_K_ENABLE
add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/DATA_OUT

add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/integration_ctrl_fsm_int

add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/index_i_loop
add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/index_j_loop
add wave -noupdate /model_calculus_testbench/model_tensor_integration_test/tensor_integration/index_k_loop

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
