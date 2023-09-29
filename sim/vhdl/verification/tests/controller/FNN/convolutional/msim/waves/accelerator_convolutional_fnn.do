onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM CONVOLUTIONAL FNN TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/CLK
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/RST

add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/START

add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/SIZE_X_IN
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/SIZE_W_IN
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/SIZE_L_IN
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/SIZE_R_IN
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/SIZE_S_IN
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/SIZE_M_IN

add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/W_IN_L_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/W_IN_X_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/W_IN
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_w_in_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/W_OUT_L_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/W_OUT_X_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/D_IN_I_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/D_IN_L_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/D_IN_M_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/D_IN
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_d_in_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/D_OUT_I_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/D_OUT_L_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/D_OUT_M_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/K_IN_I_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/K_IN_L_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/K_IN_K_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/K_IN
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_k_in_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/K_OUT_I_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/K_OUT_L_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/K_OUT_K_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/U_IN_L_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/U_IN_P_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/U_IN
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_u_in_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/U_OUT_L_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/U_OUT_P_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/V_IN_L_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/V_IN_S_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/V_IN
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_v_in_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/V_OUT_L_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/V_OUT_S_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/B_IN_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/B_IN
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/B_OUT_ENABLE

add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/X_IN_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/X_IN
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_x_in_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/X_OUT_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/R_IN_I_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/R_IN_K_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/R_IN
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_r_in_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/R_OUT_I_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/R_OUT_K_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/RHO_IN_I_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/RHO_IN_M_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/RHO_IN
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_rho_in_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/RHO_OUT_I_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/RHO_OUT_M_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/XI_IN_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/XI_IN
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_xi_in_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/XI_OUT_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/H_IN_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/H_IN
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/H_OUT_ENABLE

add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/READY
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_h_in_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/H_ENABLE
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/H_OUT

add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/start_first_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/operation_first_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_in_first_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_enable_first_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_first_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_enable_first_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_first_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/ready_first_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_first_vector_float_adder_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_enable_first_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_first_vector_float_adder

add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/start_second_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/operation_second_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_in_second_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_enable_second_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_second_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_enable_second_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_second_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/ready_second_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_second_vector_float_adder_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_enable_second_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_second_vector_float_adder

add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/start_third_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/operation_third_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_in_third_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_enable_third_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_third_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_enable_third_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_third_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/ready_third_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_third_vector_float_adder_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_enable_third_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_third_vector_float_adder

add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/start_fourth_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/operation_fourth_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_in_fourth_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_enable_fourth_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_fourth_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_enable_fourth_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_fourth_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/ready_fourth_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_fourth_vector_float_adder_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_enable_fourth_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_fourth_vector_float_adder

add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/start_fiveth_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/operation_fiveth_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_in_fiveth_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_enable_fiveth_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_fiveth_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_enable_fiveth_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_fiveth_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/ready_fiveth_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_fiveth_vector_float_adder_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_enable_fiveth_vector_float_adder
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_fiveth_vector_float_adder

add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/start_first_vector_summation
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_in_first_vector_summation
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/length_in_first_vector_summation
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_in_length_enable_first_vector_summation
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_in_enable_first_vector_summation
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_in_first_vector_summation
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_length_enable_first_vector_summation
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_enable_first_vector_summation
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/ready_first_vector_summation
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_first_vector_summation_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_enable_first_vector_summation
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_first_vector_summation

add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/start_second_vector_summation
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_in_second_vector_summation
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/length_in_second_vector_summation
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_in_length_enable_second_vector_summation
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_in_enable_second_vector_summation
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_in_second_vector_summation
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_length_enable_second_vector_summation
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_enable_second_vector_summation
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/ready_second_vector_summation
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_second_vector_summation_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_enable_second_vector_summation
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_second_vector_summation

add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/start_first_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_a_i_in_first_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_a_j_in_first_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_a_k_in_first_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_b_i_in_first_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_b_j_in_first_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_i_enable_first_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_j_enable_first_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_k_enable_first_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_first_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_i_enable_first_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_j_enable_first_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_first_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_i_enable_first_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_j_enable_first_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_k_enable_first_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/ready_first_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_first_tensor_matrix_convolution_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_i_enable_first_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_j_enable_first_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_first_tensor_matrix_convolution

add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/start_second_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_a_i_in_second_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_a_j_in_second_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_a_k_in_second_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_b_i_in_second_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_b_j_in_second_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_i_enable_second_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_j_enable_second_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_k_enable_second_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_second_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_i_enable_second_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_j_enable_second_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_second_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_i_enable_second_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_j_enable_second_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_k_enable_second_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/ready_second_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_second_tensor_matrix_convolution_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_i_enable_second_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_j_enable_second_tensor_matrix_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_second_tensor_matrix_convolution

add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/start_first_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_a_i_in_first_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_a_j_in_first_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_b_in_first_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_i_enable_first_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_j_enable_first_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_first_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_enable_first_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_first_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_i_enable_first_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_j_enable_first_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/ready_first_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_first_matrix_vector_convolution_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_enable_first_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_first_matrix_vector_convolution

add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/start_second_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_a_i_in_second_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_a_j_in_second_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_b_in_second_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_i_enable_second_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_j_enable_second_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_second_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_enable_second_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_second_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_i_enable_second_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_j_enable_second_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/ready_second_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_second_matrix_vector_convolution_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_enable_second_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_second_matrix_vector_convolution

add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/start_third_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_a_i_in_third_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_a_j_in_third_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_b_in_third_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_i_enable_third_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_j_enable_third_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_a_in_third_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_enable_third_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_b_in_third_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_i_enable_third_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_j_enable_third_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/ready_third_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_third_matrix_vector_convolution_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_enable_third_matrix_vector_convolution
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_third_matrix_vector_convolution

add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/start_vector_logistic
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/size_in_vector_logistic
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_in_enable_vector_logistic
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_in_vector_logistic
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/ready_vector_logistic
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_vector_logistic_enable_int
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_enable_vector_logistic
add wave -noupdate /accelerator_convolutional_fnn_testbench/accelerator_convolutional_fnn_test/controller/data_out_vector_logistic

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
