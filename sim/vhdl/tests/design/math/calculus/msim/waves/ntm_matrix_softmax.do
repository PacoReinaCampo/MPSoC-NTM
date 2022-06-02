onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /model_calculus_pkg/MONITOR_TEST
add wave -noupdate /model_calculus_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM MATRIX SOFTMAX TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /model_calculus_testbench/model_matrix_softmax_test/matrix_softmax/CLK
add wave -noupdate /model_calculus_testbench/model_matrix_softmax_test/matrix_softmax/RST
add wave -noupdate /model_calculus_testbench/model_matrix_softmax_test/matrix_softmax/START
add wave -noupdate /model_calculus_testbench/model_matrix_softmax_test/matrix_softmax/SIZE_I_IN
add wave -noupdate /model_calculus_testbench/model_matrix_softmax_test/matrix_softmax/SIZE_J_IN
add wave -noupdate /model_calculus_testbench/model_matrix_softmax_test/matrix_softmax/DATA_IN_I_ENABLE
add wave -noupdate /model_calculus_testbench/model_matrix_softmax_test/matrix_softmax/DATA_IN_J_ENABLE
add wave -noupdate /model_calculus_testbench/model_matrix_softmax_test/matrix_softmax/DATA_IN
add wave -noupdate /model_calculus_testbench/model_matrix_softmax_test/matrix_softmax/DATA_I_ENABLE
add wave -noupdate /model_calculus_testbench/model_matrix_softmax_test/matrix_softmax/DATA_J_ENABLE
add wave -noupdate /model_calculus_testbench/model_matrix_softmax_test/matrix_softmax/READY
add wave -noupdate /model_calculus_testbench/model_matrix_softmax_test/matrix_softmax/DATA_OUT_I_ENABLE
add wave -noupdate /model_calculus_testbench/model_matrix_softmax_test/matrix_softmax/DATA_OUT_J_ENABLE
add wave -noupdate /model_calculus_testbench/model_matrix_softmax_test/matrix_softmax/DATA_OUT

add wave -noupdate /model_calculus_testbench/model_matrix_softmax_test/matrix_softmax/softmax_ctrl_fsm_int

add wave -noupdate /model_calculus_testbench/model_matrix_softmax_test/matrix_softmax/index_i_loop
add wave -noupdate /model_calculus_testbench/model_matrix_softmax_test/matrix_softmax/index_j_loop

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
