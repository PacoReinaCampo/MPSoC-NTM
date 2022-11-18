rm -rf arithmetic/ntm_matrix_arithmetic.run
rm -rf arithmetic/ntm_scalar_arithmetic.run
rm -rf arithmetic/ntm_tensor_arithmetic.run
rm -rf arithmetic/ntm_vector_arithmetic.run

# x86-64 ISA
rustc arithmetic/ntm_matrix_arithmetic.rs -o arithmetic/ntm_matrix_arithmetic.run
rustc arithmetic/ntm_scalar_arithmetic.rs -o arithmetic/ntm_scalar_arithmetic.run
rustc arithmetic/ntm_tensor_arithmetic.rs -o arithmetic/ntm_tensor_arithmetic.run
rustc arithmetic/ntm_vector_arithmetic.rs -o arithmetic/ntm_vector_arithmetic.run
