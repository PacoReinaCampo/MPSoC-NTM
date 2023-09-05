@echo off
call ../../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/accelerator_arithmetic_pkg.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/accelerator_math_pkg.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/scalar/accelerator_scalar_float_divider.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/vector/accelerator_vector_float_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/vector/accelerator_vector_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/vector/accelerator_vector_float_divider.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/matrix/accelerator_matrix_float_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/matrix/accelerator_matrix_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/matrix/accelerator_matrix_float_divider.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/accelerator_dot_product.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/accelerator_vector_convolution.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/accelerator_vector_cosine_similarity.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/accelerator_vector_multiplication.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/accelerator_vector_summation.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/accelerator_vector_module.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/accelerator_matrix_convolution.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/accelerator_matrix_inverse.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/accelerator_matrix_multiplication.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/accelerator_matrix_product.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/accelerator_matrix_summation.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/accelerator_matrix_transpose.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/accelerator_matrix_vector_convolution.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/accelerator_matrix_vector_product.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/accelerator_tensor_convolution.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/accelerator_tensor_inverse.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/accelerator_tensor_matrix_convolution.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/accelerator_tensor_matrix_product.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/accelerator_tensor_product.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/accelerator_tensor_transpose.vhd

ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/math/algebra/accelerator_algebra_pkg.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/math/algebra/accelerator_algebra_stimulus.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/math/algebra/accelerator_algebra_testbench.vhd
ghdl -m --std=08 accelerator_algebra_testbench
ghdl -r --std=08 accelerator_algebra_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > accelerator_algebra_testbench.tree
pause
