onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM VECTOR FLOAT ADDER TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/CLK
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/RST
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/START
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/OPERATION
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/SIZE_IN
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/DATA_A_IN_ENABLE
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/DATA_A_IN
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/DATA_B_IN_ENABLE
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/DATA_B_IN
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/READY
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/DATA_OUT_ENABLE
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/index_loop
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/DATA_OUT
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/OVERFLOW_OUT

add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/adder_ctrl_fsm_int

add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/start_scalar_float_adder
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/operation_scalar_float_adder
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/data_a_in_adder_int
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/data_a_in_scalar_float_adder
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/data_b_in_adder_int
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/data_b_in_scalar_float_adder
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/ready_scalar_float_adder
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/data_out_scalar_float_adder
add wave -noupdate /accelerator_float_testbench/accelerator_vector_float_adder_test/vector_float_adder/overflow_out_scalar_float_adder

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