onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /accelerator_function_pkg/MONITOR_TEST
add wave -noupdate /accelerator_function_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM SCALAR LOGISTIC TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/CLK
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/RST
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/START
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/DATA_IN
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/READY
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/DATA_OUT

add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/controller_ctrl_fsm_int

add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/start_scalar_float_adder
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/operation_scalar_float_adder
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/data_a_in_scalar_float_adder
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/data_b_in_scalar_float_adder
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/ready_scalar_float_adder
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/data_out_scalar_float_adder

add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/start_scalar_float_divider
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/data_a_in_scalar_float_divider
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/data_b_in_scalar_float_divider
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/ready_scalar_float_divider
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/data_out_scalar_float_divider

add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/start_scalar_exponentiator_function
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/data_in_scalar_exponentiator_function
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/ready_scalar_exponentiator_function
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_logistic_function_test/scalar_logistic_function/data_out_scalar_exponentiator_function


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