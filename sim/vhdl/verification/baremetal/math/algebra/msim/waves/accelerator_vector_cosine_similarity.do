onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /accelerator_algebra_pkg/MONITOR_TEST
add wave -noupdate /accelerator_algebra_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM DOT COSINE_SIMILARITY TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/CLK
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/RST
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/START
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/LENGTH_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/DATA_A_IN_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/DATA_A_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/DATA_B_IN_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/DATA_B_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/READY
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/DATA_OUT_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/DATA_OUT

add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/cosine_similarity_ctrl_fsm_int

add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/index_loop

add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/start_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/operation_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/data_a_in_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/data_b_in_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/ready_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/data_out_scalar_float_adder

add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/start_scalar_float_multiplier
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/data_a_in_cosine_similarity_int
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/data_a_in_scalar_float_multiplier
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/data_b_in_cosine_similarity_int
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/data_b_in_scalar_float_multiplier
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/ready_scalar_float_multiplier
add wave -noupdate /accelerator_algebra_testbench/accelerator_vector_cosine_similarity_test/vector_cosine_similarity/data_out_scalar_float_multiplier

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