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

module ntm_function_testbench;

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////
  // GLOBAL
  wire CLK;
  wire RST;

  ///////////////////////////////////////////////////////////////////////
  // SCALAR
  ///////////////////////////////////////////////////////////////////////

  // SCALAR CONVOLUTION
  // CONTROL
  wire start_scalar_convolution;
  wire ready_scalar_convolution;

  wire data_in_enable_scalar_convolution;
  wire data_out_enable_scalar_convolution;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_convolution;
  wire [DATA_SIZE-1:0] length_in_scalar_convolution;
  wire [DATA_SIZE-1:0] data_a_in_scalar_convolution;
  wire [DATA_SIZE-1:0] data_b_in_scalar_convolution;
  wire [DATA_SIZE-1:0] data_out_scalar_convolution;

  // SCALAR COSINE SIMILARITY
  // CONTROL
  wire start_scalar_cosine;
  wire ready_scalar_cosine;

  wire data_in_enable_scalar_cosine;
  wire data_out_enable_scalar_cosine;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_cosine;
  wire [DATA_SIZE-1:0] length_in_scalar_cosine;
  wire [DATA_SIZE-1:0] data_a_in_scalar_cosine;
  wire [DATA_SIZE-1:0] data_b_in_scalar_cosine;
  wire [DATA_SIZE-1:0] data_out_scalar_cosine;

  // SCALAR DIFFERENTIATION
  // CONTROL
  wire start_scalar_differentiation;
  wire ready_scalar_differentiation;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_differentiation;
  wire [DATA_SIZE-1:0] data_in_scalar_differentiation;
  wire [DATA_SIZE-1:0] data_out_scalar_differentiation;

  // SCALAR MULTIPLICATION
  // CONTROL
  wire start_scalar_multiplication;
  wire ready_scalar_multiplication;

  wire data_in_enable_scalar_multiplication;
  wire data_out_enable_scalar_multiplication;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_multiplication;
  wire [DATA_SIZE-1:0] length_in_scalar_multiplication;
  wire [DATA_SIZE-1:0] data_in_scalar_multiplication;
  wire [DATA_SIZE-1:0] data_out_scalar_multiplication;

  // SCALAR COSH
  // CONTROL
  wire start_scalar_cosh;
  wire ready_scalar_cosh;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_cosh;
  wire [DATA_SIZE-1:0] data_in_scalar_cosh;
  wire [DATA_SIZE-1:0] data_out_scalar_cosh;

  // SCALAR SINH
  // CONTROL
  wire start_scalar_sinh;
  wire ready_scalar_sinh;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_sinh;
  wire [DATA_SIZE-1:0] data_in_scalar_sinh;
  wire [DATA_SIZE-1:0] data_out_scalar_sinh;

  // SCALAR TANH
  // CONTROL
  wire start_scalar_tanh;
  wire ready_scalar_tanh;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_tanh;
  wire [DATA_SIZE-1:0] data_in_scalar_tanh;
  wire [DATA_SIZE-1:0] data_out_scalar_tanh;

  // SCALAR LOGISTIC
  // CONTROL
  wire start_scalar_logistic;
  wire ready_scalar_logistic;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_logistic;
  wire [DATA_SIZE-1:0] data_in_scalar_logistic;
  wire data_out_scalar_logistic;

  // SCALAR SOFTMAX
  // CONTROL
  wire start_scalar_softmax;
  wire ready_scalar_softmax;

  wire data_in_enable_scalar_softmax;
  wire data_out_enable_scalar_softmax;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_softmax;
  wire [DATA_SIZE-1:0] length_in_scalar_softmax;
  wire [DATA_SIZE-1:0] data_in_scalar_softmax;
  wire [DATA_SIZE-1:0] data_out_scalar_softmax;

  // SCALAR ONEPLUS
  // CONTROL
  wire start_scalar_oneplus;
  wire ready_scalar_oneplus;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_oneplus;
  wire [DATA_SIZE-1:0] data_in_scalar_oneplus;
  wire [DATA_SIZE-1:0] data_out_scalar_oneplus;

  // SCALAR SUMMATION
  // CONTROL
  wire start_scalar_summation;
  wire ready_scalar_summation;

  wire data_in_enable_scalar_summation;
  wire data_out_enable_scalar_summation;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_summation;
  wire [DATA_SIZE-1:0] length_in_scalar_summation;
  wire [DATA_SIZE-1:0] data_in_scalar_summation;
  wire [DATA_SIZE-1:0] data_out_scalar_summation;

  ///////////////////////////////////////////////////////////////////////
  // VECTOR
  ///////////////////////////////////////////////////////////////////////

  // VECTOR CONVOLUTION
  // CONTROL
  wire start_vector_convolution;
  wire ready_vector_convolution;

  wire data_a_in_vector_enable_vector_convolution;
  wire data_a_in_scalar_enable_vector_convolution;
  wire data_b_in_vector_enable_vector_convolution;
  wire data_b_in_scalar_enable_vector_convolution;
  wire data_out_vector_enable_vector_convolution;
  wire data_out_scalar_enable_vector_convolution;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_convolution;
  wire [DATA_SIZE-1:0] size_in_vector_convolution;
  wire [DATA_SIZE-1:0] length_in_vector_convolution;
  wire [DATA_SIZE-1:0] data_a_in_vector_convolution;
  wire [DATA_SIZE-1:0] data_b_in_vector_convolution;
  wire [DATA_SIZE-1:0] data_out_vector_convolution;

  // VECTOR COSINE SIMILARITY
  // CONTROL
  wire start_vector_cosine;
  wire ready_vector_cosine;

  wire data_a_in_vector_enable_vector_cosine;
  wire data_a_in_scalar_enable_vector_cosine;
  wire data_b_in_vector_enable_vector_cosine;
  wire data_b_in_scalar_enable_vector_cosine;
  wire data_out_vector_enable_vector_cosine;
  wire data_out_scalar_enable_vector_cosine;

  // VECTOR DIFFERENTIATION
  // CONTROL
  wire start_vector_differentiation;
  wire ready_vector_differentiation;

  wire data_in_enable_vector_differentiation;
  wire data_out_enable_vector_differentiation;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_differentiation;
  wire [DATA_SIZE-1:0] size_in_vector_differentiation;
  wire [DATA_SIZE-1:0] data_in_vector_differentiation;
  wire [DATA_SIZE-1:0] data_out_vector_differentiation;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_cosine;
  wire [DATA_SIZE-1:0] size_in_vector_cosine;
  wire [DATA_SIZE-1:0] length_in_vector_cosine;
  wire [DATA_SIZE-1:0] data_a_in_vector_cosine;
  wire [DATA_SIZE-1:0] data_b_in_vector_cosine;
  wire [DATA_SIZE-1:0] data_out_vector_cosine;

  // VECTOR MULTIPLICATION
  // CONTROL
  wire start_vector_multiplication;
  wire ready_vector_multiplication;

  wire data_in_vector_enable_vector_multiplication;
  wire data_in_scalar_enable_vector_multiplication;
  wire data_out_vector_enable_vector_multiplication;
  wire data_out_scalar_enable_vector_multiplication;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_multiplication;
  wire [DATA_SIZE-1:0] length_in_vector_multiplication;
  wire [DATA_SIZE-1:0] size_in_vector_multiplication;
  wire [DATA_SIZE-1:0] data_in_vector_multiplication;
  wire [DATA_SIZE-1:0] data_out_vector_multiplication;

  // VECTOR COSH
  // CONTROL
  wire start_vector_cosh;
  wire ready_vector_cosh;

  wire data_in_enable_vector_cosh;
  wire data_out_enable_vector_cosh;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_cosh;
  wire [DATA_SIZE-1:0] size_in_vector_cosh;
  wire [DATA_SIZE-1:0] data_in_vector_cosh;
  wire [DATA_SIZE-1:0] data_out_vector_cosh;

  // VECTOR SINH
  // CONTROL
  wire start_vector_sinh;
  wire ready_vector_sinh;

  wire data_in_enable_vector_sinh;
  wire data_out_enable_vector_sinh;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_sinh;
  wire [DATA_SIZE-1:0] size_in_vector_sinh;
  wire [DATA_SIZE-1:0] data_in_vector_sinh;
  wire [DATA_SIZE-1:0] data_out_vector_sinh;

  // VECTOR TANH
  // CONTROL
  wire start_vector_tanh;
  wire ready_vector_tanh;

  wire data_in_enable_vector_tanh;
  wire data_out_enable_vector_tanh;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_tanh;
  wire [DATA_SIZE-1:0] size_in_vector_tanh;
  wire [DATA_SIZE-1:0] data_in_vector_tanh;
  wire [DATA_SIZE-1:0] data_out_vector_tanh;

  // VECTOR LOGISTIC
  // CONTROL
  wire start_vector_logistic;
  wire ready_vector_logistic;

  wire data_in_enable_vector_logistic;
  wire data_out_enable_vector_logistic;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_logistic;
  wire [DATA_SIZE-1:0] size_in_vector_logistic;
  wire [DATA_SIZE-1:0] data_in_vector_logistic;
  wire data_out_vector_logistic;

  // VECTOR SOFTMAX
  // CONTROL
  wire start_vector_softmax;
  wire ready_vector_softmax;

  wire data_in_vector_enable_vector_softmax;
  wire data_in_scalar_enable_vector_softmax;
  wire data_out_vector_enable_vector_softmax;
  wire data_out_scalar_enable_vector_softmax;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_softmax;
  wire [DATA_SIZE-1:0] length_in_vector_softmax;
  wire [DATA_SIZE-1:0] size_in_vector_softmax;
  wire [DATA_SIZE-1:0] data_in_vector_softmax;
  wire [DATA_SIZE-1:0] data_out_vector_softmax;

  // VECTOR ONEPLUS
  // CONTROL
  wire start_vector_oneplus;
  wire ready_vector_oneplus;

  wire data_in_enable_vector_oneplus;
  wire data_out_enable_vector_oneplus;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_oneplus;
  wire [DATA_SIZE-1:0] size_in_vector_oneplus;
  wire [DATA_SIZE-1:0] data_in_vector_oneplus;
  wire [DATA_SIZE-1:0] data_out_vector_oneplus;

  // VECTOR SUMMATION
  // CONTROL
  wire start_vector_summation;
  wire ready_vector_summation;

  wire data_in_vector_enable_vector_summation;
  wire data_in_scalar_enable_vector_summation;
  wire data_out_vector_enable_vector_summation;
  wire data_out_scalar_enable_vector_summation;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_summation;
  wire [DATA_SIZE-1:0] size_in_vector_summation;
  wire [DATA_SIZE-1:0] length_in_vector_summation;
  wire [DATA_SIZE-1:0] data_in_vector_summation;
  wire [DATA_SIZE-1:0] data_out_vector_summation;

  ///////////////////////////////////////////////////////////////////////
  // MATRIX
  ///////////////////////////////////////////////////////////////////////

  // MATRIX CONVOLUTION
  // CONTROL
  wire start_matrix_convolution;
  wire ready_matrix_convolution;

  wire data_a_in_matrix_enable_matrix_convolution;
  wire data_a_in_vector_enable_matrix_convolution;
  wire data_a_in_scalar_enable_matrix_convolution;
  wire data_b_in_matrix_enable_matrix_convolution;
  wire data_b_in_vector_enable_matrix_convolution;
  wire data_b_in_scalar_enable_matrix_convolution;
  wire data_out_matrix_enable_matrix_convolution;
  wire data_out_vector_enable_matrix_convolution;
  wire data_out_scalar_enable_matrix_convolution;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_convolution;
  wire [DATA_SIZE-1:0] size_i_in_matrix_convolution;
  wire [DATA_SIZE-1:0] size_j_in_matrix_convolution;
  wire [DATA_SIZE-1:0] length_in_matrix_convolution;
  wire [DATA_SIZE-1:0] data_a_in_matrix_convolution;
  wire [DATA_SIZE-1:0] data_b_in_matrix_convolution;
  wire [DATA_SIZE-1:0] data_out_matrix_convolution;

  // MATRIX COSINE SIMILARITY
  // CONTROL
  wire start_matrix_cosine;
  wire ready_matrix_cosine;

  wire data_a_in_matrix_enable_matrix_cosine;
  wire data_a_in_vector_enable_matrix_cosine;
  wire data_a_in_scalar_enable_matrix_cosine;
  wire data_b_in_matrix_enable_matrix_cosine;
  wire data_b_in_vector_enable_matrix_cosine;
  wire data_b_in_scalar_enable_matrix_cosine;
  wire data_out_matrix_enable_matrix_cosine;
  wire data_out_vector_enable_matrix_cosine;
  wire data_out_scalar_enable_matrix_cosine;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_cosine;
  wire [DATA_SIZE-1:0] size_i_in_matrix_cosine;
  wire [DATA_SIZE-1:0] size_j_in_matrix_cosine;
  wire [DATA_SIZE-1:0] length_in_matrix_cosine;
  wire [DATA_SIZE-1:0] data_a_in_matrix_cosine;
  wire [DATA_SIZE-1:0] data_b_in_matrix_cosine;
  wire [DATA_SIZE-1:0] data_out_matrix_cosine;

  // MATRIX DIFFERENTIATION
  // CONTROL
  wire start_matrix_differentiation;
  wire ready_matrix_differentiation;

  wire data_in_i_enable_matrix_differentiation;
  wire data_in_j_enable_matrix_differentiation;
  wire data_out_i_enable_matrix_differentiation;
  wire data_out_j_enable_matrix_differentiation;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_differentiation;
  wire [DATA_SIZE-1:0] size_i_in_matrix_differentiation;
  wire [DATA_SIZE-1:0] size_j_in_matrix_differentiation;
  wire [DATA_SIZE-1:0] data_in_matrix_differentiation;
  wire [DATA_SIZE-1:0] data_out_matrix_differentiation;

  // MATRIX MULTIPLICATION
  // CONTROL
  wire start_matrix_multiplication;
  wire ready_matrix_multiplication;

  wire data_in_matrix_enable_matrix_multiplication;
  wire data_in_vector_enable_matrix_multiplication;
  wire data_in_scalar_enable_matrix_multiplication;
  wire data_out_matrix_enable_matrix_multiplication;
  wire data_out_vector_enable_matrix_multiplication;
  wire data_out_scalar_enable_matrix_multiplication;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_multiplication;
  wire [DATA_SIZE-1:0] size_i_in_matrix_multiplication;
  wire [DATA_SIZE-1:0] size_j_in_matrix_multiplication;
  wire [DATA_SIZE-1:0] length_in_matrix_multiplication;
  wire [DATA_SIZE-1:0] data_in_matrix_multiplication;
  wire [DATA_SIZE-1:0] data_out_matrix_multiplication;

  // MATRIX COSH
  // CONTROL
  wire start_matrix_cosh;
  wire ready_matrix_cosh;

  wire data_in_i_enable_matrix_cosh;
  wire data_in_j_enable_matrix_cosh;
  wire data_out_i_enable_matrix_cosh;
  wire data_out_j_enable_matrix_cosh;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_cosh;
  wire [DATA_SIZE-1:0] size_i_in_matrix_cosh;
  wire [DATA_SIZE-1:0] size_j_in_matrix_cosh;
  wire [DATA_SIZE-1:0] data_in_matrix_cosh;
  wire [DATA_SIZE-1:0] data_out_matrix_cosh;

  // MATRIX SINH
  // CONTROL
  wire start_matrix_sinh;
  wire ready_matrix_sinh;

  wire data_in_i_enable_matrix_sinh;
  wire data_in_j_enable_matrix_sinh;
  wire data_out_i_enable_matrix_sinh;
  wire data_out_j_enable_matrix_sinh;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_sinh;
  wire [DATA_SIZE-1:0] size_i_in_matrix_sinh;
  wire [DATA_SIZE-1:0] size_j_in_matrix_sinh;
  wire [DATA_SIZE-1:0] data_in_matrix_sinh;
  wire [DATA_SIZE-1:0] data_out_matrix_sinh;

  // MATRIX TANH
  // CONTROL
  wire start_matrix_tanh;
  wire ready_matrix_tanh;

  wire data_in_i_enable_matrix_tanh;
  wire data_in_j_enable_matrix_tanh;
  wire data_out_i_enable_matrix_tanh;
  wire data_out_j_enable_matrix_tanh;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_tanh;
  wire [DATA_SIZE-1:0] size_i_in_matrix_tanh;
  wire [DATA_SIZE-1:0] size_j_in_matrix_tanh;
  wire [DATA_SIZE-1:0] data_in_matrix_tanh;
  wire [DATA_SIZE-1:0] data_out_matrix_tanh;

  // MATRIX LOGISTIC
  // CONTROL
  wire start_matrix_logistic;
  wire ready_matrix_logistic;

  wire data_in_i_enable_matrix_logistic;
  wire data_in_j_enable_matrix_logistic;
  wire data_out_i_enable_matrix_logistic;
  wire data_out_j_enable_matrix_logistic;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_logistic;
  wire [DATA_SIZE-1:0] size_i_in_matrix_logistic;
  wire [DATA_SIZE-1:0] size_j_in_matrix_logistic;
  wire [DATA_SIZE-1:0] data_in_matrix_logistic;
  wire data_out_matrix_logistic;

  // MATRIX SOFTMAX
  // CONTROL
  wire start_matrix_softmax;
  wire ready_matrix_softmax;

  wire data_in_matrix_enable_matrix_softmax;
  wire data_in_vector_enable_matrix_softmax;
  wire data_in_scalar_enable_matrix_softmax;
  wire data_out_matrix_enable_matrix_softmax;
  wire data_out_vector_enable_matrix_softmax;
  wire data_out_scalar_enable_matrix_softmax;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_softmax;
  wire [DATA_SIZE-1:0] size_i_in_matrix_softmax;
  wire [DATA_SIZE-1:0] size_j_in_matrix_softmax;
  wire [DATA_SIZE-1:0] length_in_matrix_softmax;
  wire [DATA_SIZE-1:0] data_in_matrix_softmax;
  wire [DATA_SIZE-1:0] data_out_matrix_softmax;

  // MATRIX ONEPLUS
  // CONTROL
  wire start_matrix_oneplus;
  wire ready_matrix_oneplus;

  wire data_in_i_enable_matrix_oneplus;
  wire data_in_j_enable_matrix_oneplus;
  wire data_out_i_enable_matrix_oneplus;
  wire data_out_j_enable_matrix_oneplus;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_oneplus;
  wire [DATA_SIZE-1:0] size_i_in_matrix_oneplus;
  wire [DATA_SIZE-1:0] size_j_in_matrix_oneplus;
  wire [DATA_SIZE-1:0] data_in_matrix_oneplus;
  wire [DATA_SIZE-1:0] data_out_matrix_oneplus;

  // MATRIX SUMMATION
  // CONTROL
  wire start_matrix_summation;
  wire ready_matrix_summation;

  wire data_in_matrix_enable_matrix_summation;
  wire data_in_vector_enable_matrix_summation;
  wire data_in_scalar_enable_matrix_summation;
  wire data_out_matrix_enable_matrix_summation;
  wire data_out_vector_enable_matrix_summation;
  wire data_out_scalar_enable_matrix_summation;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_summation;
  wire [DATA_SIZE-1:0] size_i_in_matrix_summation;
  wire [DATA_SIZE-1:0] size_j_in_matrix_summation;
  wire [DATA_SIZE-1:0] length_in_matrix_summation;
  wire [DATA_SIZE-1:0] data_in_matrix_summation;
  wire [DATA_SIZE-1:0] data_out_matrix_summation;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////
  ntm_function_stimulus #(
    // SYSTEM-SIZE
    .DATA_SIZE(DATA_SIZE),

    .X(X),
    .Y(Y),
    .N(N),
    .W(W),
    .L(L),
    .R(R),

    // SCALAR-FUNCTIONALITY
    .STIMULUS_NTM_SCALAR_CONVOLUTION_TEST(STIMULUS_NTM_SCALAR_CONVOLUTION_TEST),
    .STIMULUS_NTM_SCALAR_COSINE_SIMILARITY_TEST(STIMULUS_NTM_SCALAR_COSINE_SIMILARITY_TEST),
    .STIMULUS_NTM_SCALAR_COSH_TEST(STIMULUS_NTM_SCALAR_COSH_TEST),
    .STIMULUS_NTM_SCALAR_SINH_TEST(STIMULUS_NTM_SCALAR_SINH_TEST),
    .STIMULUS_NTM_SCALAR_TANH_TEST(STIMULUS_NTM_SCALAR_TANH_TEST),
    .STIMULUS_NTM_SCALAR_LOGISTIC_TEST(STIMULUS_NTM_SCALAR_LOGISTIC_TEST),
    .STIMULUS_NTM_SCALAR_SOFTMAX_TEST(STIMULUS_NTM_SCALAR_SOFTMAX_TEST),
    .STIMULUS_NTM_SCALAR_ONEPLUS_TEST(STIMULUS_NTM_SCALAR_ONEPLUS_TEST),
    .STIMULUS_NTM_SCALAR_SUMMATION_TEST(STIMULUS_NTM_SCALAR_SUMMATION_TEST),
    .STIMULUS_NTM_SCALAR_CONVOLUTION_CASE_0(STIMULUS_NTM_SCALAR_CONVOLUTION_CASE_0),
    .STIMULUS_NTM_SCALAR_COSINE_SIMILARITY_CASE_0(STIMULUS_NTM_SCALAR_COSINE_SIMILARITY_CASE_0),
    .STIMULUS_NTM_SCALAR_COSH_CASE_0(STIMULUS_NTM_SCALAR_COSH_CASE_0),
    .STIMULUS_NTM_SCALAR_SINH_CASE_0(STIMULUS_NTM_SCALAR_SINH_CASE_0),
    .STIMULUS_NTM_SCALAR_TANH_CASE_0(STIMULUS_NTM_SCALAR_TANH_CASE_0),
    .STIMULUS_NTM_SCALAR_LOGISTIC_CASE_0(STIMULUS_NTM_SCALAR_LOGISTIC_CASE_0),
    .STIMULUS_NTM_SCALAR_SOFTMAX_CASE_0(STIMULUS_NTM_SCALAR_SOFTMAX_CASE_0),
    .STIMULUS_NTM_SCALAR_ONEPLUS_CASE_0(STIMULUS_NTM_SCALAR_ONEPLUS_CASE_0),
    .STIMULUS_NTM_SCALAR_SUMMATION_CASE_0(STIMULUS_NTM_SCALAR_SUMMATION_CASE_0),
    .STIMULUS_NTM_SCALAR_CONVOLUTION_CASE_1(STIMULUS_NTM_SCALAR_CONVOLUTION_CASE_1),
    .STIMULUS_NTM_SCALAR_COSINE_SIMILARITY_CASE_1(STIMULUS_NTM_SCALAR_COSINE_SIMILARITY_CASE_1),
    .STIMULUS_NTM_SCALAR_COSH_CASE_1(STIMULUS_NTM_SCALAR_COSH_CASE_1),
    .STIMULUS_NTM_SCALAR_SINH_CASE_1(STIMULUS_NTM_SCALAR_SINH_CASE_1),
    .STIMULUS_NTM_SCALAR_TANH_CASE_1(STIMULUS_NTM_SCALAR_TANH_CASE_1),
    .STIMULUS_NTM_SCALAR_LOGISTIC_CASE_1(STIMULUS_NTM_SCALAR_LOGISTIC_CASE_1),
    .STIMULUS_NTM_SCALAR_SOFTMAX_CASE_1(STIMULUS_NTM_SCALAR_SOFTMAX_CASE_1),
    .STIMULUS_NTM_SCALAR_ONEPLUS_CASE_1(STIMULUS_NTM_SCALAR_ONEPLUS_CASE_1),
    .STIMULUS_NTM_SCALAR_SUMMATION_CASE_1(STIMULUS_NTM_SCALAR_SUMMATION_CASE_1),

    // VECTOR-FUNCTIONALITY
    .STIMULUS_NTM_VECTOR_CONVOLUTION_TEST(STIMULUS_NTM_VECTOR_CONVOLUTION_TEST),
    .STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_TEST(STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_TEST),
    .STIMULUS_NTM_VECTOR_COSH_TEST(STIMULUS_NTM_VECTOR_COSH_TEST),
    .STIMULUS_NTM_VECTOR_SINH_TEST(STIMULUS_NTM_VECTOR_SINH_TEST),
    .STIMULUS_NTM_VECTOR_TANH_TEST(STIMULUS_NTM_VECTOR_TANH_TEST),
    .STIMULUS_NTM_VECTOR_LOGISTIC_TEST(STIMULUS_NTM_VECTOR_LOGISTIC_TEST),
    .STIMULUS_NTM_VECTOR_SOFTMAX_TEST(STIMULUS_NTM_VECTOR_SOFTMAX_TEST),
    .STIMULUS_NTM_VECTOR_ONEPLUS_TEST(STIMULUS_NTM_VECTOR_ONEPLUS_TEST),
    .STIMULUS_NTM_VECTOR_SUMMATION_TEST(STIMULUS_NTM_VECTOR_SUMMATION_TEST),
    .STIMULUS_NTM_VECTOR_CONVOLUTION_CASE_0(STIMULUS_NTM_VECTOR_CONVOLUTION_CASE_0),
    .STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_CASE_0(STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_CASE_0),
    .STIMULUS_NTM_VECTOR_COSH_CASE_0(STIMULUS_NTM_VECTOR_COSH_CASE_0),
    .STIMULUS_NTM_VECTOR_SINH_CASE_0(STIMULUS_NTM_VECTOR_SINH_CASE_0),
    .STIMULUS_NTM_VECTOR_TANH_CASE_0(STIMULUS_NTM_VECTOR_TANH_CASE_0),
    .STIMULUS_NTM_VECTOR_LOGISTIC_CASE_0(STIMULUS_NTM_VECTOR_LOGISTIC_CASE_0),
    .STIMULUS_NTM_VECTOR_SOFTMAX_CASE_0(STIMULUS_NTM_VECTOR_SOFTMAX_CASE_0),
    .STIMULUS_NTM_VECTOR_ONEPLUS_CASE_0(STIMULUS_NTM_VECTOR_ONEPLUS_CASE_0),
    .STIMULUS_NTM_VECTOR_SUMMATION_CASE_0(STIMULUS_NTM_VECTOR_SUMMATION_CASE_0),
    .STIMULUS_NTM_VECTOR_CONVOLUTION_CASE_1(STIMULUS_NTM_VECTOR_CONVOLUTION_CASE_1),
    .STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_CASE_1(STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_CASE_1),
    .STIMULUS_NTM_VECTOR_COSH_CASE_1(STIMULUS_NTM_VECTOR_COSH_CASE_1),
    .STIMULUS_NTM_VECTOR_SINH_CASE_1(STIMULUS_NTM_VECTOR_SINH_CASE_1),
    .STIMULUS_NTM_VECTOR_TANH_CASE_1(STIMULUS_NTM_VECTOR_TANH_CASE_1),
    .STIMULUS_NTM_VECTOR_LOGISTIC_CASE_1(STIMULUS_NTM_VECTOR_LOGISTIC_CASE_1),
    .STIMULUS_NTM_VECTOR_SOFTMAX_CASE_1(STIMULUS_NTM_VECTOR_SOFTMAX_CASE_1),
    .STIMULUS_NTM_VECTOR_ONEPLUS_CASE_1(STIMULUS_NTM_VECTOR_ONEPLUS_CASE_1),
    .STIMULUS_NTM_VECTOR_SUMMATION_CASE_1(STIMULUS_NTM_VECTOR_SUMMATION_CASE_1),

    // MATRIX-FUNCTIONALITY
    .STIMULUS_NTM_MATRIX_CONVOLUTION_TEST(STIMULUS_NTM_MATRIX_CONVOLUTION_TEST),
    .STIMULUS_NTM_MATRIX_COSINE_SIMILARITY_TEST(STIMULUS_NTM_MATRIX_COSINE_SIMILARITY_TEST),
    .STIMULUS_NTM_MATRIX_COSH_TEST(STIMULUS_NTM_MATRIX_COSH_TEST),
    .STIMULUS_NTM_MATRIX_SINH_TEST(STIMULUS_NTM_MATRIX_SINH_TEST),
    .STIMULUS_NTM_MATRIX_TANH_TEST(STIMULUS_NTM_MATRIX_TANH_TEST),
    .STIMULUS_NTM_MATRIX_LOGISTIC_TEST(STIMULUS_NTM_MATRIX_LOGISTIC_TEST),
    .STIMULUS_NTM_MATRIX_SOFTMAX_TEST(STIMULUS_NTM_MATRIX_SOFTMAX_TEST),
    .STIMULUS_NTM_MATRIX_ONEPLUS_TEST(STIMULUS_NTM_MATRIX_ONEPLUS_TEST),
    .STIMULUS_NTM_MATRIX_SUMMATION_TEST(STIMULUS_NTM_MATRIX_SUMMATION_TEST),
    .STIMULUS_NTM_MATRIX_CONVOLUTION_CASE_0(STIMULUS_NTM_MATRIX_CONVOLUTION_CASE_0),
    .STIMULUS_NTM_MATRIX_COSINE_SIMILARITY_CASE_0(STIMULUS_NTM_MATRIX_COSINE_SIMILARITY_CASE_0),
    .STIMULUS_NTM_MATRIX_COSH_CASE_0(STIMULUS_NTM_MATRIX_COSH_CASE_0),
    .STIMULUS_NTM_MATRIX_SINH_CASE_0(STIMULUS_NTM_MATRIX_SINH_CASE_0),
    .STIMULUS_NTM_MATRIX_TANH_CASE_0(STIMULUS_NTM_MATRIX_TANH_CASE_0),
    .STIMULUS_NTM_MATRIX_LOGISTIC_CASE_0(STIMULUS_NTM_MATRIX_LOGISTIC_CASE_0),
    .STIMULUS_NTM_MATRIX_SOFTMAX_CASE_0(STIMULUS_NTM_MATRIX_SOFTMAX_CASE_0),
    .STIMULUS_NTM_MATRIX_ONEPLUS_CASE_0(STIMULUS_NTM_MATRIX_ONEPLUS_CASE_0),
    .STIMULUS_NTM_MATRIX_SUMMATION_CASE_0(STIMULUS_NTM_MATRIX_SUMMATION_CASE_0),
    .STIMULUS_NTM_MATRIX_CONVOLUTION_CASE_1(STIMULUS_NTM_MATRIX_CONVOLUTION_CASE_1),
    .STIMULUS_NTM_MATRIX_COSINE_SIMILARITY_CASE_1(STIMULUS_NTM_MATRIX_COSINE_SIMILARITY_CASE_1),
    .STIMULUS_NTM_MATRIX_COSH_CASE_1(STIMULUS_NTM_MATRIX_COSH_CASE_1),
    .STIMULUS_NTM_MATRIX_SINH_CASE_1(STIMULUS_NTM_MATRIX_SINH_CASE_1),
    .STIMULUS_NTM_MATRIX_TANH_CASE_1(STIMULUS_NTM_MATRIX_TANH_CASE_1),
    .STIMULUS_NTM_MATRIX_LOGISTIC_CASE_1(STIMULUS_NTM_MATRIX_LOGISTIC_CASE_1),
    .STIMULUS_NTM_MATRIX_SOFTMAX_CASE_1(STIMULUS_NTM_MATRIX_SOFTMAX_CASE_1),
    .STIMULUS_NTM_MATRIX_ONEPLUS_CASE_1(STIMULUS_NTM_MATRIX_ONEPLUS_CASE_1),
    .STIMULUS_NTM_MATRIX_SUMMATION_CASE_1(STIMULUS_NTM_MATRIX_SUMMATION_CASE_1)
  )
  function_stimulus(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    ///////////////////////////////////////////////////////////////////////
    // STIMULUS SCALAR
    ///////////////////////////////////////////////////////////////////////

    // SCALAR CONVOLUTION
    // CONTROL
    .SCALAR_CONVOLUTION_START(start_scalar_convolution),
    .SCALAR_CONVOLUTION_READY(ready_scalar_convolution),

    .SCALAR_CONVOLUTION_DATA_IN_ENABLE(data_in_enable_scalar_convolution),
    .SCALAR_CONVOLUTION_DATA_OUT_ENABLE(data_out_enable_scalar_convolution),

    // DATA
    .SCALAR_CONVOLUTION_MODULO_IN(modulo_in_scalar_convolution),
    .SCALAR_CONVOLUTION_LENGTH_IN(length_in_scalar_convolution),
    .SCALAR_CONVOLUTION_DATA_A_IN(data_a_in_scalar_convolution),
    .SCALAR_CONVOLUTION_DATA_B_IN(data_b_in_scalar_convolution),
    .SCALAR_CONVOLUTION_DATA_OUT(data_out_scalar_convolution),

    // SCALAR COSINE SIMILARITY
    // CONTROL
    .SCALAR_COSINE_SIMILARITY_START(start_scalar_cosine),
    .SCALAR_COSINE_SIMILARITY_READY(ready_scalar_cosine),

    .SCALAR_COSINE_SIMILARITY_DATA_IN_ENABLE(data_in_enable_scalar_cosine),
    .SCALAR_COSINE_SIMILARITY_DATA_OUT_ENABLE(data_out_enable_scalar_cosine),

    // DATA
    .SCALAR_COSINE_SIMILARITY_MODULO_IN(modulo_in_scalar_cosine),
    .SCALAR_COSINE_SIMILARITY_LENGTH_IN(length_in_scalar_cosine),
    .SCALAR_COSINE_SIMILARITY_DATA_A_IN(data_a_in_scalar_cosine),
    .SCALAR_COSINE_SIMILARITY_DATA_B_IN(data_b_in_scalar_cosine),
    .SCALAR_COSINE_SIMILARITY_DATA_OUT(data_out_scalar_cosine),

    // SCALAR MULTIPLICATION
    // CONTROL
    .SCALAR_MULTIPLICATION_START(start_scalar_multiplication),
    .SCALAR_MULTIPLICATION_READY(ready_scalar_multiplication),

    .SCALAR_MULTIPLICATION_DATA_IN_ENABLE(data_in_enable_scalar_multiplication),
    .SCALAR_MULTIPLICATION_DATA_OUT_ENABLE(data_out_enable_scalar_multiplication),

    // DATA
    .SCALAR_MULTIPLICATION_MODULO_IN(modulo_in_scalar_multiplication),
    .SCALAR_MULTIPLICATION_LENGTH_IN(length_in_scalar_multiplication),
    .SCALAR_MULTIPLICATION_DATA_IN(data_in_scalar_multiplication),
    .SCALAR_MULTIPLICATION_DATA_OUT(data_out_scalar_multiplication),

    // SCALAR COSH
    // CONTROL
    .SCALAR_COSH_START(start_scalar_cosh),
    .SCALAR_COSH_READY(ready_scalar_cosh),

    // DATA
    .SCALAR_COSH_MODULO_IN(modulo_in_scalar_cosh),
    .SCALAR_COSH_DATA_IN(data_in_scalar_cosh),
    .SCALAR_COSH_DATA_OUT(data_out_scalar_cosh),

    // SCALAR SINH
    // CONTROL
    .SCALAR_SINH_START(start_scalar_sinh),
    .SCALAR_SINH_READY(ready_scalar_sinh),

    // DATA
    .SCALAR_SINH_MODULO_IN(modulo_in_scalar_sinh),
    .SCALAR_SINH_DATA_IN(data_in_scalar_sinh),
    .SCALAR_SINH_DATA_OUT(data_out_scalar_sinh),

    // SCALAR TANH
    // CONTROL
    .SCALAR_TANH_START(start_scalar_tanh),
    .SCALAR_TANH_READY(ready_scalar_tanh),

    // DATA
    .SCALAR_TANH_MODULO_IN(modulo_in_scalar_tanh),
    .SCALAR_TANH_DATA_IN(data_in_scalar_tanh),
    .SCALAR_TANH_DATA_OUT(data_out_scalar_tanh),

    // SCALAR LOGISTIC
    // CONTROL
    .SCALAR_LOGISTIC_START(start_scalar_logistic),
    .SCALAR_LOGISTIC_READY(ready_scalar_logistic),

    // DATA
    .SCALAR_LOGISTIC_MODULO_IN(modulo_in_scalar_logistic),
    .SCALAR_LOGISTIC_DATA_IN(data_in_scalar_logistic),
    .SCALAR_LOGISTIC_DATA_OUT(data_out_scalar_logistic),

    // SCALAR SOFTMAX
    // CONTROL
    .SCALAR_SOFTMAX_START(start_scalar_softmax),
    .SCALAR_SOFTMAX_READY(ready_scalar_softmax),

    .SCALAR_SOFTMAX_DATA_IN_ENABLE(data_in_enable_scalar_softmax),
    .SCALAR_SOFTMAX_DATA_OUT_ENABLE(data_out_enable_scalar_softmax),

    // DATA
    .SCALAR_SOFTMAX_MODULO_IN(modulo_in_scalar_softmax),
    .SCALAR_SOFTMAX_LENGTH_IN(length_in_scalar_softmax),
    .SCALAR_SOFTMAX_DATA_IN(data_in_scalar_softmax),
    .SCALAR_SOFTMAX_DATA_OUT(data_out_scalar_softmax),

    // SCALAR ONEPLUS
    // CONTROL
    .SCALAR_ONEPLUS_START(start_scalar_oneplus),
    .SCALAR_ONEPLUS_READY(ready_scalar_oneplus),

    // DATA
    .SCALAR_ONEPLUS_MODULO_IN(modulo_in_scalar_oneplus),
    .SCALAR_ONEPLUS_DATA_IN(data_in_scalar_oneplus),
    .SCALAR_ONEPLUS_DATA_OUT(data_out_scalar_oneplus),

    // SCALAR SUMMATION
    // CONTROL
    .SCALAR_SUMMATION_START(start_scalar_summation),
    .SCALAR_SUMMATION_READY(ready_scalar_summation),

    .SCALAR_SUMMATION_DATA_IN_ENABLE(data_in_enable_scalar_summation),
    .SCALAR_SUMMATION_DATA_OUT_ENABLE(data_out_enable_scalar_summation),

    // DATA
    .SCALAR_SUMMATION_MODULO_IN(modulo_in_scalar_summation),
    .SCALAR_SUMMATION_LENGTH_IN(length_in_scalar_summation),
    .SCALAR_SUMMATION_DATA_IN(data_in_scalar_summation),
    .SCALAR_SUMMATION_DATA_OUT(data_out_scalar_summation),

    ///////////////////////////////////////////////////////////////////////
    // STIMULUS VECTOR
    ///////////////////////////////////////////////////////////////////////

    // VECTOR CONVOLUTION
    // CONTROL
    .VECTOR_CONVOLUTION_START(start_vector_convolution),
    .VECTOR_CONVOLUTION_READY(ready_vector_convolution),

    .VECTOR_CONVOLUTION_DATA_A_IN_VECTOR_ENABLE(data_a_in_vector_enable_vector_convolution),
    .VECTOR_CONVOLUTION_DATA_A_IN_SCALAR_ENABLE(data_a_in_scalar_enable_vector_convolution),
    .VECTOR_CONVOLUTION_DATA_B_IN_VECTOR_ENABLE(data_b_in_vector_enable_vector_convolution),
    .VECTOR_CONVOLUTION_DATA_B_IN_SCALAR_ENABLE(data_b_in_scalar_enable_vector_convolution),
    .VECTOR_CONVOLUTION_DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_convolution),
    .VECTOR_CONVOLUTION_DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_convolution),

    // DATA
    .VECTOR_CONVOLUTION_MODULO_IN(modulo_in_vector_convolution),
    .VECTOR_CONVOLUTION_SIZE_IN(size_in_vector_convolution),
    .VECTOR_CONVOLUTION_LENGTH_IN(length_in_vector_convolution),
    .VECTOR_CONVOLUTION_DATA_A_IN(data_a_in_vector_convolution),
    .VECTOR_CONVOLUTION_DATA_B_IN(data_b_in_vector_convolution),
    .VECTOR_CONVOLUTION_DATA_OUT(data_out_vector_convolution),

    // VECTOR COSINE SIMILARITY
    // CONTROL
    .VECTOR_COSINE_SIMILARITY_START(start_vector_cosine),
    .VECTOR_COSINE_SIMILARITY_READY(ready_vector_cosine),

    .VECTOR_COSINE_SIMILARITY_DATA_A_IN_VECTOR_ENABLE(data_a_in_vector_enable_vector_cosine),
    .VECTOR_COSINE_SIMILARITY_DATA_A_IN_SCALAR_ENABLE(data_a_in_scalar_enable_vector_cosine),
    .VECTOR_COSINE_SIMILARITY_DATA_B_IN_VECTOR_ENABLE(data_b_in_vector_enable_vector_cosine),
    .VECTOR_COSINE_SIMILARITY_DATA_B_IN_SCALAR_ENABLE(data_b_in_scalar_enable_vector_cosine),
    .VECTOR_COSINE_SIMILARITY_DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_cosine),
    .VECTOR_COSINE_SIMILARITY_DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_cosine),

    // DATA
    .VECTOR_COSINE_SIMILARITY_MODULO_IN(modulo_in_vector_cosine),
    .VECTOR_COSINE_SIMILARITY_SIZE_IN(size_in_vector_cosine),
    .VECTOR_COSINE_SIMILARITY_LENGTH_IN(length_in_vector_cosine),
    .VECTOR_COSINE_SIMILARITY_DATA_A_IN(data_a_in_vector_cosine),
    .VECTOR_COSINE_SIMILARITY_DATA_B_IN(data_b_in_vector_cosine),
    .VECTOR_COSINE_SIMILARITY_DATA_OUT(data_out_vector_cosine),

    // VECTOR COSH
    // CONTROL
    .VECTOR_COSH_START(start_vector_cosh),
    .VECTOR_COSH_READY(ready_vector_cosh),

    .VECTOR_COSH_DATA_IN_ENABLE(data_in_enable_vector_cosh),
    .VECTOR_COSH_DATA_OUT_ENABLE(data_out_enable_vector_cosh),

    // DATA
    .VECTOR_COSH_MODULO_IN(modulo_in_vector_cosh),
    .VECTOR_COSH_SIZE_IN(size_in_vector_cosh),
    .VECTOR_COSH_DATA_IN(data_in_vector_cosh),
    .VECTOR_COSH_DATA_OUT(data_out_vector_cosh),

    // VECTOR SINH
    // CONTROL
    .VECTOR_SINH_START(start_vector_sinh),
    .VECTOR_SINH_READY(ready_vector_sinh),

    .VECTOR_SINH_DATA_IN_ENABLE(data_in_enable_vector_sinh),
    .VECTOR_SINH_DATA_OUT_ENABLE(data_out_enable_vector_sinh),

    // DATA
    .VECTOR_SINH_MODULO_IN(modulo_in_vector_sinh),
    .VECTOR_SINH_SIZE_IN(size_in_vector_sinh),
    .VECTOR_SINH_DATA_IN(data_in_vector_sinh),
    .VECTOR_SINH_DATA_OUT(data_out_vector_sinh),

    // VECTOR TANH
    // CONTROL
    .VECTOR_TANH_START(start_vector_tanh),
    .VECTOR_TANH_READY(ready_vector_tanh),
    .VECTOR_TANH_DATA_IN_ENABLE(data_in_enable_vector_tanh),
    .VECTOR_TANH_DATA_OUT_ENABLE(data_out_enable_vector_tanh),

    // DATA
    .VECTOR_TANH_MODULO_IN(modulo_in_vector_tanh),
    .VECTOR_TANH_SIZE_IN(size_in_vector_tanh),
    .VECTOR_TANH_DATA_IN(data_in_vector_tanh),
    .VECTOR_TANH_DATA_OUT(data_out_vector_tanh),

    // VECTOR MULTIPLICATION
    // CONTROL
    .VECTOR_MULTIPLICATION_START(start_vector_multiplication),
    .VECTOR_MULTIPLICATION_READY(ready_vector_multiplication),
    .VECTOR_MULTIPLICATION_DATA_IN_VECTOR_ENABLE(data_in_vector_enable_vector_multiplication),
    .VECTOR_MULTIPLICATION_DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_vector_multiplication),
    .VECTOR_MULTIPLICATION_DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_multiplication),
    .VECTOR_MULTIPLICATION_DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_multiplication),

    // DATA
    .VECTOR_MULTIPLICATION_MODULO_IN(modulo_in_vector_multiplication),
    .VECTOR_MULTIPLICATION_SIZE_IN(size_in_vector_multiplication),
    .VECTOR_MULTIPLICATION_LENGTH_IN(length_in_vector_multiplication),
    .VECTOR_MULTIPLICATION_DATA_IN(data_in_vector_multiplication),
    .VECTOR_MULTIPLICATION_DATA_OUT(data_out_vector_multiplication),

    // VECTOR LOGISTIC
    // CONTROL
    .VECTOR_LOGISTIC_START(start_vector_logistic),
    .VECTOR_LOGISTIC_READY(ready_vector_logistic),

    .VECTOR_LOGISTIC_DATA_IN_ENABLE(data_in_enable_vector_logistic),
    .VECTOR_LOGISTIC_DATA_OUT_ENABLE(data_out_enable_vector_logistic),

    // DATA
    .VECTOR_LOGISTIC_MODULO_IN(modulo_in_vector_logistic),
    .VECTOR_LOGISTIC_SIZE_IN(size_in_vector_logistic),
    .VECTOR_LOGISTIC_DATA_IN(data_in_vector_logistic),
    .VECTOR_LOGISTIC_DATA_OUT(data_out_vector_logistic),

    // VECTOR SOFTMAX
    // CONTROL
    .VECTOR_SOFTMAX_START(start_vector_softmax),
    .VECTOR_SOFTMAX_READY(ready_vector_softmax),

    .VECTOR_SOFTMAX_DATA_IN_VECTOR_ENABLE(data_in_vector_enable_vector_softmax),
    .VECTOR_SOFTMAX_DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_vector_softmax),
    .VECTOR_SOFTMAX_DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_softmax),
    .VECTOR_SOFTMAX_DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_softmax),

    // DATA
    .VECTOR_SOFTMAX_MODULO_IN(modulo_in_vector_softmax),
    .VECTOR_SOFTMAX_SIZE_IN(size_in_vector_softmax),
    .VECTOR_SOFTMAX_LENGTH_IN(length_in_vector_softmax),
    .VECTOR_SOFTMAX_DATA_IN(data_in_vector_softmax),
    .VECTOR_SOFTMAX_DATA_OUT(data_out_vector_softmax),

    // VECTOR ONEPLUS
    // CONTROL
    .VECTOR_ONEPLUS_START(start_vector_oneplus),
    .VECTOR_ONEPLUS_READY(ready_vector_oneplus),

    .VECTOR_ONEPLUS_DATA_IN_ENABLE(data_in_enable_vector_oneplus),
    .VECTOR_ONEPLUS_DATA_OUT_ENABLE(data_out_enable_vector_oneplus),

    // DATA
    .VECTOR_ONEPLUS_MODULO_IN(modulo_in_vector_oneplus),
    .VECTOR_ONEPLUS_SIZE_IN(size_in_vector_oneplus),
    .VECTOR_ONEPLUS_DATA_IN(data_in_vector_oneplus),
    .VECTOR_ONEPLUS_DATA_OUT(data_out_vector_oneplus),

    // VECTOR SUMMATION
    // CONTROL
    .VECTOR_SUMMATION_START(start_vector_summation),
    .VECTOR_SUMMATION_READY(ready_vector_summation),

    .VECTOR_SUMMATION_DATA_IN_VECTOR_ENABLE(data_in_vector_enable_vector_summation),
    .VECTOR_SUMMATION_DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_vector_summation),
    .VECTOR_SUMMATION_DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_summation),
    .VECTOR_SUMMATION_DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_summation),

    // DATA
    .VECTOR_SUMMATION_MODULO_IN(modulo_in_vector_summation),
    .VECTOR_SUMMATION_SIZE_IN(size_in_vector_summation),
    .VECTOR_SUMMATION_LENGTH_IN(length_in_vector_summation),
    .VECTOR_SUMMATION_DATA_IN(data_in_vector_summation),
    .VECTOR_SUMMATION_DATA_OUT(data_out_vector_summation),

    ///////////////////////////////////////////////////////////////////////
    // STIMULUS MATRIX
    ///////////////////////////////////////////////////////////////////////

    // MATRIX CONVOLUTION
    // CONTROL
    .MATRIX_CONVOLUTION_START(start_matrix_convolution),
    .MATRIX_CONVOLUTION_READY(ready_matrix_convolution),

    .MATRIX_CONVOLUTION_DATA_A_IN_MATRIX_ENABLE(data_a_in_matrix_enable_matrix_convolution),
    .MATRIX_CONVOLUTION_DATA_A_IN_VECTOR_ENABLE(data_a_in_vector_enable_matrix_convolution),
    .MATRIX_CONVOLUTION_DATA_A_IN_SCALAR_ENABLE(data_a_in_scalar_enable_matrix_convolution),
    .MATRIX_CONVOLUTION_DATA_B_IN_MATRIX_ENABLE(data_b_in_matrix_enable_matrix_convolution),
    .MATRIX_CONVOLUTION_DATA_B_IN_VECTOR_ENABLE(data_b_in_vector_enable_matrix_convolution),
    .MATRIX_CONVOLUTION_DATA_B_IN_SCALAR_ENABLE(data_b_in_scalar_enable_matrix_convolution),
    .MATRIX_CONVOLUTION_DATA_OUT_MATRIX_ENABLE(data_out_matrix_enable_matrix_convolution),
    .MATRIX_CONVOLUTION_DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_matrix_convolution),
    .MATRIX_CONVOLUTION_DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_matrix_convolution),

    // DATA
    .MATRIX_CONVOLUTION_MODULO_IN(modulo_in_matrix_convolution),
    .MATRIX_CONVOLUTION_SIZE_I_IN(size_i_in_matrix_convolution),
    .MATRIX_CONVOLUTION_SIZE_J_IN(size_j_in_matrix_convolution),
    .MATRIX_CONVOLUTION_LENGTH_IN(length_in_matrix_convolution),
    .MATRIX_CONVOLUTION_DATA_A_IN(data_a_in_matrix_convolution),
    .MATRIX_CONVOLUTION_DATA_B_IN(data_b_in_matrix_convolution),
    .MATRIX_CONVOLUTION_DATA_OUT(data_out_matrix_convolution),

    // MATRIX COSINE SIMILARITY
    // CONTROL
    .MATRIX_COSINE_SIMILARITY_START(start_matrix_cosine),
    .MATRIX_COSINE_SIMILARITY_READY(ready_matrix_cosine),

    .MATRIX_COSINE_SIMILARITY_DATA_A_IN_MATRIX_ENABLE(data_a_in_matrix_enable_matrix_cosine),
    .MATRIX_COSINE_SIMILARITY_DATA_A_IN_VECTOR_ENABLE(data_a_in_vector_enable_matrix_cosine),
    .MATRIX_COSINE_SIMILARITY_DATA_A_IN_SCALAR_ENABLE(data_a_in_scalar_enable_matrix_cosine),
    .MATRIX_COSINE_SIMILARITY_DATA_B_IN_MATRIX_ENABLE(data_b_in_matrix_enable_matrix_cosine),
    .MATRIX_COSINE_SIMILARITY_DATA_B_IN_VECTOR_ENABLE(data_b_in_vector_enable_matrix_cosine),
    .MATRIX_COSINE_SIMILARITY_DATA_B_IN_SCALAR_ENABLE(data_b_in_scalar_enable_matrix_cosine),
    .MATRIX_COSINE_SIMILARITY_DATA_OUT_MATRIX_ENABLE(data_out_matrix_enable_matrix_cosine),
    .MATRIX_COSINE_SIMILARITY_DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_matrix_cosine),
    .MATRIX_COSINE_SIMILARITY_DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_matrix_cosine),

    // DATA
    .MATRIX_COSINE_SIMILARITY_MODULO_IN(modulo_in_matrix_cosine),
    .MATRIX_COSINE_SIMILARITY_SIZE_I_IN(size_i_in_matrix_cosine),
    .MATRIX_COSINE_SIMILARITY_SIZE_J_IN(size_j_in_matrix_cosine),
    .MATRIX_COSINE_SIMILARITY_LENGTH_IN(length_in_matrix_cosine),
    .MATRIX_COSINE_SIMILARITY_DATA_A_IN(data_a_in_matrix_cosine),
    .MATRIX_COSINE_SIMILARITY_DATA_B_IN(data_b_in_matrix_cosine),
    .MATRIX_COSINE_SIMILARITY_DATA_OUT(data_out_matrix_cosine),

    // MATRIX MULTIPLICATION
    // CONTROL
    .MATRIX_MULTIPLICATION_START(start_matrix_multiplication),
    .MATRIX_MULTIPLICATION_READY(ready_matrix_multiplication),

    .MATRIX_MULTIPLICATION_DATA_IN_MATRIX_ENABLE(data_in_matrix_enable_matrix_multiplication),
    .MATRIX_MULTIPLICATION_DATA_IN_VECTOR_ENABLE(data_in_vector_enable_matrix_multiplication),
    .MATRIX_MULTIPLICATION_DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_matrix_multiplication),
    .MATRIX_MULTIPLICATION_DATA_OUT_MATRIX_ENABLE(data_out_matrix_enable_matrix_multiplication),
    .MATRIX_MULTIPLICATION_DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_matrix_multiplication),
    .MATRIX_MULTIPLICATION_DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_matrix_multiplication),

    // DATA
    .MATRIX_MULTIPLICATION_MODULO_IN(modulo_in_matrix_multiplication),
    .MATRIX_MULTIPLICATION_SIZE_I_IN(size_i_in_matrix_multiplication),
    .MATRIX_MULTIPLICATION_SIZE_J_IN(size_j_in_matrix_multiplication),
    .MATRIX_MULTIPLICATION_LENGTH_IN(length_in_matrix_multiplication),
    .MATRIX_MULTIPLICATION_DATA_IN(data_in_matrix_multiplication),
    .MATRIX_MULTIPLICATION_DATA_OUT(data_out_matrix_multiplication),

    // MATRIX COSH
    // CONTROL
    .MATRIX_COSH_START(start_matrix_cosh),
    .MATRIX_COSH_READY(ready_matrix_cosh),

    .MATRIX_COSH_DATA_IN_I_ENABLE(data_in_i_enable_matrix_cosh),
    .MATRIX_COSH_DATA_IN_J_ENABLE(data_in_j_enable_matrix_cosh),
    .MATRIX_COSH_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_cosh),
    .MATRIX_COSH_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_cosh),

    // DATA
    .MATRIX_COSH_MODULO_IN(modulo_in_matrix_cosh),
    .MATRIX_COSH_SIZE_I_IN(size_i_in_matrix_cosh),
    .MATRIX_COSH_SIZE_J_IN(size_j_in_matrix_cosh),
    .MATRIX_COSH_DATA_IN(data_in_matrix_cosh),
    .MATRIX_COSH_DATA_OUT(data_out_matrix_cosh),

    // MATRIX SINH
    // CONTROL
    .MATRIX_SINH_START(start_matrix_sinh),
    .MATRIX_SINH_READY(ready_matrix_sinh),

    .MATRIX_SINH_DATA_IN_I_ENABLE(data_in_i_enable_matrix_sinh),
    .MATRIX_SINH_DATA_IN_J_ENABLE(data_in_j_enable_matrix_sinh),
    .MATRIX_SINH_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_sinh),
    .MATRIX_SINH_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_sinh),

    // DATA
    .MATRIX_SINH_MODULO_IN(modulo_in_matrix_sinh),
    .MATRIX_SINH_SIZE_I_IN(size_i_in_matrix_sinh),
    .MATRIX_SINH_SIZE_J_IN(size_j_in_matrix_sinh),
    .MATRIX_SINH_DATA_IN(data_in_matrix_sinh),
    .MATRIX_SINH_DATA_OUT(data_out_matrix_sinh),

    // MATRIX TANH
    // CONTROL
    .MATRIX_TANH_START(start_matrix_tanh),
    .MATRIX_TANH_READY(ready_matrix_tanh),

    .MATRIX_TANH_DATA_IN_I_ENABLE(data_in_i_enable_matrix_tanh),
    .MATRIX_TANH_DATA_IN_J_ENABLE(data_in_j_enable_matrix_tanh),
    .MATRIX_TANH_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_tanh),
    .MATRIX_TANH_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_tanh),

    // DATA
    .MATRIX_TANH_MODULO_IN(modulo_in_matrix_tanh),
    .MATRIX_TANH_SIZE_I_IN(size_i_in_matrix_tanh),
    .MATRIX_TANH_SIZE_J_IN(size_j_in_matrix_tanh),
    .MATRIX_TANH_DATA_IN(data_in_matrix_tanh),
    .MATRIX_TANH_DATA_OUT(data_out_matrix_tanh),

    // MATRIX LOGISTIC
    // CONTROL
    .MATRIX_LOGISTIC_START(start_matrix_logistic),
    .MATRIX_LOGISTIC_READY(ready_matrix_logistic),

    .MATRIX_LOGISTIC_DATA_IN_I_ENABLE(data_in_i_enable_matrix_logistic),
    .MATRIX_LOGISTIC_DATA_IN_J_ENABLE(data_in_j_enable_matrix_logistic),
    .MATRIX_LOGISTIC_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_logistic),
    .MATRIX_LOGISTIC_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_logistic),

    // DATA
    .MATRIX_LOGISTIC_MODULO_IN(modulo_in_matrix_logistic),
    .MATRIX_LOGISTIC_SIZE_I_IN(size_i_in_matrix_logistic),
    .MATRIX_LOGISTIC_SIZE_J_IN(size_j_in_matrix_logistic),
    .MATRIX_LOGISTIC_DATA_IN(data_in_matrix_logistic),
    .MATRIX_LOGISTIC_DATA_OUT(data_out_matrix_logistic),

    // MATRIX SOFTMAX
    // CONTROL
    .MATRIX_SOFTMAX_START(start_matrix_softmax),
    .MATRIX_SOFTMAX_READY(ready_matrix_softmax),

    .MATRIX_SOFTMAX_DATA_IN_MATRIX_ENABLE(data_in_matrix_enable_matrix_softmax),
    .MATRIX_SOFTMAX_DATA_IN_VECTOR_ENABLE(data_in_vector_enable_matrix_softmax),
    .MATRIX_SOFTMAX_DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_matrix_softmax),
    .MATRIX_SOFTMAX_DATA_OUT_MATRIX_ENABLE(data_out_matrix_enable_matrix_softmax),
    .MATRIX_SOFTMAX_DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_matrix_softmax),
    .MATRIX_SOFTMAX_DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_matrix_softmax),

    // DATA
    .MATRIX_SOFTMAX_MODULO_IN(modulo_in_matrix_softmax),
    .MATRIX_SOFTMAX_SIZE_I_IN(size_i_in_matrix_softmax),
    .MATRIX_SOFTMAX_SIZE_J_IN(size_j_in_matrix_softmax),
    .MATRIX_SOFTMAX_LENGTH_IN(length_in_matrix_softmax),
    .MATRIX_SOFTMAX_DATA_IN(data_in_matrix_softmax),
    .MATRIX_SOFTMAX_DATA_OUT(data_out_matrix_softmax),

    // MATRIX ONEPLUS
    // CONTROL
    .MATRIX_ONEPLUS_START(start_matrix_oneplus),
    .MATRIX_ONEPLUS_READY(ready_matrix_oneplus),

    .MATRIX_ONEPLUS_DATA_IN_I_ENABLE(data_in_i_enable_matrix_oneplus),
    .MATRIX_ONEPLUS_DATA_IN_J_ENABLE(data_in_j_enable_matrix_oneplus),
    .MATRIX_ONEPLUS_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_oneplus),
    .MATRIX_ONEPLUS_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_oneplus),

    // DATA
    .MATRIX_ONEPLUS_MODULO_IN(modulo_in_matrix_oneplus),
    .MATRIX_ONEPLUS_SIZE_I_IN(size_i_in_matrix_oneplus),
    .MATRIX_ONEPLUS_SIZE_J_IN(size_j_in_matrix_oneplus),
    .MATRIX_ONEPLUS_DATA_IN(data_in_matrix_oneplus),
    .MATRIX_ONEPLUS_DATA_OUT(data_out_matrix_oneplus),

    // MATRIX SUMMATION
    // CONTROL
    .MATRIX_SUMMATION_START(start_matrix_summation),
    .MATRIX_SUMMATION_READY(ready_matrix_summation),

    .MATRIX_SUMMATION_DATA_IN_MATRIX_ENABLE(data_in_matrix_enable_matrix_summation),
    .MATRIX_SUMMATION_DATA_IN_VECTOR_ENABLE(data_in_vector_enable_matrix_summation),
    .MATRIX_SUMMATION_DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_matrix_summation),
    .MATRIX_SUMMATION_DATA_OUT_MATRIX_ENABLE(data_out_matrix_enable_matrix_summation),
    .MATRIX_SUMMATION_DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_matrix_summation),
    .MATRIX_SUMMATION_DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_matrix_summation),

    // DATA
    .MATRIX_SUMMATION_MODULO_IN(modulo_in_matrix_summation),
    .MATRIX_SUMMATION_SIZE_I_IN(size_i_in_matrix_summation),
    .MATRIX_SUMMATION_SIZE_J_IN(size_j_in_matrix_summation),
    .MATRIX_SUMMATION_LENGTH_IN(length_in_matrix_summation),
    .MATRIX_SUMMATION_DATA_IN(data_in_matrix_summation),
    .MATRIX_SUMMATION_DATA_OUT(data_out_matrix_summation)
  );

  ///////////////////////////////////////////////////////////////////////
  // SCALAR
  ///////////////////////////////////////////////////////////////////////
  // SCALAR CONVOLUTION
  ntm_scalar_convolution_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  scalar_convolution_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_convolution),
    .READY(ready_scalar_convolution),

    .DATA_IN_ENABLE(data_in_enable_scalar_convolution),
    .DATA_OUT_ENABLE(data_out_enable_scalar_convolution),

    // DATA
    .MODULO_IN(modulo_in_scalar_convolution),
    .LENGTH_IN(length_in_scalar_convolution),
    .DATA_A_IN(data_a_in_scalar_convolution),
    .DATA_B_IN(data_b_in_scalar_convolution),
    .DATA_OUT(data_out_scalar_convolution)
  );

  // SCALAR COSINE SIMILARITY
  ntm_scalar_cosine_similarity_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  scalar_cosine_similarity_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_cosine),
    .READY(ready_scalar_cosine),

    .DATA_IN_ENABLE(data_in_enable_scalar_cosine),
    .DATA_OUT_ENABLE(data_out_enable_scalar_cosine),

    // DATA
    .MODULO_IN(modulo_in_scalar_cosine),
    .LENGTH_IN(length_in_scalar_cosine),
    .DATA_A_IN(data_a_in_scalar_cosine),
    .DATA_B_IN(data_b_in_scalar_cosine),
    .DATA_OUT(data_out_scalar_cosine)
  );

  // SCALAR DIFFERENTIATION
  ntm_scalar_differentiation_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  scalar_differentiation_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_differentiation),
    .READY(ready_scalar_differentiation),

    // DATA
    .MODULO_IN(modulo_in_scalar_differentiation),
    .DATA_IN(data_in_scalar_differentiation),
    .DATA_OUT(data_out_scalar_differentiation)
  );

  // SCALAR MULTIPLICATION
  ntm_scalar_multiplication_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  scalar_multiplication_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_multiplication),
    .READY(ready_scalar_multiplication),

    .DATA_IN_ENABLE(data_in_enable_scalar_multiplication),
    .DATA_OUT_ENABLE(data_out_enable_scalar_multiplication),

    // DATA
    .MODULO_IN(modulo_in_scalar_multiplication),
    .LENGTH_IN(length_in_scalar_multiplication),
    .DATA_IN(data_in_scalar_multiplication),
    .DATA_OUT(data_out_scalar_multiplication)
  );

  // SCALAR COSH
  ntm_scalar_cosh_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  scalar_cosh_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_cosh),
    .READY(ready_scalar_cosh),

    // DATA
    .MODULO_IN(modulo_in_scalar_cosh),
    .DATA_IN(data_in_scalar_cosh),
    .DATA_OUT(data_out_scalar_cosh)
  );

  // SCALAR SINH
  ntm_scalar_sinh_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  scalar_sinh_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_sinh),
    .READY(ready_scalar_sinh),

    // DATA
    .MODULO_IN(modulo_in_scalar_sinh),
    .DATA_IN(data_in_scalar_sinh),
    .DATA_OUT(data_out_scalar_sinh)
  );

  // SCALAR TANH
  ntm_scalar_tanh_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  scalar_tanh_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_tanh),
    .READY(ready_scalar_tanh),

    // DATA
    .MODULO_IN(modulo_in_scalar_tanh),
    .DATA_IN(data_in_scalar_tanh),
    .DATA_OUT(data_out_scalar_tanh)
  );

  // SCALAR LOGISTIC
  ntm_scalar_logistic_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  scalar_logistic_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_logistic),
    .READY(ready_scalar_logistic),

    // DATA
    .MODULO_IN(modulo_in_scalar_logistic),
    .DATA_IN(data_in_scalar_logistic),
    .DATA_OUT(data_out_scalar_logistic)
  );

  // SCALAR SOFTMAX
  ntm_scalar_softmax_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  scalar_softmax_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_softmax),
    .READY(ready_scalar_softmax),

    .DATA_IN_ENABLE(data_in_enable_scalar_softmax),
    .DATA_OUT_ENABLE(data_out_enable_scalar_softmax),

    // DATA
    .MODULO_IN(modulo_in_scalar_softmax),
    .LENGTH_IN(length_in_scalar_softmax),
    .DATA_IN(data_in_scalar_softmax),
    .DATA_OUT(data_out_scalar_softmax)
  );

  // SCALAR ONEPLUS
  ntm_scalar_oneplus_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  scalar_oneplus_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_oneplus),
    .READY(ready_scalar_oneplus),

    // DATA
    .MODULO_IN(modulo_in_scalar_oneplus),
    .DATA_IN(data_in_scalar_oneplus),
    .DATA_OUT(data_out_scalar_oneplus)
  );

  // SCALAR SUMMATION
  ntm_scalar_summation_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  scalar_summation_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_summation),
    .READY(ready_scalar_summation),

    .DATA_IN_ENABLE(data_in_enable_scalar_summation),
    .DATA_OUT_ENABLE(data_out_enable_scalar_summation),

    // DATA
    .MODULO_IN(modulo_in_scalar_summation),
    .LENGTH_IN(length_in_scalar_summation),
    .DATA_IN(data_in_scalar_summation),
    .DATA_OUT(data_out_scalar_summation)
  );

  ///////////////////////////////////////////////////////////////////////
  // VECTOR
  ///////////////////////////////////////////////////////////////////////

  // VECTOR CONVOLUTION
  ntm_vector_convolution_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_convolution_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_convolution),
    .READY(ready_vector_convolution),

    .DATA_A_IN_VECTOR_ENABLE(data_a_in_vector_enable_vector_convolution),
    .DATA_A_IN_SCALAR_ENABLE(data_a_in_scalar_enable_vector_convolution),
    .DATA_B_IN_VECTOR_ENABLE(data_b_in_vector_enable_vector_convolution),
    .DATA_B_IN_SCALAR_ENABLE(data_b_in_scalar_enable_vector_convolution),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_convolution),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_convolution),

    // DATA
    .MODULO_IN(modulo_in_vector_convolution),
    .SIZE_IN(size_in_vector_convolution),
    .LENGTH_IN(length_in_vector_convolution),
    .DATA_A_IN(data_a_in_vector_convolution),
    .DATA_B_IN(data_b_in_vector_convolution),
    .DATA_OUT(data_out_vector_convolution)
  );

  // VECTOR COSINE SIMILARITY
  ntm_vector_cosine_similarity_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_cosine_similarity_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_cosine),
    .READY(ready_vector_cosine),

    .DATA_A_IN_VECTOR_ENABLE(data_a_in_vector_enable_vector_cosine),
    .DATA_A_IN_SCALAR_ENABLE(data_a_in_scalar_enable_vector_cosine),
    .DATA_B_IN_VECTOR_ENABLE(data_b_in_vector_enable_vector_cosine),
    .DATA_B_IN_SCALAR_ENABLE(data_b_in_scalar_enable_vector_cosine),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_cosine),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_cosine),

    // DATA
    .MODULO_IN(modulo_in_vector_cosine),
    .SIZE_IN(size_in_vector_cosine),
    .LENGTH_IN(length_in_vector_cosine),
    .DATA_A_IN(data_a_in_vector_cosine),
    .DATA_B_IN(data_b_in_vector_cosine),
    .DATA_OUT(data_out_vector_cosine)
  );

  // VECTOR DIFFERENTIATION
  ntm_vector_differentiation_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_differentiation_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_differentiation),
    .READY(ready_vector_differentiation),

    .DATA_IN_ENABLE(data_in_enable_vector_differentiation),
    .DATA_OUT_ENABLE(data_out_enable_vector_differentiation),

    // DATA
    .MODULO_IN(modulo_in_vector_differentiation),
    .SIZE_IN(size_in_vector_differentiation),
    .DATA_IN(data_in_vector_differentiation),
    .DATA_OUT(data_out_vector_differentiation)
  );

  // VECTOR MULTIPLICATION
  ntm_vector_multiplication_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_multiplication_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_multiplication),
    .READY(ready_vector_multiplication),

    .DATA_IN_VECTOR_ENABLE(data_in_vector_enable_vector_multiplication),
    .DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_vector_multiplication),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_multiplication),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_multiplication),

    // DATA
    .MODULO_IN(modulo_in_vector_multiplication),
    .SIZE_IN(size_in_vector_multiplication),
    .LENGTH_IN(length_in_vector_multiplication),
    .DATA_IN(data_in_vector_multiplication),
    .DATA_OUT(data_out_vector_multiplication)
  );

  // VECTOR COSH
  ntm_vector_cosh_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_cosh_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_cosh),
    .READY(ready_vector_cosh),

    .DATA_IN_ENABLE(data_in_enable_vector_cosh),
    .DATA_OUT_ENABLE(data_out_enable_vector_cosh),

    // DATA
    .MODULO_IN(modulo_in_vector_cosh),
    .SIZE_IN(size_in_vector_cosh),
    .DATA_IN(data_in_vector_cosh),
    .DATA_OUT(data_out_vector_cosh)
  );

  // VECTOR SINH
  ntm_vector_sinh_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_sinh_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_sinh),
    .READY(ready_vector_sinh),

    .DATA_IN_ENABLE(data_in_enable_vector_sinh),
    .DATA_OUT_ENABLE(data_out_enable_vector_sinh),

    // DATA
    .MODULO_IN(modulo_in_vector_sinh),
    .SIZE_IN(size_in_vector_sinh),
    .DATA_IN(data_in_vector_sinh),
    .DATA_OUT(data_out_vector_sinh)
  );

  // VECTOR TANH
  ntm_vector_tanh_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_tanh_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_tanh),
    .READY(ready_vector_tanh),

    .DATA_IN_ENABLE(data_in_enable_vector_tanh),
    .DATA_OUT_ENABLE(data_out_enable_vector_tanh),

    // DATA
    .MODULO_IN(modulo_in_vector_tanh),
    .SIZE_IN(size_in_vector_tanh),
    .DATA_IN(data_in_vector_tanh),
    .DATA_OUT(data_out_vector_tanh)
  );

  // VECTOR LOGISTIC
  ntm_vector_logistic_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_logistic_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_logistic),
    .READY(ready_vector_logistic),

    .DATA_IN_ENABLE(data_in_enable_vector_logistic),
    .DATA_OUT_ENABLE(data_out_enable_vector_logistic),

    // DATA
    .MODULO_IN(modulo_in_vector_logistic),
    .SIZE_IN(size_in_vector_logistic),
    .DATA_IN(data_in_vector_logistic),
    .DATA_OUT(data_out_vector_logistic)
  );

  // VECTOR SOFTMAX
  ntm_vector_softmax_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_softmax_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_softmax),
    .READY(ready_vector_softmax),

    .DATA_IN_VECTOR_ENABLE(data_in_vector_enable_vector_softmax),
    .DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_vector_softmax),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_softmax),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_softmax),

    // DATA
    .MODULO_IN(modulo_in_vector_softmax),
    .SIZE_IN(size_in_vector_softmax),
    .LENGTH_IN(length_in_vector_softmax),
    .DATA_IN(data_in_vector_softmax),
    .DATA_OUT(data_out_vector_softmax)
  );

  // VECTOR ONEPLUS
  ntm_vector_oneplus_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_oneplus_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_oneplus),
    .READY(ready_vector_oneplus),

    .DATA_IN_ENABLE(data_in_enable_vector_oneplus),
    .DATA_OUT_ENABLE(data_out_enable_vector_oneplus),

    // DATA
    .MODULO_IN(modulo_in_vector_oneplus),
    .SIZE_IN(size_in_vector_oneplus),
    .DATA_IN(data_in_vector_oneplus),
    .DATA_OUT(data_out_vector_oneplus)
  );

  // VECTOR SUMMATION
  ntm_vector_summation_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_summation_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_summation),
    .READY(ready_vector_summation),

    .DATA_IN_VECTOR_ENABLE(data_in_vector_enable_vector_summation),
    .DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_vector_summation),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_summation),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_summation),

    // DATA
    .MODULO_IN(modulo_in_vector_summation),
    .SIZE_IN(size_in_vector_summation),
    .LENGTH_IN(length_in_vector_summation),
    .DATA_IN(data_in_vector_summation),
    .DATA_OUT(data_out_vector_summation)
  );

  ///////////////////////////////////////////////////////////////////////
  // MATRIX
  ///////////////////////////////////////////////////////////////////////
  // MATRIX CONVOLUTION
  ntm_matrix_convolution_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  matrix_convolution_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_convolution),
    .READY(ready_matrix_convolution),

    .DATA_A_IN_MATRIX_ENABLE(data_a_in_matrix_enable_matrix_convolution),
    .DATA_A_IN_VECTOR_ENABLE(data_a_in_vector_enable_matrix_convolution),
    .DATA_A_IN_SCALAR_ENABLE(data_a_in_scalar_enable_matrix_convolution),
    .DATA_B_IN_MATRIX_ENABLE(data_b_in_matrix_enable_matrix_convolution),
    .DATA_B_IN_VECTOR_ENABLE(data_b_in_vector_enable_matrix_convolution),
    .DATA_B_IN_SCALAR_ENABLE(data_b_in_scalar_enable_matrix_convolution),
    .DATA_OUT_MATRIX_ENABLE(data_out_matrix_enable_matrix_convolution),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_matrix_convolution),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_matrix_convolution),

    // DATA
    .MODULO_IN(modulo_in_matrix_convolution),
    .SIZE_I_IN(size_i_in_matrix_convolution),
    .SIZE_J_IN(size_j_in_matrix_convolution),
    .LENGTH_IN(length_in_matrix_convolution),
    .DATA_A_IN(data_a_in_matrix_convolution),
    .DATA_B_IN(data_b_in_matrix_convolution),
    .DATA_OUT(data_out_matrix_convolution)
  );

  // MATRIX COSINE SIMILARITY
  ntm_matrix_cosine_similarity_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  matrix_cosine_similarity_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_cosine),
    .READY(ready_matrix_cosine),

    .DATA_A_IN_MATRIX_ENABLE(data_a_in_matrix_enable_matrix_cosine),
    .DATA_A_IN_VECTOR_ENABLE(data_a_in_vector_enable_matrix_cosine),
    .DATA_A_IN_SCALAR_ENABLE(data_a_in_scalar_enable_matrix_cosine),
    .DATA_B_IN_MATRIX_ENABLE(data_b_in_matrix_enable_matrix_cosine),
    .DATA_B_IN_VECTOR_ENABLE(data_b_in_vector_enable_matrix_cosine),
    .DATA_B_IN_SCALAR_ENABLE(data_b_in_scalar_enable_matrix_cosine),
    .DATA_OUT_MATRIX_ENABLE(data_out_matrix_enable_matrix_cosine),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_matrix_cosine),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_matrix_cosine),

    // DATA
    .MODULO_IN(modulo_in_matrix_cosine),
    .SIZE_I_IN(size_i_in_matrix_cosine),
    .SIZE_J_IN(size_j_in_matrix_cosine),
    .LENGTH_IN(length_in_matrix_cosine),
    .DATA_A_IN(data_a_in_matrix_cosine),
    .DATA_B_IN(data_b_in_matrix_cosine),
    .DATA_OUT(data_out_matrix_cosine)
  );

  // MATRIX DIFFERENTIATION
  ntm_matrix_differentiation_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  matrix_differentiation_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_differentiation),
    .READY(ready_matrix_differentiation),

    .DATA_IN_I_ENABLE(data_in_i_enable_matrix_differentiation),
    .DATA_IN_J_ENABLE(data_in_j_enable_matrix_differentiation),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_differentiation),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_differentiation),

    // DATA
    .MODULO_IN(modulo_in_matrix_differentiation),
    .SIZE_I_IN(size_i_in_matrix_differentiation),
    .SIZE_J_IN(size_j_in_matrix_differentiation),
    .DATA_IN(data_in_matrix_differentiation),
    .DATA_OUT(data_out_matrix_differentiation)
  );

  // MATRIX MULTIPLICATION
  ntm_matrix_multiplication_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  matrix_multiplication_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_multiplication),
    .READY(ready_matrix_multiplication),

    .DATA_IN_MATRIX_ENABLE(data_in_matrix_enable_matrix_multiplication),
    .DATA_IN_VECTOR_ENABLE(data_in_vector_enable_matrix_multiplication),
    .DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_matrix_multiplication),
    .DATA_OUT_MATRIX_ENABLE(data_out_matrix_enable_matrix_multiplication),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_matrix_multiplication),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_matrix_multiplication),

    // DATA
    .MODULO_IN(modulo_in_matrix_multiplication),
    .SIZE_I_IN(size_i_in_matrix_multiplication),
    .SIZE_J_IN(size_j_in_matrix_multiplication),
    .LENGTH_IN(length_in_matrix_multiplication),
    .DATA_IN(data_in_matrix_multiplication),
    .DATA_OUT(data_out_matrix_multiplication)
  );

  // MATRIX COSH
  ntm_matrix_cosh_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  matrix_cosh_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_cosh),
    .READY(ready_matrix_cosh),

    .DATA_IN_I_ENABLE(data_in_i_enable_matrix_cosh),
    .DATA_IN_J_ENABLE(data_in_j_enable_matrix_cosh),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_cosh),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_cosh),

    // DATA
    .MODULO_IN(modulo_in_matrix_cosh),
    .SIZE_I_IN(size_i_in_matrix_cosh),
    .SIZE_J_IN(size_j_in_matrix_cosh),
    .DATA_IN(data_in_matrix_cosh),
    .DATA_OUT(data_out_matrix_cosh)
  );

  // MATRIX SINH
  ntm_matrix_sinh_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  matrix_sinh_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_sinh),
    .READY(ready_matrix_sinh),

    .DATA_IN_I_ENABLE(data_in_i_enable_matrix_sinh),
    .DATA_IN_J_ENABLE(data_in_j_enable_matrix_sinh),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_sinh),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_sinh),

    // DATA
    .MODULO_IN(modulo_in_matrix_sinh),
    .SIZE_I_IN(size_i_in_matrix_sinh),
    .SIZE_J_IN(size_j_in_matrix_sinh),
    .DATA_IN(data_in_matrix_sinh),
    .DATA_OUT(data_out_matrix_sinh)
  );

  // MATRIX TANH
  ntm_matrix_tanh_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  matrix_tanh_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_tanh),
    .READY(ready_matrix_tanh),

    .DATA_IN_I_ENABLE(data_in_i_enable_matrix_tanh),
    .DATA_IN_J_ENABLE(data_in_j_enable_matrix_tanh),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_tanh),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_tanh),

    // DATA
    .MODULO_IN(modulo_in_matrix_tanh),
    .SIZE_I_IN(size_i_in_matrix_tanh),
    .SIZE_J_IN(size_j_in_matrix_tanh),
    .DATA_IN(data_in_matrix_tanh),
    .DATA_OUT(data_out_matrix_tanh)
  );

  // MATRIX LOGISTIC
  ntm_matrix_logistic_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  matrix_logistic_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_logistic),
    .READY(ready_matrix_logistic),

    .DATA_IN_I_ENABLE(data_in_i_enable_matrix_logistic),
    .DATA_IN_J_ENABLE(data_in_j_enable_matrix_logistic),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_logistic),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_logistic),

    // DATA
    .MODULO_IN(modulo_in_matrix_logistic),
    .SIZE_I_IN(size_i_in_matrix_logistic),
    .SIZE_J_IN(size_j_in_matrix_logistic),
    .DATA_IN(data_in_matrix_logistic),
    .DATA_OUT(data_out_matrix_logistic)
  );

  // MATRIX SOFTMAX
  ntm_matrix_softmax_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  matrix_softmax_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_softmax),
    .READY(ready_matrix_softmax),

    .DATA_IN_MATRIX_ENABLE(data_in_matrix_enable_matrix_softmax),
    .DATA_IN_VECTOR_ENABLE(data_in_vector_enable_matrix_softmax),
    .DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_matrix_softmax),
    .DATA_OUT_MATRIX_ENABLE(data_out_matrix_enable_matrix_softmax),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_matrix_softmax),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_matrix_softmax),

    // DATA
    .MODULO_IN(modulo_in_matrix_softmax),
    .SIZE_I_IN(size_i_in_matrix_softmax),
    .SIZE_J_IN(size_j_in_matrix_softmax),
    .LENGTH_IN(length_in_matrix_softmax),
    .DATA_IN(data_in_matrix_softmax),
    .DATA_OUT(data_out_matrix_softmax)
  );

  // MATRIX ONEPLUS
  ntm_matrix_oneplus_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  matrix_oneplus_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_oneplus),
    .READY(ready_matrix_oneplus),

    .DATA_IN_I_ENABLE(data_in_i_enable_matrix_oneplus),
    .DATA_IN_J_ENABLE(data_in_j_enable_matrix_oneplus),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_oneplus),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_oneplus),

    // DATA
    .MODULO_IN(modulo_in_matrix_oneplus),
    .SIZE_I_IN(size_i_in_matrix_oneplus),
    .SIZE_J_IN(size_j_in_matrix_oneplus),
    .DATA_IN(data_in_matrix_oneplus),
    .DATA_OUT(data_out_matrix_oneplus)
  );

  // MATRIX SUMMATION
  ntm_matrix_summation_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  matrix_summation_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_summation),
    .READY(ready_matrix_summation),

    .DATA_IN_MATRIX_ENABLE(data_in_matrix_enable_matrix_summation),
    .DATA_IN_VECTOR_ENABLE(data_in_vector_enable_matrix_summation),
    .DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_matrix_summation),
    .DATA_OUT_MATRIX_ENABLE(data_out_matrix_enable_matrix_summation),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_matrix_summation),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_matrix_summation),

    // DATA
    .MODULO_IN(modulo_in_matrix_summation),
    .SIZE_I_IN(size_i_in_matrix_summation),
    .SIZE_J_IN(size_j_in_matrix_summation),
    .LENGTH_IN(length_in_matrix_summation),
    .DATA_IN(data_in_matrix_summation),
    .DATA_OUT(data_out_matrix_summation)
  );

endmodule
