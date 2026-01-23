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

rm -rf arithmetic/accelerator_matrix_arithmetic.run
rm -rf arithmetic/accelerator_scalar_arithmetic.run
rm -rf arithmetic/accelerator_tensor_arithmetic.run
rm -rf arithmetic/accelerator_vector_arithmetic.run

rm -rf algebra/accelerator_matrix_algebra.run
rm -rf algebra/accelerator_scalar_algebra.run
rm -rf algebra/accelerator_tensor_algebra.run
rm -rf algebra/accelerator_vector_algebra.run

rm -rf math/accelerator_matrix_math.run
rm -rf math/accelerator_scalar_math.run
rm -rf math/accelerator_vector_math.run

rm -rf nn/accelerator_fnn_controller.run
rm -rf nn/accelerator_lstm_controller.run
rm -rf nn/accelerator_ann_controller.run

rm -rf ntm/ntm.run
rm -rf dnc/dnc.run
rm -rf ann/ann.run

rm -rf state/accelerator_state.run

rm -rf trainer/accelerator_fnn.run
rm -rf trainer/accelerator_lstm.run

# x86-64 ISA
g++ arithmetic/accelerator_matrix_arithmetic.cpp -o arithmetic/accelerator_matrix_arithmetic.run
g++ arithmetic/accelerator_scalar_arithmetic.cpp -o arithmetic/accelerator_scalar_arithmetic.run
g++ arithmetic/accelerator_tensor_arithmetic.cpp -o arithmetic/accelerator_tensor_arithmetic.run
g++ arithmetic/accelerator_vector_arithmetic.cpp -o arithmetic/accelerator_vector_arithmetic.run

g++ algebra/accelerator_matrix_algebra.cpp -o algebra/accelerator_matrix_algebra.run
g++ algebra/accelerator_scalar_algebra.cpp -o algebra/accelerator_scalar_algebra.run
g++ algebra/accelerator_tensor_algebra.cpp -o algebra/accelerator_tensor_algebra.run
g++ algebra/accelerator_vector_algebra.cpp -o algebra/accelerator_vector_algebra.run

g++ math/accelerator_matrix_math.cpp -o math/accelerator_matrix_math.run
g++ math/accelerator_scalar_math.cpp -o math/accelerator_scalar_math.run
g++ math/accelerator_vector_math.cpp -o math/accelerator_vector_math.run

g++ nn/accelerator_fnn_controller.cpp -o nn/accelerator_fnn_controller.run
g++ nn/accelerator_lstm_controller.cpp -o nn/accelerator_lstm_controller.run
g++ nn/accelerator_ann_controller.cpp -o nn/accelerator_ann_controller.run

g++ ntm/ntm.cpp -o ntm/ntm.run
g++ dnc/dnc.cpp -o dnc/dnc.run
g++ ann/ann.cpp -o ann/ann.run

#g++ state/accelerator_state.cpp -o state/accelerator_state.run

g++ trainer/accelerator_fnn.cpp -o trainer/accelerator_fnn.run
g++ trainer/accelerator_lstm.cpp -o trainer/accelerator_lstm.run
