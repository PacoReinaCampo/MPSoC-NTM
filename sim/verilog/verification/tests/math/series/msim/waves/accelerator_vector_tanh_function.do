onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM VECTOR TANH TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /accelerator_series_testbench/accelerator_vector_tanh_function_test/vector_tanh_function/CLK
add wave -noupdate /accelerator_series_testbench/accelerator_vector_tanh_function_test/vector_tanh_function/RST
add wave -noupdate /accelerator_series_testbench/accelerator_vector_tanh_function_test/vector_tanh_function/START
add wave -noupdate /accelerator_series_testbench/accelerator_vector_tanh_function_test/vector_tanh_function/SIZE_IN
add wave -noupdate /accelerator_series_testbench/accelerator_vector_tanh_function_test/vector_tanh_function/DATA_IN_ENABLE
add wave -noupdate /accelerator_series_testbench/accelerator_vector_tanh_function_test/vector_tanh_function/DATA_IN
add wave -noupdate /accelerator_series_testbench/accelerator_vector_tanh_function_test/vector_tanh_function/READY
add wave -noupdate /accelerator_series_testbench/accelerator_vector_tanh_function_test/vector_tanh_function/DATA_OUT_ENABLE
add wave -noupdate /accelerator_series_testbench/accelerator_vector_tanh_function_test/vector_tanh_function/index_loop
add wave -noupdate /accelerator_series_testbench/accelerator_vector_tanh_function_test/vector_tanh_function/DATA_OUT

add wave -noupdate /accelerator_series_testbench/accelerator_vector_tanh_function_test/vector_tanh_function/tanh_ctrl_fsm_int

add wave -noupdate /accelerator_series_testbench/accelerator_vector_tanh_function_test/vector_tanh_function/start_scalar_tanh_function
add wave -noupdate /accelerator_series_testbench/accelerator_vector_tanh_function_test/vector_tanh_function/data_in_scalar_tanh_function
add wave -noupdate /accelerator_series_testbench/accelerator_vector_tanh_function_test/vector_tanh_function/ready_scalar_tanh_function
add wave -noupdate /accelerator_series_testbench/accelerator_vector_tanh_function_test/vector_tanh_function/data_out_scalar_tanh_function

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