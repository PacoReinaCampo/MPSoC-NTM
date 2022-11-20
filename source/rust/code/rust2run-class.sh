rm -rf arithmetic/ntm_matrix_arithmetic.run
rm -rf arithmetic/ntm_scalar_arithmetic.run
rm -rf arithmetic/ntm_tensor_arithmetic.run
rm -rf arithmetic/ntm_vector_arithmetic.run

rm -rf controller/ntm_fnn_controller.run
rm -rf controller/ntm_lstm_controller.run
rm -rf controller/ntm_transformer_controller.run

rm -rf dnc/dnc.run

rm -rf math/algebra/ntm_matrix_math_algebra.run
rm -rf math/algebra/ntm_scalar_math_algebra.run
rm -rf math/algebra/ntm_tensor_math_algebra.run
rm -rf math/algebra/ntm_vector_math_algebra.run

rm -rf math/calculus/ntm_matrix_math_calculus.run
rm -rf math/calculus/ntm_tensor_math_calculus.run
rm -rf math/calculus/ntm_vector_math_calculus.run

rm -rf math/function/ntm_matrix_math_function.run
rm -rf math/function/ntm_scalar_math_function.run
rm -rf math/function/ntm_vector_math_function.run

rm -rf math/statitics/ntm_matrix_math_statitics.run
rm -rf math/statitics/ntm_scalar_math_statitics.run
rm -rf math/statitics/ntm_vector_math_statitics.run

rm -rf ntm/ntm.run

rm -rf state/ntm_state.run

rm -rf trainer/ntm_fnn.run
rm -rf trainer/ntm_lstm.run

# x86-64 ISA
rustc arithmetic/ntm_matrix_arithmetic.rs -o arithmetic/ntm_matrix_arithmetic.run
rustc arithmetic/ntm_scalar_arithmetic.rs -o arithmetic/ntm_scalar_arithmetic.run
rustc arithmetic/ntm_tensor_arithmetic.rs -o arithmetic/ntm_tensor_arithmetic.run
rustc arithmetic/ntm_vector_arithmetic.rs -o arithmetic/ntm_vector_arithmetic.run

rustc controller/ntm_fnn_controller.rs -o controller/ntm_fnn_controller.run
rustc controller/ntm_lstm_controller.rs -o controller/ntm_lstm_controller.run
rustc controller/ntm_transformer_controller.rs -o controller/ntm_transformer_controller.run
	
rustc dnc/dnc.rs -o dnc/dnc.run
	
rustc math/algebra/ntm_matrix_math_algebra.rs -o math/algebra/ntm_matrix_math_algebra.run
rustc math/algebra/ntm_scalar_math_algebra.rs -o math/algebra/ntm_scalar_math_algebra.run
rustc math/algebra/ntm_tensor_math_algebra.rs -o math/algebra/ntm_tensor_math_algebra.run
rustc math/algebra/ntm_vector_math_algebra.rs -o math/algebra/ntm_vector_math_algebra.run
	
rustc math/calculus/ntm_matrix_math_calculus.rs -o math/calculus/ntm_matrix_math_calculus.run
rustc math/calculus/ntm_tensor_math_calculus.rs -o math/calculus/ntm_tensor_math_calculus.run
rustc math/calculus/ntm_vector_math_calculus.rs -o math/calculus/ntm_vector_math_calculus.run
	
rustc math/function/ntm_matrix_math_function.rs -o math/function/ntm_matrix_math_function.run
rustc math/function/ntm_scalar_math_function.rs -o math/function/ntm_scalar_math_function.run
rustc math/function/ntm_vector_math_function.rs -o math/function/ntm_vector_math_function.run
	
rustc math/statitics/ntm_matrix_math_statitics.rs -o math/statitics/ntm_matrix_math_statitics.run
rustc math/statitics/ntm_scalar_math_statitics.rs -o math/statitics/ntm_scalar_math_statitics.run
rustc math/statitics/ntm_vector_math_statitics.rs -o math/statitics/ntm_vector_math_statitics.run
	
rustc ntm/ntm.rs -o ntm/ntm.run
	
#rustc state/ntm_state.rs -o state/ntm_state.run
	
rustc trainer/ntm_fnn.rs -o trainer/ntm_fnn.run
rustc trainer/ntm_lstm.rs -o trainer/ntm_lstm.run
