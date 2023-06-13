onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /accelerator_algebra_pkg/MONITOR_TEST
add wave -noupdate /accelerator_algebra_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM DOT PRODUCT TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/CLK
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/RST
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/START
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/LENGTH_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/DATA_A_IN_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/DATA_A_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/DATA_B_IN_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/DATA_B_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/READY
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/DATA_OUT_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/DATA_OUT

add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/product_ctrl_fsm_int

add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/index_loop

add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/start_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/operation_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/data_a_in_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/data_b_in_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/ready_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/data_out_scalar_float_adder

add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/start_scalar_float_multiplier
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/data_a_in_product_int
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/data_a_in_scalar_float_multiplier
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/data_b_in_product_int
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/data_b_in_scalar_float_multiplier
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/ready_scalar_float_multiplier
add wave -noupdate /accelerator_algebra_testbench/accelerator_dot_product_test/dot_product/data_out_scalar_float_multiplier

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