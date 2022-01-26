onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_algebra_pkg/MONITOR_TEST
add wave -noupdate /ntm_algebra_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM DOT CONVOLUTION TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/CLK
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/RST
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/START
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/LENGTH_IN
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/DATA_A_IN_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/DATA_A_IN
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/DATA_B_IN_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/DATA_B_IN
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/READY
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/DATA_OUT_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/DATA_OUT

add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/convolution_ctrl_fsm_int

add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/index_i_loop
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/index_m_loop

add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/start_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/operation_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/data_a_in_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/data_b_in_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/ready_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/data_out_scalar_adder

add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/start_scalar_multiplier
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/data_a_in_convolution_int
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/data_a_in_scalar_multiplier
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/data_b_in_convolution_int
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/data_b_in_scalar_multiplier
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/ready_scalar_multiplier
add wave -noupdate /ntm_algebra_testbench/ntm_vector_convolution_test/vector_convolution/data_out_scalar_multiplier

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