onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM VECTOR DIFFERENTIATION TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/CLK
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/RST
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/START
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/SIZE_IN
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/LENGTH_IN
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/DATA_IN_ENABLE
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/DATA_IN
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/DATA_ENABLE
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/READY
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/DATA_OUT_ENABLE
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/DATA_OUT

add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/differentiation_ctrl_fsm_int

add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/index_loop

add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/start_scalar_float_adder
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/operation_scalar_float_adder
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/data_a_in_scalar_float_adder
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/data_b_in_scalar_float_adder
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/ready_scalar_float_adder
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/data_out_scalar_float_adder
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/overflow_out_scalar_float_adder

add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/start_scalar_float_divider
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/data_a_in_scalar_float_divider
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/data_b_in_scalar_float_divider
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/ready_scalar_float_divider
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/data_out_scalar_float_divider
add wave -noupdate /accelerator_calculus_testbench/accelerator_vector_differentiation_test/vector_differentiation/overflow_out_scalar_float_divider

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
