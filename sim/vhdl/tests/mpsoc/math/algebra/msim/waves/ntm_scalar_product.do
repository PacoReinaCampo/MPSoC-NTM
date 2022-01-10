onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_algebra_pkg/MONITOR_TEST
add wave -noupdate /ntm_algebra_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM SCALAR PRODUCT TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/CLK
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/RST
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/START
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/LENGTH_IN
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/DATA_A_IN_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/DATA_A_IN
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/DATA_B_IN_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/DATA_B_IN
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/READY
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/DATA_OUT_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/DATA_OUT

add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/multiplier_ctrl_fsm_int

add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/index_loop

add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/start_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/operation_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/data_a_in_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/data_b_in_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/ready_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/data_out_scalar_adder

add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/start_scalar_multiplier
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/data_a_in_multiplier_int
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/data_a_in_scalar_multiplier
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/data_b_in_multiplier_int
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/data_b_in_scalar_multiplier
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/ready_scalar_multiplier
add wave -noupdate /ntm_algebra_testbench/ntm_scalar_product_test/scalar_product/data_out_scalar_multiplier

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