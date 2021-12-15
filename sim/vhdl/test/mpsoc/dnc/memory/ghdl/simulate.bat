@echo off
call ../../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/ntm_math_pkg.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/dnc_core_pkg.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/scalar/ntm_scalar_modular_mod.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/scalar/ntm_scalar_modular_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/scalar/ntm_scalar_modular_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/scalar/ntm_scalar_modular_inverter.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/scalar/ntm_scalar_modular_divider.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/scalar/ntm_scalar_modular_exponentiator.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/vector/ntm_vector_modular_mod.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/vector/ntm_vector_modular_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/vector/ntm_vector_modular_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/vector/ntm_vector_modular_inverter.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/vector/ntm_vector_modular_divider.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/vector/ntm_vector_modular_exponentiator.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/matrix/ntm_matrix_modular_mod.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/matrix/ntm_matrix_modular_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/matrix/ntm_matrix_modular_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/matrix/ntm_matrix_modular_inverter.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/matrix/ntm_matrix_modular_divider.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/matrix/ntm_matrix_modular_exponentiator.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/ntm_matrix_product.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/ntm_tensor_transpose.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/ntm_matrix_transpose.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/ntm_scalar_product.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/ntm_tensor_product.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_convolution_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_cosine_similarity_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_differentiation_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_multiplication_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_sinh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_tanh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_softmax_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_oneplus_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_summation_function.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_convolution_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_cosine_similarity_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_differentiation_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_multiplication_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_sinh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_tanh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_softmax_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_oneplus_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_summation_function.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_modular_convolution_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_modular_cosine_similarity_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_modular_differentiation_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_modular_multiplication_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_modular_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_modular_sinh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_modular_tanh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_modular_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_modular_softmax_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_modular_oneplus_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_modular_summation_function.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_content_based_addressing.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_allocation_weighting.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_backward_weighting.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_forward_weighting.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_memory_matrix.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_memory_retention_vector.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_precedence_weighting.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_read_content_weighting.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_read_vectors.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_read_weighting.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_sort_vector.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_temporal_link_matrix.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_usage_vector.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_write_content_weighting.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_write_weighting.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_addressing.vhd

ghdl -a --std=08 ../../../../../../../bench/vhdl/test/dnc/memory/dnc_memory_pkg.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/test/dnc/memory/dnc_memory_stimulus.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/test/dnc/memory/dnc_memory_testbench.vhd
ghdl -m --std=08 dnc_memory_testbench
ghdl -r --std=08 dnc_memory_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > dnc_memory_testbench.tree
pause
