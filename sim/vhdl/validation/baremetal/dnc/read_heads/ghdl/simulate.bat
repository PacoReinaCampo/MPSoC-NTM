@echo off
call ../../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../../model/vhdl/code/pkg/model_arithmetic_pkg.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/pkg/model_math_pkg.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/pkg/model_dnc_core_pkg.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/scalar/model_scalar_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/scalar/model_scalar_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/vector/model_vector_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/vector/model_vector_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/vector/model_vector_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/matrix/model_matrix_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/matrix/model_matrix_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/matrix/model_matrix_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/vector/model_dot_product.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/vector/model_vector_convolution.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/vector/model_vector_cosine_similarity.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/vector/model_vector_multiplication.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/vector/model_vector_summation.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/vector/model_vector_module.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/matrix/model_matrix_convolution.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/matrix/model_matrix_inverse.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/matrix/model_matrix_multiplication.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/matrix/model_matrix_product.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/matrix/model_matrix_summation.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/matrix/model_matrix_transpose.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/tensor/model_tensor_convolution.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/tensor/model_tensor_inverse.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/tensor/model_tensor_multiplication.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/tensor/model_tensor_product.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/tensor/model_tensor_summation.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/tensor/model_tensor_transpose.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/scalar/model_scalar_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/scalar/model_scalar_exponentiator_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/scalar/model_scalar_logarithm_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/scalar/model_scalar_sinh_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/scalar/model_scalar_tanh_function.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/vector/model_vector_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/vector/model_vector_exponentiator_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/vector/model_vector_logarithm_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/vector/model_vector_sinh_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/vector/model_vector_tanh_function.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/matrix/model_matrix_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/matrix/model_matrix_exponentiator_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/matrix/model_matrix_logarithm_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/matrix/model_matrix_sinh_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/matrix/model_matrix_tanh_function.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/scalar/model_scalar_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/scalar/model_scalar_oneplus_function.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/vector/model_vector_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/vector/model_vector_oneplus_function.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/matrix/model_matrix_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/matrix/model_matrix_oneplus_function.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/calculus/vector/model_vector_differentiation.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/calculus/vector/model_vector_integration.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/calculus/vector/model_vector_softmax.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/calculus/matrix/model_matrix_differentiation.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/calculus/matrix/model_matrix_integration.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/calculus/matrix/model_matrix_softmax.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/calculus/tensor/model_tensor_differentiation.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/calculus/tensor/model_tensor_integration.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/calculus/tensor/model_tensor_softmax.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/dnc/read_heads/model_read_heads.vhd

ghdl -a --std=08 ../../../../../../../bench/vhdl/code/baremetal/model/dnc/read_heads/model_read_heads_pkg.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/code/baremetal/model/dnc/read_heads/model_read_heads_stimulus.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/code/baremetal/model/dnc/read_heads/model_read_heads_testbench.vhd

ghdl -m --std=08 model_read_heads_testbench
ghdl -r --std=08 model_read_heads_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > model_read_heads_testbench.tree
pause
