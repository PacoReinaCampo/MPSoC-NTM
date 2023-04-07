###################################################################################
##                                            __ _      _     _                  ##
##                                           / _(_)    | |   | |                 ##
##                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 ##
##               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 ##
##              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 ##
##               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 ##
##                  | |                                                          ##
##                  |_|                                                          ##
##                                                                               ##
##                                                                               ##
##              Peripheral-NTM for MPSoC                                         ##
##              Neural Turing Machine for MPSoC                                  ##
##                                                                               ##
###################################################################################

###################################################################################
##                                                                               ##
## Copyright (c) 2021-2022 by the author(s)                                      ##
##                                                                               ##
## Permission is hereby granted, free of charge, to any person obtaining a copy  ##
## of this software and associated documentation files (the "Software"), to deal ##
## in the Software without restriction, including without limitation the rights  ##
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     ##
## copies of the Software, and to permit persons to whom the Software is         ##
## furnished to do so, subject to the following conditions:                      ##
##                                                                               ##
## The above copyright notice and this permission notice shall be included in    ##
## all copies or substantial portions of the Software.                           ##
##                                                                               ##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    ##
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      ##
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   ##
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        ##
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, ##
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     ##
## THE SOFTWARE.                                                                 ##
##                                                                               ##
## ============================================================================= ##
## Author(s):                                                                    ##
##   Francisco Javier Reina Campo <pacoreinacampo@queenfield.tech>               ##
##                                                                               ##
###################################################################################

read_verilog -sv ../../../../rtl/verilog/math/integer/scalar/ntm_scalar_integer_adder.sv
read_verilog -sv ../../../../rtl/verilog/math/integer/scalar/ntm_scalar_integer_multiplier.sv
read_verilog -sv ../../../../rtl/verilog/math/integer/scalar/ntm_scalar_integer_divider.sv

read_verilog -sv ../../../../rtl/verilog/math/integer/vector/ntm_vector_integer_adder.sv
read_verilog -sv ../../../../rtl/verilog/math/integer/vector/ntm_vector_integer_multiplier.sv
read_verilog -sv ../../../../rtl/verilog/math/integer/vector/ntm_vector_integer_divider.sv

read_verilog -sv ../../../../rtl/verilog/math/integer/matrix/ntm_matrix_integer_adder.sv
read_verilog -sv ../../../../rtl/verilog/math/integer/matrix/ntm_matrix_integer_multiplier.sv
read_verilog -sv ../../../../rtl/verilog/math/integer/matrix/ntm_matrix_integer_divider.sv

read_verilog -sv ../../../../rtl/verilog/math/float/scalar/ntm_scalar_adder.sv
read_verilog -sv ../../../../rtl/verilog/math/float/scalar/ntm_scalar_multiplier.sv
read_verilog -sv ../../../../rtl/verilog/math/float/scalar/ntm_scalar_divider.sv

read_verilog -sv ../../../../rtl/verilog/math/float/vector/ntm_vector_adder.sv
read_verilog -sv ../../../../rtl/verilog/math/float/vector/ntm_vector_multiplier.sv
read_verilog -sv ../../../../rtl/verilog/math/float/vector/ntm_vector_divider.sv

read_verilog -sv ../../../../rtl/verilog/math/float/matrix/ntm_matrix_adder.sv
read_verilog -sv ../../../../rtl/verilog/math/float/matrix/ntm_matrix_multiplier.sv
read_verilog -sv ../../../../rtl/verilog/math/float/matrix/ntm_matrix_divider.sv

read_verilog -sv ../../../../rtl/verilog/math/algebra/ntm_matrix_product.sv
read_verilog -sv ../../../../rtl/verilog/math/algebra/ntm_tensor_transpose.sv
read_verilog -sv ../../../../rtl/verilog/math/algebra/ntm_matrix_transpose.sv
read_verilog -sv ../../../../rtl/verilog/math/algebra/ntm_scalar_product.sv
read_verilog -sv ../../../../rtl/verilog/math/algebra/ntm_tensor_product.sv

