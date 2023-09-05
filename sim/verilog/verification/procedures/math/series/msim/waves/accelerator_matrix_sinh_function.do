onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /accelerator_series_pkg/MONITOR_TEST
add wave -noupdate /accelerator_series_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM MATRIX SINH TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /accelerator_series_testbench/accelerator_matrix_sinh_function_test/matrix_sinh_function/CLK
add wave -noupdate /accelerator_series_testbench/accelerator_matrix_sinh_function_test/matrix_sinh_function/RST
add wave -noupdate /accelerator_series_testbench/accelerator_matrix_sinh_function_test/matrix_sinh_function/START
add wave -noupdate /accelerator_series_testbench/accelerator_matrix_sinh_function_test/matrix_sinh_function/SIZE_I_IN
add wave -noupdate /accelerator_series_testbench/accelerator_matrix_sinh_function_test/matrix_sinh_function/SIZE_J_IN
add wave -noupdate /accelerator_series_testbench/accelerator_matrix_sinh_function_test/matrix_sinh_function/DATA_IN_I_ENABLE
add wave -noupdate /accelerator_series_testbench/accelerator_matrix_sinh_function_test/matrix_sinh_function/DATA_IN_J_ENABLE
add wave -noupdate /accelerator_series_testbench/accelerator_matrix_sinh_function_test/matrix_sinh_function/DATA_IN
add wave -noupdate /accelerator_series_testbench/accelerator_matrix_sinh_function_test/matrix_sinh_function/READY
add wave -noupdate /accelerator_series_testbench/accelerator_matrix_sinh_function_test/matrix_sinh_function/DATA_OUT_I_ENABLE
add wave -noupdate /accelerator_series_testbench/accelerator_matrix_sinh_function_test/matrix_sinh_function/DATA_OUT_J_ENABLE
add wave -noupdate /accelerator_series_testbench/accelerator_matrix_sinh_function_test/matrix_sinh_function/DATA_OUT

add wave -noupdate /accelerator_series_testbench/accelerator_matrix_sinh_function_test/matrix_sinh_function/sinh_ctrl_fsm_int

add wave -noupdate /accelerator_series_testbench/accelerator_matrix_sinh_function_test/matrix_sinh_function/index_i_loop
add wave -noupdate /accelerator_series_testbench/accelerator_matrix_sinh_function_test/matrix_sinh_function/index_j_loop

add wave -noupdate /accelerator_series_testbench/accelerator_matrix_sinh_function_test/matrix_sinh_function/start_scalar_sinh_function
add wave -noupdate /accelerator_series_testbench/accelerator_matrix_sinh_function_test/matrix_sinh_function/data_in_scalar_sinh_function
add wave -noupdate /accelerator_series_testbench/accelerator_matrix_sinh_function_test/matrix_sinh_function/ready_scalar_sinh_function
add wave -noupdate /accelerator_series_testbench/accelerator_matrix_sinh_function_test/matrix_sinh_function/data_out_scalar_sinh_function

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
