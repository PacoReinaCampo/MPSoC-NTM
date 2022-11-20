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
g++ arithmetic/ntm_matrix_arithmetic.cpp -o arithmetic/ntm_matrix_arithmetic.run
g++ arithmetic/ntm_scalar_arithmetic.cpp -o arithmetic/ntm_scalar_arithmetic.run
g++ arithmetic/ntm_tensor_arithmetic.cpp -o arithmetic/ntm_tensor_arithmetic.run
g++ arithmetic/ntm_vector_arithmetic.cpp -o arithmetic/ntm_vector_arithmetic.run

g++ controller/ntm_fnn_controller.cpp -o controller/ntm_fnn_controller.run
g++ controller/ntm_lstm_controller.cpp -o controller/ntm_lstm_controller.run
g++ controller/ntm_transformer_controller.cpp -o controller/ntm_transformer_controller.run
	
g++ dnc/dnc.cpp -o dnc/dnc.run
	
g++ math/algebra/ntm_matrix_math_algebra.cpp -o math/algebra/ntm_matrix_math_algebra.run
g++ math/algebra/ntm_scalar_math_algebra.cpp -o math/algebra/ntm_scalar_math_algebra.run
g++ math/algebra/ntm_tensor_math_algebra.cpp -o math/algebra/ntm_tensor_math_algebra.run
g++ math/algebra/ntm_vector_math_algebra.cpp -o math/algebra/ntm_vector_math_algebra.run
	
g++ math/calculus/ntm_matrix_math_calculus.cpp -o math/calculus/ntm_matrix_math_calculus.run
g++ math/calculus/ntm_tensor_math_calculus.cpp -o math/calculus/ntm_tensor_math_calculus.run
g++ math/calculus/ntm_vector_math_calculus.cpp -o math/calculus/ntm_vector_math_calculus.run
	
g++ math/function/ntm_matrix_math_function.cpp -o math/function/ntm_matrix_math_function.run
g++ math/function/ntm_scalar_math_function.cpp -o math/function/ntm_scalar_math_function.run
g++ math/function/ntm_vector_math_function.cpp -o math/function/ntm_vector_math_function.run
	
g++ math/statitics/ntm_matrix_math_statitics.cpp -o math/statitics/ntm_matrix_math_statitics.run
g++ math/statitics/ntm_scalar_math_statitics.cpp -o math/statitics/ntm_scalar_math_statitics.run
g++ math/statitics/ntm_vector_math_statitics.cpp -o math/statitics/ntm_vector_math_statitics.run
	
g++ ntm/ntm.cpp -o ntm/ntm.run
	
#g++ state/ntm_state.cpp -o state/ntm_state.run
	
g++ trainer/ntm_fnn.cpp -o trainer/ntm_fnn.run
g++ trainer/ntm_lstm.cpp -o trainer/ntm_lstm.run
