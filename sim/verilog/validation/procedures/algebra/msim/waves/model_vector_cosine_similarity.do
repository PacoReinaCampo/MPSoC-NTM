onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM VECTOR COSINE_SIMILARITY TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /model_algebra_testbench/model_vector_cosine_similarity_test/vector_cosine_similarity/CLK
add wave -noupdate /model_algebra_testbench/model_vector_cosine_similarity_test/vector_cosine_similarity/RST
add wave -noupdate /model_algebra_testbench/model_vector_cosine_similarity_test/vector_cosine_similarity/START
add wave -noupdate /model_algebra_testbench/model_vector_cosine_similarity_test/vector_cosine_similarity/LENGTH_IN
add wave -noupdate /model_algebra_testbench/model_vector_cosine_similarity_test/vector_cosine_similarity/DATA_A_IN_ENABLE
add wave -noupdate /model_algebra_testbench/model_vector_cosine_similarity_test/vector_cosine_similarity/DATA_A_IN
add wave -noupdate /model_algebra_testbench/model_vector_cosine_similarity_test/vector_cosine_similarity/DATA_B_IN_ENABLE
add wave -noupdate /model_algebra_testbench/model_vector_cosine_similarity_test/vector_cosine_similarity/DATA_B_IN
add wave -noupdate /model_algebra_testbench/model_vector_cosine_similarity_test/vector_cosine_similarity/READY
add wave -noupdate /model_algebra_testbench/model_vector_cosine_similarity_test/vector_cosine_similarity/DATA_OUT_ENABLE
add wave -noupdate /model_algebra_testbench/model_vector_cosine_similarity_test/vector_cosine_similarity/DATA_OUT

add wave -noupdate /model_algebra_testbench/model_vector_cosine_similarity_test/vector_cosine_similarity/cosine_similarity_ctrl_fsm_int

add wave -noupdate /model_algebra_testbench/model_vector_cosine_similarity_test/vector_cosine_similarity/index_loop

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
