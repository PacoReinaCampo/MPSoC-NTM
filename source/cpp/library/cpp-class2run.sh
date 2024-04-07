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
##              QueenField                                                       ##
##              Multi-Processor System on Chip                                   ##
##                                                                               ##
###################################################################################

###################################################################################
##                                                                               ##
## Copyright (c) 2022-2025 by the author(s)                                      ##
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
##   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           ##
##                                                                               ##
###################################################################################

rm -rf arithmetic/ntm_matrix_arithmetic.run
rm -rf arithmetic/ntm_scalar_arithmetic.run
rm -rf arithmetic/ntm_tensor_arithmetic.run
rm -rf arithmetic/ntm_vector_arithmetic.run

rm -rf controller/ntm_fnn_controller.run
rm -rf controller/ntm_lstm_controller.run
rm -rf controller/ntm_transformer_controller.run

rm -rf dnc/dnc.run

rm -rf algebra/ntm_matrix_math_algebra.run
rm -rf algebra/ntm_scalar_math_algebra.run
rm -rf algebra/ntm_tensor_math_algebra.run
rm -rf algebra/ntm_vector_math_algebra.run

rm -rf algebra/ntm_matrix_math_calculus.run
rm -rf algebra/ntm_tensor_math_calculus.run
rm -rf algebra/ntm_vector_math_calculus.run

rm -rf math/ntm_matrix_math_function.run
rm -rf math/ntm_scalar_math_function.run
rm -rf math/ntm_vector_math_function.run

rm -rf math/ntm_matrix_math_statitics.run
rm -rf math/ntm_scalar_math_statitics.run
rm -rf math/ntm_vector_math_statitics.run

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
	
g++ algebra/ntm_matrix_math_algebra.cpp -o algebra/ntm_matrix_math_algebra.run
g++ algebra/ntm_scalar_math_algebra.cpp -o algebra/ntm_scalar_math_algebra.run
g++ algebra/ntm_tensor_math_algebra.cpp -o algebra/ntm_tensor_math_algebra.run
g++ algebra/ntm_vector_math_algebra.cpp -o algebra/ntm_vector_math_algebra.run
	
g++ algebra/ntm_matrix_math_calculus.cpp -o algebra/ntm_matrix_math_calculus.run
g++ algebra/ntm_tensor_math_calculus.cpp -o algebra/ntm_tensor_math_calculus.run
g++ algebra/ntm_vector_math_calculus.cpp -o algebra/ntm_vector_math_calculus.run
	
g++ math/ntm_matrix_math_function.cpp -o math/ntm_matrix_math_function.run
g++ math/ntm_scalar_math_function.cpp -o math/ntm_scalar_math_function.run
g++ math/ntm_vector_math_function.cpp -o math/ntm_vector_math_function.run
	
g++ math/ntm_matrix_math_statitics.cpp -o math/ntm_matrix_math_statitics.run
g++ math/ntm_scalar_math_statitics.cpp -o math/ntm_scalar_math_statitics.run
g++ math/ntm_vector_math_statitics.cpp -o math/ntm_vector_math_statitics.run
	
g++ ntm/ntm.cpp -o ntm/ntm.run
	
#g++ state/ntm_state.cpp -o state/ntm_state.run
	
g++ trainer/ntm_fnn.cpp -o trainer/ntm_fnn.run
g++ trainer/ntm_lstm.cpp -o trainer/ntm_lstm.run