read_verilog -sv ../../../../rtl/verilog/math/function/scalar/ntm_scalar_exponentiator.sv
read_verilog -sv ../../../../rtl/verilog/math/function/scalar/ntm_scalar_convolution_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/scalar/ntm_scalar_cosh_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/scalar/ntm_scalar_cosine_similarity_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/scalar/ntm_scalar_differentiation_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/scalar/ntm_scalar_logistic_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/scalar/ntm_scalar_multiplication_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/scalar/ntm_scalar_oneplus_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/scalar/ntm_scalar_sinh_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/scalar/ntm_scalar_softmax_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/scalar/ntm_scalar_summation_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/scalar/ntm_scalar_tanh_function.sv

read_verilog -sv ../../../../rtl/verilog/math/function/vector/ntm_vector_exponentiator.sv
read_verilog -sv ../../../../rtl/verilog/math/function/vector/ntm_vector_convolution_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/vector/ntm_vector_cosh_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/vector/ntm_vector_cosine_similarity_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/vector/ntm_vector_differentiation_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/vector/ntm_vector_logistic_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/vector/ntm_vector_multiplication_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/vector/ntm_vector_oneplus_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/vector/ntm_vector_sinh_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/vector/ntm_vector_softmax_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/vector/ntm_vector_summation_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/vector/ntm_vector_tanh_function.sv

read_verilog -sv ../../../../rtl/verilog/math/function/matrix/ntm_matrix_exponentiator.sv
read_verilog -sv ../../../../rtl/verilog/math/function/matrix/ntm_matrix_convolution_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/matrix/ntm_matrix_cosh_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/matrix/ntm_matrix_cosine_similarity_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/matrix/ntm_matrix_differentiation_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/matrix/ntm_matrix_logistic_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/matrix/ntm_matrix_multiplication_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/matrix/ntm_matrix_oneplus_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/matrix/ntm_matrix_sinh_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/matrix/ntm_matrix_softmax_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/matrix/ntm_matrix_summation_function.sv
read_verilog -sv ../../../../rtl/verilog/math/function/matrix/ntm_matrix_tanh_function.sv

read_verilog -sv ../../../../rtl/verilog/controller/LSTM/convolutional/ntm_controller.sv
read_verilog -sv ../../../../rtl/verilog/controller/LSTM/convolutional/ntm_activation_gate_vector.sv
read_verilog -sv ../../../../rtl/verilog/controller/LSTM/convolutional/ntm_activation_trainer.sv
read_verilog -sv ../../../../rtl/verilog/controller/LSTM/convolutional/ntm_forget_gate_vector.sv
read_verilog -sv ../../../../rtl/verilog/controller/LSTM/convolutional/ntm_forget_trainer.sv
read_verilog -sv ../../../../rtl/verilog/controller/LSTM/convolutional/ntm_hidden_gate_vector.sv
read_verilog -sv ../../../../rtl/verilog/controller/LSTM/convolutional/ntm_input_gate_vector.sv
read_verilog -sv ../../../../rtl/verilog/controller/LSTM/convolutional/ntm_input_trainer.sv
read_verilog -sv ../../../../rtl/verilog/controller/LSTM/convolutional/ntm_output_gate_vector.sv
read_verilog -sv ../../../../rtl/verilog/controller/LSTM/convolutional/ntm_output_trainer.sv
read_verilog -sv ../../../../rtl/verilog/controller/LSTM/convolutional/ntm_state_gate_vector.sv

read_verilog -sv ../../../../rtl/verilog/ntm/read_heads/ntm_reading.sv

read_verilog -sv ../../../../rtl/verilog/ntm/write_heads/ntm_writing.sv
read_verilog -sv ../../../../rtl/verilog/ntm/write_heads/ntm_erasing.sv

read_verilog -sv ../../../../rtl/verilog/ntm/memory/ntm_addressing.sv
read_verilog -sv ../../../../rtl/verilog/ntm/memory/ntm_content_based_addressing.sv

read_verilog -sv ../../../../rtl/verilog/ntm/top/ntm_interface_vector.sv
read_verilog -sv ../../../../rtl/verilog/ntm/top/ntm_output_vector.sv
read_verilog -sv ../../../../rtl/verilog/ntm/top/ntm_top.sv

read_verilog -sv ntm_top_synthesis.sv

read_xdc system.xdc

synth_design -part xc7z020-clg484-1 -include_dirs ../../../../rtl/verilog/pkg -top ntm_top_synthesis

opt_design
place_design
route_design

report_utilization
report_timing

write_edif -force system.edif
write_bitstream -force system.bit
