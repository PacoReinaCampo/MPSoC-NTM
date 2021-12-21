////////////////////////////////////////////////////////////////////////////////
//                                            __ _      _     _               //
//                                           / _(_)    | |   | |              //
//                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              //
//               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              //
//              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              //
//               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              //
//                  | |                                                       //
//                  |_|                                                       //
//                                                                            //
//                                                                            //
//              Peripheral-NTM for MPSoC                                      //
//              Neural Turing Machine for MPSoC                               //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020-2021 by the author(s)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////
// Author(s):
//   Paco Reina Campo <pacoreinacampo@queenfield.tech>

module ntm_function_stimulus #(
  // SYSTEM-SIZE
  parameter DATA_SIZE=128,
  parameter CONTROL_SIZE=64,

  parameter X=64,
  parameter Y=64,
  parameter N=64,
  parameter W=64,
  parameter L=64,
  parameter R=64,

  // SCALAR-FUNCTIONALITY
  parameter STIMULUS_NTM_SCALAR_CONVOLUTION_TEST=0,
  parameter STIMULUS_NTM_SCALAR_COSINE_SIMILARITY_TEST=0,
  parameter STIMULUS_NTM_SCALAR_COSH_TEST=0,
  parameter STIMULUS_NTM_SCALAR_SINH_TEST=0,
  parameter STIMULUS_NTM_SCALAR_TANH_TEST=0,
  parameter STIMULUS_NTM_SCALAR_LOGISTIC_TEST=0,
  parameter STIMULUS_NTM_SCALAR_SOFTMAX_TEST=0,
  parameter STIMULUS_NTM_SCALAR_ONE_CONTROLPLUS_TEST=0,
  parameter STIMULUS_NTM_SCALAR_SUMMATION_TEST=0,
  parameter STIMULUS_NTM_SCALAR_CONVOLUTION_CASE_0=0,
  parameter STIMULUS_NTM_SCALAR_COSINE_SIMILARITY_CASE_0=0,
  parameter STIMULUS_NTM_SCALAR_COSH_CASE_0=0,
  parameter STIMULUS_NTM_SCALAR_SINH_CASE_0=0,
  parameter STIMULUS_NTM_SCALAR_TANH_CASE_0=0,
  parameter STIMULUS_NTM_SCALAR_LOGISTIC_CASE_0=0,
  parameter STIMULUS_NTM_SCALAR_SOFTMAX_CASE_0=0,
  parameter STIMULUS_NTM_SCALAR_ONE_CONTROLPLUS_CASE_0=0,
  parameter STIMULUS_NTM_SCALAR_SUMMATION_CASE_0=0,
  parameter STIMULUS_NTM_SCALAR_CONVOLUTION_CASE_1=0,
  parameter STIMULUS_NTM_SCALAR_COSINE_SIMILARITY_CASE_1=0,
  parameter STIMULUS_NTM_SCALAR_COSH_CASE_1=0,
  parameter STIMULUS_NTM_SCALAR_SINH_CASE_1=0,
  parameter STIMULUS_NTM_SCALAR_TANH_CASE_1=0,
  parameter STIMULUS_NTM_SCALAR_LOGISTIC_CASE_1=0,
  parameter STIMULUS_NTM_SCALAR_SOFTMAX_CASE_1=0,
  parameter STIMULUS_NTM_SCALAR_ONE_CONTROLPLUS_CASE_1=0,
  parameter STIMULUS_NTM_SCALAR_SUMMATION_CASE_1=0,

  // VECTOR-FUNCTIONALITY
  parameter STIMULUS_NTM_VECTOR_CONVOLUTION_TEST=0,
  parameter STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_TEST=0,
  parameter STIMULUS_NTM_VECTOR_COSH_TEST=0,
  parameter STIMULUS_NTM_VECTOR_SINH_TEST=0,
  parameter STIMULUS_NTM_VECTOR_TANH_TEST=0,
  parameter STIMULUS_NTM_VECTOR_LOGISTIC_TEST=0,
  parameter STIMULUS_NTM_VECTOR_SOFTMAX_TEST=0,
  parameter STIMULUS_NTM_VECTOR_ONE_CONTROLPLUS_TEST=0,
  parameter STIMULUS_NTM_VECTOR_SUMMATION_TEST=0,
  parameter STIMULUS_NTM_VECTOR_CONVOLUTION_CASE_0=0,
  parameter STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_CASE_0=0,
  parameter STIMULUS_NTM_VECTOR_COSH_CASE_0=0,
  parameter STIMULUS_NTM_VECTOR_SINH_CASE_0=0,
  parameter STIMULUS_NTM_VECTOR_TANH_CASE_0=0,
  parameter STIMULUS_NTM_VECTOR_LOGISTIC_CASE_0=0,
  parameter STIMULUS_NTM_VECTOR_SOFTMAX_CASE_0=0,
  parameter STIMULUS_NTM_VECTOR_ONE_CONTROLPLUS_CASE_0=0,
  parameter STIMULUS_NTM_VECTOR_SUMMATION_CASE_0=0,
  parameter STIMULUS_NTM_VECTOR_CONVOLUTION_CASE_1=0,
  parameter STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_CASE_1=0,
  parameter STIMULUS_NTM_VECTOR_COSH_CASE_1=0,
  parameter STIMULUS_NTM_VECTOR_SINH_CASE_1=0,
  parameter STIMULUS_NTM_VECTOR_TANH_CASE_1=0,
  parameter STIMULUS_NTM_VECTOR_LOGISTIC_CASE_1=0,
  parameter STIMULUS_NTM_VECTOR_SOFTMAX_CASE_1=0,
  parameter STIMULUS_NTM_VECTOR_ONE_CONTROLPLUS_CASE_1=0,
  parameter STIMULUS_NTM_VECTOR_SUMMATION_CASE_1=0,

  // MATRIX-FUNCTIONALITY
  parameter STIMULUS_NTM_MATRIX_CONVOLUTION_TEST=0,
  parameter STIMULUS_NTM_MATRIX_COSINE_SIMILARITY_TEST=0,
  parameter STIMULUS_NTM_MATRIX_COSH_TEST=0,
  parameter STIMULUS_NTM_MATRIX_SINH_TEST=0,
  parameter STIMULUS_NTM_MATRIX_TANH_TEST=0,
  parameter STIMULUS_NTM_MATRIX_LOGISTIC_TEST=0,
  parameter STIMULUS_NTM_MATRIX_SOFTMAX_TEST=0,
  parameter STIMULUS_NTM_MATRIX_ONE_CONTROLPLUS_TEST=0,
  parameter STIMULUS_NTM_MATRIX_SUMMATION_TEST=0,
  parameter STIMULUS_NTM_MATRIX_CONVOLUTION_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_COSINE_SIMILARITY_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_COSH_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_SINH_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_TANH_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_LOGISTIC_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_SOFTMAX_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_ONE_CONTROLPLUS_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_SUMMATION_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_CONVOLUTION_CASE_1=0,
  parameter STIMULUS_NTM_MATRIX_COSINE_SIMILARITY_CASE_1=0,
  parameter STIMULUS_NTM_MATRIX_COSH_CASE_1=0,
  parameter STIMULUS_NTM_MATRIX_SINH_CASE_1=0,
  parameter STIMULUS_NTM_MATRIX_TANH_CASE_1=0,
  parameter STIMULUS_NTM_MATRIX_LOGISTIC_CASE_1=0,
  parameter STIMULUS_NTM_MATRIX_SOFTMAX_CASE_1=0,
  parameter STIMULUS_NTM_MATRIX_ONE_CONTROLPLUS_CASE_1=0,
  parameter STIMULUS_NTM_MATRIX_SUMMATION_CASE_1=0
)
  (
    // GLOBAL
    output CLK,
    output RST,

    ///////////////////////////////////////////////////////////////////////
    // STIMULUS SCALAR
    ///////////////////////////////////////////////////////////////////////

    // SCALAR CONVOLUTION
    // CONTROL
    output SCALAR_CONVOLUTION_START,
    input SCALAR_CONVOLUTION_READY,

    output SCALAR_CONVOLUTION_DATA_A_IN_ENABLE,
    output SCALAR_CONVOLUTION_DATA_B_IN_ENABLE,

    input SCALAR_CONVOLUTION_DATA_OUT_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] SCALAR_CONVOLUTION_MODULO_IN,
    output [DATA_SIZE-1:0] SCALAR_CONVOLUTION_LENGTH_IN,
    output [DATA_SIZE-1:0] SCALAR_CONVOLUTION_DATA_A_IN,
    output [DATA_SIZE-1:0] SCALAR_CONVOLUTION_DATA_B_IN,
    input [DATA_SIZE-1:0] SCALAR_CONVOLUTION_DATA_OUT,

    // SCALAR COSINE SIMILARITY
    // CONTROL
    output SCALAR_COSINE_SIMILARITY_START,
    input SCALAR_COSINE_SIMILARITY_READY,

    output SCALAR_COSINE_SIMILARITY_DATA_A_IN_ENABLE,
    output SCALAR_COSINE_SIMILARITY_DATA_B_IN_ENABLE,

    input SCALAR_COSINE_SIMILARITY_DATA_OUT_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] SCALAR_COSINE_SIMILARITY_MODULO_IN,
    output [DATA_SIZE-1:0] SCALAR_COSINE_SIMILARITY_LENGTH_IN,
    output [DATA_SIZE-1:0] SCALAR_COSINE_SIMILARITY_DATA_A_IN,
    output [DATA_SIZE-1:0] SCALAR_COSINE_SIMILARITY_DATA_B_IN,
    input [DATA_SIZE-1:0] SCALAR_COSINE_SIMILARITY_DATA_OUT,

    // SCALAR MULTIPLICATION
    // CONTROL
    output SCALAR_MULTIPLICATION_START,
    input SCALAR_MULTIPLICATION_READY,

    output SCALAR_MULTIPLICATION_DATA_IN_ENABLE,
    input SCALAR_MULTIPLICATION_DATA_OUT_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] SCALAR_MULTIPLICATION_MODULO_IN,
    output [DATA_SIZE-1:0] SCALAR_MULTIPLICATION_LENGTH_IN,
    output [DATA_SIZE-1:0] SCALAR_MULTIPLICATION_DATA_IN,
    input [DATA_SIZE-1:0] SCALAR_MULTIPLICATION_DATA_OUT,

    // SCALAR COSH
    // CONTROL
    output SCALAR_COSH_START,
    input SCALAR_COSH_READY,

    // DATA
    output [DATA_SIZE-1:0] SCALAR_COSH_MODULO_IN,
    output [DATA_SIZE-1:0] SCALAR_COSH_DATA_IN,
    input [DATA_SIZE-1:0] SCALAR_COSH_DATA_OUT,

    // SCALAR SINH
    // CONTROL
    output SCALAR_SINH_START,
    input SCALAR_SINH_READY,

    // DATA
    output [DATA_SIZE-1:0] SCALAR_SINH_MODULO_IN,
    output [DATA_SIZE-1:0] SCALAR_SINH_DATA_IN,
    input [DATA_SIZE-1:0] SCALAR_SINH_DATA_OUT,

    // SCALAR TANH
    // CONTROL
    output SCALAR_TANH_START,
    input SCALAR_TANH_READY,

    // DATA
    output [DATA_SIZE-1:0] SCALAR_TANH_MODULO_IN,
    output [DATA_SIZE-1:0] SCALAR_TANH_DATA_IN,
    input [DATA_SIZE-1:0] SCALAR_TANH_DATA_OUT,

    // CONTROL
    output SCALAR_LOGISTIC_START,
    input SCALAR_LOGISTIC_READY,

    // DATA
    output [DATA_SIZE-1:0] SCALAR_LOGISTIC_MODULO_IN,
    output [DATA_SIZE-1:0] SCALAR_LOGISTIC_DATA_IN,
    input [DATA_SIZE-1:0] SCALAR_LOGISTIC_DATA_OUT,

    // SCALAR SOFTMAX
    // CONTROL
    output SCALAR_SOFTMAX_START,
    input SCALAR_SOFTMAX_READY,

    output SCALAR_SOFTMAX_DATA_IN_ENABLE,
    input SCALAR_SOFTMAX_DATA_OUT_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] SCALAR_SOFTMAX_MODULO_IN,
    output [DATA_SIZE-1:0] SCALAR_SOFTMAX_LENGTH_IN,
    output [DATA_SIZE-1:0] SCALAR_SOFTMAX_DATA_IN,
    input [DATA_SIZE-1:0] SCALAR_SOFTMAX_DATA_OUT,

    // SCALAR ONE_CONTROLPLUS
    // CONTROL
    output SCALAR_ONE_CONTROLPLUS_START,
    input SCALAR_ONE_CONTROLPLUS_READY,

    // DATA
    output [DATA_SIZE-1:0] SCALAR_ONE_CONTROLPLUS_MODULO_IN,
    output [DATA_SIZE-1:0] SCALAR_ONE_CONTROLPLUS_DATA_IN,
    input [DATA_SIZE-1:0] SCALAR_ONE_CONTROLPLUS_DATA_OUT,

    // SCALAR SUMMATION
    // CONTROL
    output SCALAR_SUMMATION_START,
    input SCALAR_SUMMATION_READY,

    output SCALAR_SUMMATION_DATA_IN_ENABLE,
    input SCALAR_SUMMATION_DATA_OUT_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] SCALAR_SUMMATION_MODULO_IN,
    output [DATA_SIZE-1:0] SCALAR_SUMMATION_LENGTH_IN,
    output [DATA_SIZE-1:0] SCALAR_SUMMATION_DATA_IN,
    input [DATA_SIZE-1:0] SCALAR_SUMMATION_DATA_OUT,

    ///////////////////////////////////////////////////////////////////////
    // STIMULUS VECTOR
    ///////////////////////////////////////////////////////////////////////

    // VECTOR CONVOLUTION
    // CONTROL
    output VECTOR_CONVOLUTION_START,
    input VECTOR_CONVOLUTION_READY,

    output VECTOR_CONVOLUTION_DATA_A_IN_VECTOR_ENABLE,
    output VECTOR_CONVOLUTION_DATA_A_IN_SCALAR_ENABLE,
    output VECTOR_CONVOLUTION_DATA_B_IN_VECTOR_ENABLE,
    output VECTOR_CONVOLUTION_DATA_B_IN_SCALAR_ENABLE,
    input VECTOR_CONVOLUTION_DATA_OUT_VECTOR_ENABLE,
    input VECTOR_CONVOLUTION_DATA_OUT_SCALAR_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] VECTOR_CONVOLUTION_MODULO_IN,
    output [DATA_SIZE-1:0] VECTOR_CONVOLUTION_SIZE_IN,
    output [DATA_SIZE-1:0] VECTOR_CONVOLUTION_LENGTH_IN,
    output [DATA_SIZE-1:0] VECTOR_CONVOLUTION_DATA_A_IN,
    output [DATA_SIZE-1:0] VECTOR_CONVOLUTION_DATA_B_IN,
    input [DATA_SIZE-1:0] VECTOR_CONVOLUTION_DATA_OUT,

    // VECTOR COSINE SIMILARITY
    // CONTROL
    output VECTOR_COSINE_SIMILARITY_START,
    input VECTOR_COSINE_SIMILARITY_READY,

    output VECTOR_COSINE_SIMILARITY_DATA_A_IN_VECTOR_ENABLE,
    output VECTOR_COSINE_SIMILARITY_DATA_A_IN_SCALAR_ENABLE,
    output VECTOR_COSINE_SIMILARITY_DATA_B_IN_VECTOR_ENABLE,
    output VECTOR_COSINE_SIMILARITY_DATA_B_IN_SCALAR_ENABLE,
    input VECTOR_COSINE_SIMILARITY_DATA_OUT_VECTOR_ENABLE,
    input VECTOR_COSINE_SIMILARITY_DATA_OUT_SCALAR_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] VECTOR_COSINE_SIMILARITY_MODULO_IN,
    output [DATA_SIZE-1:0] VECTOR_COSINE_SIMILARITY_SIZE_IN,
    output [DATA_SIZE-1:0] VECTOR_COSINE_SIMILARITY_LENGTH_IN,
    output [DATA_SIZE-1:0] VECTOR_COSINE_SIMILARITY_DATA_A_IN,
    output [DATA_SIZE-1:0] VECTOR_COSINE_SIMILARITY_DATA_B_IN,
    input [DATA_SIZE-1:0] VECTOR_COSINE_SIMILARITY_DATA_OUT,

    // VECTOR MULTIPLICATION
    // CONTROL
    output VECTOR_MULTIPLICATION_START,
    input VECTOR_MULTIPLICATION_READY,

    output VECTOR_MULTIPLICATION_DATA_IN_VECTOR_ENABLE,
    output VECTOR_MULTIPLICATION_DATA_IN_SCALAR_ENABLE,
    input VECTOR_MULTIPLICATION_DATA_OUT_VECTOR_ENABLE,
    input VECTOR_MULTIPLICATION_DATA_OUT_SCALAR_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] VECTOR_MULTIPLICATION_MODULO_IN,
    output [DATA_SIZE-1:0] VECTOR_MULTIPLICATION_SIZE_IN,
    output [DATA_SIZE-1:0] VECTOR_MULTIPLICATION_LENGTH_IN,
    output [DATA_SIZE-1:0] VECTOR_MULTIPLICATION_DATA_IN,
    input [DATA_SIZE-1:0] VECTOR_MULTIPLICATION_DATA_OUT,

    // VECTOR COSH
    // CONTROL
    output VECTOR_COSH_START,
    input VECTOR_COSH_READY,

    output VECTOR_COSH_DATA_IN_ENABLE,
    input VECTOR_COSH_DATA_OUT_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] VECTOR_COSH_MODULO_IN,
    output [DATA_SIZE-1:0] VECTOR_COSH_SIZE_IN,
    output [DATA_SIZE-1:0] VECTOR_COSH_DATA_IN,
    input [DATA_SIZE-1:0] VECTOR_COSH_DATA_OUT,

    // VECTOR SINH
    // CONTROL
    output VECTOR_SINH_START,
    input VECTOR_SINH_READY,

    output VECTOR_SINH_DATA_IN_ENABLE,
    input VECTOR_SINH_DATA_OUT_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] VECTOR_SINH_MODULO_IN,
    output [DATA_SIZE-1:0] VECTOR_SINH_SIZE_IN,
    output [DATA_SIZE-1:0] VECTOR_SINH_DATA_IN,
    input [DATA_SIZE-1:0] VECTOR_SINH_DATA_OUT,

    // VECTOR TANH
    // CONTROL
    output VECTOR_TANH_START,
    input VECTOR_TANH_READY,

    output VECTOR_TANH_DATA_IN_ENABLE,
    input VECTOR_TANH_DATA_OUT_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] VECTOR_TANH_MODULO_IN,
    output [DATA_SIZE-1:0] VECTOR_TANH_SIZE_IN,
    output [DATA_SIZE-1:0] VECTOR_TANH_DATA_IN,
    input [DATA_SIZE-1:0] VECTOR_TANH_DATA_OUT,

    // VECTOR LOGISTIC
    // CONTROL
    output VECTOR_LOGISTIC_START,
    input VECTOR_LOGISTIC_READY,

    output VECTOR_LOGISTIC_DATA_IN_ENABLE,
    input VECTOR_LOGISTIC_DATA_OUT_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] VECTOR_LOGISTIC_MODULO_IN,
    output [DATA_SIZE-1:0] VECTOR_LOGISTIC_SIZE_IN,
    output [DATA_SIZE-1:0] VECTOR_LOGISTIC_DATA_IN,
    input [DATA_SIZE-1:0] VECTOR_LOGISTIC_DATA_OUT,

    // VECTOR SOFTMAX
    // CONTROL
    output VECTOR_SOFTMAX_START,
    input VECTOR_SOFTMAX_READY,

    output VECTOR_SOFTMAX_DATA_IN_VECTOR_ENABLE,
    output VECTOR_SOFTMAX_DATA_IN_SCALAR_ENABLE,
    input VECTOR_SOFTMAX_DATA_OUT_VECTOR_ENABLE,
    input VECTOR_SOFTMAX_DATA_OUT_SCALAR_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] VECTOR_SOFTMAX_MODULO_IN,
    output [DATA_SIZE-1:0] VECTOR_SOFTMAX_SIZE_IN,
    output [DATA_SIZE-1:0] VECTOR_SOFTMAX_LENGTH_IN,
    output [DATA_SIZE-1:0] VECTOR_SOFTMAX_DATA_IN,
    input [DATA_SIZE-1:0] VECTOR_SOFTMAX_DATA_OUT,

    // VECTOR ONE_CONTROLPLUS
    // CONTROL
    output VECTOR_ONE_CONTROLPLUS_START,
    input VECTOR_ONE_CONTROLPLUS_READY,

    output VECTOR_ONE_CONTROLPLUS_DATA_IN_ENABLE,
    input VECTOR_ONE_CONTROLPLUS_DATA_OUT_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] VECTOR_ONE_CONTROLPLUS_MODULO_IN,
    output [DATA_SIZE-1:0] VECTOR_ONE_CONTROLPLUS_SIZE_IN,
    output [DATA_SIZE-1:0] VECTOR_ONE_CONTROLPLUS_DATA_IN,
    input [DATA_SIZE-1:0] VECTOR_ONE_CONTROLPLUS_DATA_OUT,

    // VECTOR SUMMATION
    // CONTROL
    output VECTOR_SUMMATION_START,
    input VECTOR_SUMMATION_READY,

    output VECTOR_SUMMATION_DATA_IN_VECTOR_ENABLE,
    output VECTOR_SUMMATION_DATA_IN_SCALAR_ENABLE,
    input VECTOR_SUMMATION_DATA_OUT_VECTOR_ENABLE,
    input VECTOR_SUMMATION_DATA_OUT_SCALAR_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] VECTOR_SUMMATION_MODULO_IN,
    output [DATA_SIZE-1:0] VECTOR_SUMMATION_SIZE_IN,
    output [DATA_SIZE-1:0] VECTOR_SUMMATION_LENGTH_IN,
    output [DATA_SIZE-1:0] VECTOR_SUMMATION_DATA_IN,
    input [DATA_SIZE-1:0] VECTOR_SUMMATION_DATA_OUT,
    ///////////////////////////////////////////////////////////////////////
    // STIMULUS MATRIX
    ///////////////////////////////////////////////////////////////////////

    // MATRIX CONVOLUTION
    // CONTROL
    output MATRIX_CONVOLUTION_START,
    input MATRIX_CONVOLUTION_READY,

    output MATRIX_CONVOLUTION_DATA_A_IN_MATRIX_ENABLE,
    output MATRIX_CONVOLUTION_DATA_A_IN_VECTOR_ENABLE,
    output MATRIX_CONVOLUTION_DATA_A_IN_SCALAR_ENABLE,
    output MATRIX_CONVOLUTION_DATA_B_IN_MATRIX_ENABLE,
    output MATRIX_CONVOLUTION_DATA_B_IN_VECTOR_ENABLE,
    output MATRIX_CONVOLUTION_DATA_B_IN_SCALAR_ENABLE,
    input MATRIX_CONVOLUTION_DATA_OUT_MATRIX_ENABLE,
    input MATRIX_CONVOLUTION_DATA_OUT_VECTOR_ENABLE,
    input MATRIX_CONVOLUTION_DATA_OUT_SCALAR_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] MATRIX_CONVOLUTION_MODULO_IN,
    output [DATA_SIZE-1:0] MATRIX_CONVOLUTION_SIZE_I_IN,
    output [DATA_SIZE-1:0] MATRIX_CONVOLUTION_SIZE_J_IN,
    output [DATA_SIZE-1:0] MATRIX_CONVOLUTION_LENGTH_IN,
    output [DATA_SIZE-1:0] MATRIX_CONVOLUTION_DATA_A_IN,
    output [DATA_SIZE-1:0] MATRIX_CONVOLUTION_DATA_B_IN,
    input [DATA_SIZE-1:0] MATRIX_CONVOLUTION_DATA_OUT,

    // MATRIX COSINE SIMILARITY
    // CONTROL
    output MATRIX_COSINE_SIMILARITY_START,
    input MATRIX_COSINE_SIMILARITY_READY,

    output MATRIX_COSINE_SIMILARITY_DATA_A_IN_MATRIX_ENABLE,
    output MATRIX_COSINE_SIMILARITY_DATA_A_IN_VECTOR_ENABLE,
    output MATRIX_COSINE_SIMILARITY_DATA_A_IN_SCALAR_ENABLE,
    output MATRIX_COSINE_SIMILARITY_DATA_B_IN_MATRIX_ENABLE,
    output MATRIX_COSINE_SIMILARITY_DATA_B_IN_VECTOR_ENABLE,
    output MATRIX_COSINE_SIMILARITY_DATA_B_IN_SCALAR_ENABLE,
    input MATRIX_COSINE_SIMILARITY_DATA_OUT_MATRIX_ENABLE,
    input MATRIX_COSINE_SIMILARITY_DATA_OUT_VECTOR_ENABLE,
    input MATRIX_COSINE_SIMILARITY_DATA_OUT_SCALAR_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] MATRIX_COSINE_SIMILARITY_MODULO_IN,
    output [DATA_SIZE-1:0] MATRIX_COSINE_SIMILARITY_SIZE_I_IN,
    output [DATA_SIZE-1:0] MATRIX_COSINE_SIMILARITY_SIZE_J_IN,
    output [DATA_SIZE-1:0] MATRIX_COSINE_SIMILARITY_LENGTH_IN,
    output [DATA_SIZE-1:0] MATRIX_COSINE_SIMILARITY_DATA_A_IN,
    output [DATA_SIZE-1:0] MATRIX_COSINE_SIMILARITY_DATA_B_IN,
    input [DATA_SIZE-1:0] MATRIX_COSINE_SIMILARITY_DATA_OUT,

    // MATRIX MULTIPLICATION
    // CONTROL
    output MATRIX_MULTIPLICATION_START,
    input MATRIX_MULTIPLICATION_READY,

    output MATRIX_MULTIPLICATION_DATA_IN_MATRIX_ENABLE,
    output MATRIX_MULTIPLICATION_DATA_IN_VECTOR_ENABLE,
    output MATRIX_MULTIPLICATION_DATA_IN_SCALAR_ENABLE,
    input MATRIX_MULTIPLICATION_DATA_OUT_MATRIX_ENABLE,
    input MATRIX_MULTIPLICATION_DATA_OUT_VECTOR_ENABLE,
    input MATRIX_MULTIPLICATION_DATA_OUT_SCALAR_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] MATRIX_MULTIPLICATION_MODULO_IN,
    output [DATA_SIZE-1:0] MATRIX_MULTIPLICATION_SIZE_I_IN,
    output [DATA_SIZE-1:0] MATRIX_MULTIPLICATION_SIZE_J_IN,
    output [DATA_SIZE-1:0] MATRIX_MULTIPLICATION_LENGTH_IN,
    output [DATA_SIZE-1:0] MATRIX_MULTIPLICATION_DATA_IN,
    input [DATA_SIZE-1:0] MATRIX_MULTIPLICATION_DATA_OUT,

    // MATRIX COSH
    // CONTROL
    output MATRIX_COSH_START,
    input MATRIX_COSH_READY,

    output MATRIX_COSH_DATA_IN_I_ENABLE,
    output MATRIX_COSH_DATA_IN_J_ENABLE,
    input MATRIX_COSH_DATA_OUT_I_ENABLE,
    input MATRIX_COSH_DATA_OUT_J_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] MATRIX_COSH_MODULO_IN,
    output [DATA_SIZE-1:0] MATRIX_COSH_SIZE_I_IN,
    output [DATA_SIZE-1:0] MATRIX_COSH_SIZE_J_IN,
    output [DATA_SIZE-1:0] MATRIX_COSH_DATA_IN,
    input [DATA_SIZE-1:0] MATRIX_COSH_DATA_OUT,

    // MATRIX SINH
    // CONTROL
    output MATRIX_SINH_START,
    input MATRIX_SINH_READY,

    output MATRIX_SINH_DATA_IN_I_ENABLE,
    output MATRIX_SINH_DATA_IN_J_ENABLE,
    input MATRIX_SINH_DATA_OUT_I_ENABLE,
    input MATRIX_SINH_DATA_OUT_J_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] MATRIX_SINH_MODULO_IN,
    output [DATA_SIZE-1:0] MATRIX_SINH_SIZE_I_IN,
    output [DATA_SIZE-1:0] MATRIX_SINH_SIZE_J_IN,
    output [DATA_SIZE-1:0] MATRIX_SINH_DATA_IN,
    input [DATA_SIZE-1:0] MATRIX_SINH_DATA_OUT,

    // MATRIX TANH
    // CONTROL
    output MATRIX_TANH_START,
    input MATRIX_TANH_READY,

    output MATRIX_TANH_DATA_IN_I_ENABLE,
    output MATRIX_TANH_DATA_IN_J_ENABLE,
    input MATRIX_TANH_DATA_OUT_I_ENABLE,
    input MATRIX_TANH_DATA_OUT_J_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] MATRIX_TANH_MODULO_IN,
    output [DATA_SIZE-1:0] MATRIX_TANH_SIZE_I_IN,
    output [DATA_SIZE-1:0] MATRIX_TANH_SIZE_J_IN,
    output [DATA_SIZE-1:0] MATRIX_TANH_DATA_IN,
    input [DATA_SIZE-1:0] MATRIX_TANH_DATA_OUT,

    // MATRIX LOGISTIC
    // CONTROL
    output MATRIX_LOGISTIC_START,
    input MATRIX_LOGISTIC_READY,

    output MATRIX_LOGISTIC_DATA_IN_I_ENABLE,
    output MATRIX_LOGISTIC_DATA_IN_J_ENABLE,
    input MATRIX_LOGISTIC_DATA_OUT_I_ENABLE,
    input MATRIX_LOGISTIC_DATA_OUT_J_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] MATRIX_LOGISTIC_MODULO_IN,
    output [DATA_SIZE-1:0] MATRIX_LOGISTIC_SIZE_I_IN,
    output [DATA_SIZE-1:0] MATRIX_LOGISTIC_SIZE_J_IN,
    output [DATA_SIZE-1:0] MATRIX_LOGISTIC_DATA_IN,
    input [DATA_SIZE-1:0] MATRIX_LOGISTIC_DATA_OUT,

    // MATRIX SOFTMAX
    // CONTROL
    output MATRIX_SOFTMAX_START,
    input MATRIX_SOFTMAX_READY,

    output MATRIX_SOFTMAX_DATA_IN_MATRIX_ENABLE,
    output MATRIX_SOFTMAX_DATA_IN_VECTOR_ENABLE,
    output MATRIX_SOFTMAX_DATA_IN_SCALAR_ENABLE,
    input MATRIX_SOFTMAX_DATA_OUT_MATRIX_ENABLE,
    input MATRIX_SOFTMAX_DATA_OUT_VECTOR_ENABLE,
    input MATRIX_SOFTMAX_DATA_OUT_SCALAR_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] MATRIX_SOFTMAX_MODULO_IN,
    output [DATA_SIZE-1:0] MATRIX_SOFTMAX_SIZE_I_IN,
    output [DATA_SIZE-1:0] MATRIX_SOFTMAX_SIZE_J_IN,
    output [DATA_SIZE-1:0] MATRIX_SOFTMAX_LENGTH_IN,
    output [DATA_SIZE-1:0] MATRIX_SOFTMAX_DATA_IN,
    input [DATA_SIZE-1:0] MATRIX_SOFTMAX_DATA_OUT,

    // MATRIX ONE_CONTROLPLUS
    // CONTROL
    output MATRIX_ONE_CONTROLPLUS_START,
    input MATRIX_ONE_CONTROLPLUS_READY,

    output MATRIX_ONE_CONTROLPLUS_DATA_IN_I_ENABLE,
    output MATRIX_ONE_CONTROLPLUS_DATA_IN_J_ENABLE,
    input MATRIX_ONE_CONTROLPLUS_DATA_OUT_I_ENABLE,
    input MATRIX_ONE_CONTROLPLUS_DATA_OUT_J_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] MATRIX_ONE_CONTROLPLUS_MODULO_IN,
    output [DATA_SIZE-1:0] MATRIX_ONE_CONTROLPLUS_SIZE_I_IN,
    output [DATA_SIZE-1:0] MATRIX_ONE_CONTROLPLUS_SIZE_J_IN,
    output [DATA_SIZE-1:0] MATRIX_ONE_CONTROLPLUS_DATA_IN,
    input [DATA_SIZE-1:0] MATRIX_ONE_CONTROLPLUS_DATA_OUT,

    // MATRIX SUMMATION
    // CONTROL
    output MATRIX_SUMMATION_START,
    input MATRIX_SUMMATION_READY,

    output MATRIX_SUMMATION_DATA_IN_MATRIX_ENABLE,
    output MATRIX_SUMMATION_DATA_IN_VECTOR_ENABLE,
    output MATRIX_SUMMATION_DATA_IN_SCALAR_ENABLE,
    input MATRIX_SUMMATION_DATA_OUT_MATRIX_ENABLE,
    input MATRIX_SUMMATION_DATA_OUT_VECTOR_ENABLE,
    input MATRIX_SUMMATION_DATA_OUT_SCALAR_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] MATRIX_SUMMATION_MODULO_IN,
    output [DATA_SIZE-1:0] MATRIX_SUMMATION_SIZE_I_IN,
    output [DATA_SIZE-1:0] MATRIX_SUMMATION_SIZE_J_IN,
    output [DATA_SIZE-1:0] MATRIX_SUMMATION_LENGTH_IN,
    output [DATA_SIZE-1:0] MATRIX_SUMMATION_DATA_IN,
    input [DATA_SIZE-1:0] MATRIX_SUMMATION_DATA_OUT
  );

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

endmodule