onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /model_algebra_pkg/MONITOR_TEST
add wave -noupdate /model_algebra_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM MATRIX TRANSPOSE TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /model_algebra_testbench/model_matrix_transpose_test/matrix_transpose/CLK
add wave -noupdate /model_algebra_testbench/model_matrix_transpose_test/matrix_transpose/RST
add wave -noupdate /model_algebra_testbench/model_matrix_transpose_test/matrix_transpose/START
add wave -noupdate /model_algebra_testbench/model_matrix_transpose_test/matrix_transpose/SIZE_I_IN
add wave -noupdate /model_algebra_testbench/model_matrix_transpose_test/matrix_transpose/SIZE_J_IN
add wave -noupdate /model_algebra_testbench/model_matrix_transpose_test/matrix_transpose/DATA_IN_I_ENABLE
add wave -noupdate /model_algebra_testbench/model_matrix_transpose_test/matrix_transpose/DATA_IN_J_ENABLE
add wave -noupdate /model_algebra_testbench/model_matrix_transpose_test/matrix_transpose/DATA_IN
add wave -noupdate /model_algebra_testbench/model_matrix_transpose_test/matrix_transpose/DATA_I_ENABLE
add wave -noupdate /model_algebra_testbench/model_matrix_transpose_test/matrix_transpose/DATA_J_ENABLE
add wave -noupdate /model_algebra_testbench/model_matrix_transpose_test/matrix_transpose/READY
add wave -noupdate /model_algebra_testbench/model_matrix_transpose_test/matrix_transpose/DATA_OUT_I_ENABLE
add wave -noupdate /model_algebra_testbench/model_matrix_transpose_test/matrix_transpose/DATA_OUT_J_ENABLE
add wave -noupdate /model_algebra_testbench/model_matrix_transpose_test/matrix_transpose/DATA_OUT

add wave -noupdate /model_algebra_testbench/model_matrix_transpose_test/matrix_transpose/transpose_ctrl_fsm_int

add wave -noupdate /model_algebra_testbench/model_matrix_transpose_test/matrix_transpose/index_i_loop
add wave -noupdate /model_algebra_testbench/model_matrix_transpose_test/matrix_transpose/index_j_loop

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
