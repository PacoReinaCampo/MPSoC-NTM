@echo off
call ../../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/ntm_arithmetic_pkg.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/ntm_math_pkg.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/ntm_lstm_controller_pkg.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/scalar/ntm_scalar_float_divider.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/vector/ntm_vector_float_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/vector/ntm_vector_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/vector/ntm_vector_float_divider.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/matrix/ntm_matrix_float_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/matrix/ntm_matrix_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/matrix/ntm_matrix_float_divider.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/ntm_dot_product.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/ntm_vector_convolution.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/ntm_vector_cosine_similarity.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/ntm_vector_multiplication.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/ntm_vector_summation.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/ntm_vector_module.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/ntm_matrix_convolution.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/ntm_matrix_inverse.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/ntm_matrix_multiplication.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/ntm_matrix_product.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/ntm_matrix_summation.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/ntm_matrix_transpose.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/ntm_tensor_convolution.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/ntm_tensor_inverse.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/ntm_tensor_multiplication.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/ntm_tensor_product.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/ntm_tensor_summation.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/ntm_tensor_transpose.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/calculus/vector/ntm_vector_differentiation.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/calculus/vector/ntm_vector_integration.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/calculus/vector/ntm_vector_softmax.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/calculus/matrix/ntm_matrix_differentiation.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/calculus/matrix/ntm_matrix_integration.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/calculus/matrix/ntm_matrix_softmax.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/calculus/tensor/ntm_tensor_differentiation.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/calculus/tensor/ntm_tensor_integration.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/calculus/tensor/ntm_tensor_softmax.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/scalar/ntm_scalar_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/scalar/ntm_scalar_oneplus_function.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/vector/ntm_vector_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/vector/ntm_vector_oneplus_function.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/matrix/ntm_matrix_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/matrix/ntm_matrix_oneplus_function.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/scalar/ntm_scalar_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/scalar/ntm_scalar_exponentiator_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/scalar/ntm_scalar_logarithm_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/scalar/ntm_scalar_sinh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/scalar/ntm_scalar_tanh_function.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/vector/ntm_vector_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/vector/ntm_vector_exponentiator_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/vector/ntm_vector_logarithm_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/vector/ntm_vector_sinh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/vector/ntm_vector_tanh_function.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/matrix/ntm_matrix_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/matrix/ntm_matrix_exponentiator_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/matrix/ntm_matrix_logarithm_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/matrix/ntm_matrix_sinh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/matrix/ntm_matrix_tanh_function.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/trainer/FNN/ntm_trainer.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/controller/FNN/convolutional/ntm_controller.vhd

ghdl -a --std=08 ../../../../../../../bench/vhdl/osvvm/controller/FNN/convolutional/ntm_convolutional_fnn_pkg.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/osvvm/controller/FNN/convolutional/ntm_convolutional_fnn_stimulus.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/osvvm/controller/FNN/convolutional/ntm_convolutional_fnn_testbench.vhd

ghdl -m --std=08 ntm_convolutional_fnn_testbench
ghdl -r --std=08 ntm_convolutional_fnn_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > ntm_convolutional_fnn_testbench.tree
pause