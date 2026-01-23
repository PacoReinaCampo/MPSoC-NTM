onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {ACCELERATOR SCALAR ONEPLUS TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/CLK
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/RST
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/START
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/DATA_IN
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/READY
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/DATA_OUT

add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/controller_ctrl_fsm_int

add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/start_scalar_float_adder
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/operation_scalar_float_adder
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/data_a_in_scalar_float_adder
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/data_b_in_scalar_float_adder
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/ready_scalar_float_adder
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/data_out_scalar_float_adder

add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/start_scalar_exponentiator_function
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/data_in_scalar_exponentiator_function
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/ready_scalar_exponentiator_function
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/data_out_scalar_exponentiator_function

add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/start_scalar_logarithm_function
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/data_in_scalar_logarithm_function
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/ready_scalar_logarithm_function
add wave -noupdate /accelerator_function_testbench/accelerator_scalar_oneplus_function_test/scalar_oneplus_function/data_out_scalar_logarithm_function

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