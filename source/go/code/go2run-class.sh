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
go build -o arithmetic/ntm_matrix_arithmetic.run arithmetic/ntm_matrix_arithmetic.go
go build -o arithmetic/ntm_scalar_arithmetic.run arithmetic/ntm_scalar_arithmetic.go
go build -o arithmetic/ntm_tensor_arithmetic.run arithmetic/ntm_tensor_arithmetic.go
go build -o arithmetic/ntm_vector_arithmetic.run arithmetic/ntm_vector_arithmetic.go

go build -o controller/ntm_fnn_controller.run controller/ntm_fnn_controller.go
go build -o controller/ntm_lstm_controller.run controller/ntm_lstm_controller.go
go build -o controller/ntm_transformer_controller.run controller/ntm_transformer_controller.go
	
go build -o dnc/dnc.run dnc/dnc.go
	
go build -o math/algebra/ntm_matrix_math_algebra.run math/algebra/ntm_matrix_math_algebra.go
go build -o math/algebra/ntm_scalar_math_algebra.run math/algebra/ntm_scalar_math_algebra.go
go build -o math/algebra/ntm_tensor_math_algebra.run math/algebra/ntm_tensor_math_algebra.go
go build -o math/algebra/ntm_vector_math_algebra.run math/algebra/ntm_vector_math_algebra.go
	
go build -o math/calculus/ntm_matrix_math_calculus.run math/calculus/ntm_matrix_math_calculus.go
go build -o math/calculus/ntm_tensor_math_calculus.run math/calculus/ntm_tensor_math_calculus.go
go build -o math/calculus/ntm_vector_math_calculus.run math/calculus/ntm_vector_math_calculus.go
	
go build -o math/function/ntm_matrix_math_function.run math/function/ntm_matrix_math_function.go
go build -o math/function/ntm_scalar_math_function.run math/function/ntm_scalar_math_function.go
go build -o math/function/ntm_vector_math_function.run math/function/ntm_vector_math_function.go
	
go build -o math/statitics/ntm_matrix_math_statitics.run math/statitics/ntm_matrix_math_statitics.go
go build -o math/statitics/ntm_scalar_math_statitics.run math/statitics/ntm_scalar_math_statitics.go
go build -o math/statitics/ntm_vector_math_statitics.run math/statitics/ntm_vector_math_statitics.go
	
go build -o ntm/ntm.run ntm/ntm.go
	
#go build -o state/ntm_state.run state/ntm_state.go
	
go build -o trainer/ntm_fnn.run trainer/ntm_fnn.go
go build -o trainer/ntm_lstm.run trainer/ntm_lstm.go
