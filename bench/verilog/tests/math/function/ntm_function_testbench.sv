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
  // Types
  ///////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  // SYSTEM-SIZE
  parameter DATA_SIZE=128;
  parameter CONTROL_SIZE=64;

  parameter X=64;
  parameter Y=64;
  parameter N=64;
  parameter W=64;
  parameter L=64;
  parameter R=64;

  // SCALAR-FUNCTIONALITY
  parameter STIMULUS_NTM_SCALAR_COSH_TEST=0;
  parameter STIMULUS_NTM_SCALAR_SINH_TEST=0;
  parameter STIMULUS_NTM_SCALAR_TANH_TEST=0;
  parameter STIMULUS_NTM_SCALAR_LOGISTIC_TEST=0;
  parameter STIMULUS_NTM_SCALAR_ONEPLUS_TEST=0;
  parameter STIMULUS_NTM_SCALAR_COSH_CASE_0=0;
  parameter STIMULUS_NTM_SCALAR_SINH_CASE_0=0;
  parameter STIMULUS_NTM_SCALAR_TANH_CASE_0=0;
  parameter STIMULUS_NTM_SCALAR_LOGISTIC_CASE_0=0;
  parameter STIMULUS_NTM_SCALAR_ONEPLUS_CASE_0=0;
  parameter STIMULUS_NTM_SCALAR_COSH_CASE_1=0;
  parameter STIMULUS_NTM_SCALAR_SINH_CASE_1=0;
  parameter STIMULUS_NTM_SCALAR_TANH_CASE_1=0;
  parameter STIMULUS_NTM_SCALAR_LOGISTIC_CASE_1=0;
  parameter STIMULUS_NTM_SCALAR_ONEPLUS_CASE_1=0;

  // VECTOR-FUNCTIONALITY
  parameter STIMULUS_NTM_VECTOR_COSH_TEST=0;
  parameter STIMULUS_NTM_VECTOR_SINH_TEST=0;
  parameter STIMULUS_NTM_VECTOR_TANH_TEST=0;
  parameter STIMULUS_NTM_VECTOR_LOGISTIC_TEST=0;
  parameter STIMULUS_NTM_VECTOR_ONEPLUS_TEST=0;
  parameter STIMULUS_NTM_VECTOR_COSH_CASE_0=0;
  parameter STIMULUS_NTM_VECTOR_SINH_CASE_0=0;
  parameter STIMULUS_NTM_VECTOR_TANH_CASE_0=0;
  parameter STIMULUS_NTM_VECTOR_LOGISTIC_CASE_0=0;
  parameter STIMULUS_NTM_VECTOR_ONEPLUS_CASE_0=0;
  parameter STIMULUS_NTM_VECTOR_COSH_CASE_1=0;
  parameter STIMULUS_NTM_VECTOR_SINH_CASE_1=0;
  parameter STIMULUS_NTM_VECTOR_TANH_CASE_1=0;
  parameter STIMULUS_NTM_VECTOR_LOGISTIC_CASE_1=0;
  parameter STIMULUS_NTM_VECTOR_ONEPLUS_CASE_1=0;

  // MATRIX-FUNCTIONALITY
  parameter STIMULUS_NTM_MATRIX_COSH_TEST=0;
  parameter STIMULUS_NTM_MATRIX_SINH_TEST=0;
  parameter STIMULUS_NTM_MATRIX_TANH_TEST=0;
  parameter STIMULUS_NTM_MATRIX_LOGISTIC_TEST=0;
  parameter STIMULUS_NTM_MATRIX_ONEPLUS_TEST=0;
  parameter STIMULUS_NTM_MATRIX_COSH_CASE_0=0;
  parameter STIMULUS_NTM_MATRIX_SINH_CASE_0=0;
  parameter STIMULUS_NTM_MATRIX_TANH_CASE_0=0;
  parameter STIMULUS_NTM_MATRIX_LOGISTIC_CASE_0=0;
  parameter STIMULUS_NTM_MATRIX_ONEPLUS_CASE_0=0;
  parameter STIMULUS_NTM_MATRIX_COSH_CASE_1=0;
  parameter STIMULUS_NTM_MATRIX_SINH_CASE_1=0;
  parameter STIMULUS_NTM_MATRIX_TANH_CASE_1=0;
  parameter STIMULUS_NTM_MATRIX_LOGISTIC_CASE_1=0;
  parameter STIMULUS_NTM_MATRIX_ONEPLUS_CASE_1=0;

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

  // GLOBAL
  wire CLK;
  wire RST;

  ///////////////////////////////////////////////////////////////////////
  // SCALAR
  ///////////////////////////////////////////////////////////////////////

  // CONTROL



  // DATA

  // CONTROL



  // DATA

  // CONTROL


  // DATA

  // CONTROL


  // DATA

  // SCALAR COSH
  // CONTROL
  wire start_scalar_cosh;
  wire ready_scalar_cosh;

  // DATA
  wire [DATA_SIZE-1:0] data_in_scalar_cosh;
  wire [DATA_SIZE-1:0] data_out_scalar_cosh;

  // SCALAR SINH
  // CONTROL
  wire start_scalar_sinh;
  wire ready_scalar_sinh;

  // DATA
  wire [DATA_SIZE-1:0] data_in_scalar_sinh;
  wire [DATA_SIZE-1:0] data_out_scalar_sinh;

  // SCALAR TANH
  // CONTROL
  wire start_scalar_tanh;
  wire ready_scalar_tanh;

  // DATA
  wire [DATA_SIZE-1:0] data_in_scalar_tanh;
  wire [DATA_SIZE-1:0] data_out_scalar_tanh;

  // SCALAR LOGISTIC
  // CONTROL
  wire start_scalar_logistic;
  wire ready_scalar_logistic;

  // DATA
  wire [DATA_SIZE-1:0] data_in_scalar_logistic;
  wire [DATA_SIZE-1:0] data_out_scalar_logistic;

  // CONTROL


  // DATA

  // SCALAR ONEPLUS
  // CONTROL
  wire start_scalar_oneplus;
  wire ready_scalar_oneplus;

  // DATA
  wire [DATA_SIZE-1:0] data_in_scalar_oneplus;
  wire [DATA_SIZE-1:0] data_out_scalar_oneplus;

  // CONTROL


  // DATA

  ///////////////////////////////////////////////////////////////////////
  // VECTOR
  ///////////////////////////////////////////////////////////////////////

  // CONTROL


  // DATA

  // CONTROL


  // DATA

  // CONTROL


  // DATA

  // CONTROL


  // DATA

  // VECTOR COSH
  // CONTROL
  wire start_vector_cosh;
  wire ready_vector_cosh;

  wire data_in_enable_vector_cosh;
  wire data_out_enable_vector_cosh;

  // DATA
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
  wire [DATA_SIZE-1:0] size_in_vector_logistic;
  wire [DATA_SIZE-1:0] data_in_vector_logistic;
  wire [DATA_SIZE-1:0] data_out_vector_logistic;

  // CONTROL



  // DATA

  // VECTOR ONEPLUS
  // CONTROL
  wire start_vector_oneplus;
  wire ready_vector_oneplus;

  wire data_in_enable_vector_oneplus;
  wire data_out_enable_vector_oneplus;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_oneplus;
  wire [DATA_SIZE-1:0] data_in_vector_oneplus;
  wire [DATA_SIZE-1:0] data_out_vector_oneplus;

  // CONTROL


  // DATA

  ///////////////////////////////////////////////////////////////////////
  // MATRIX
  ///////////////////////////////////////////////////////////////////////

  // MATRIX COSH
  // CONTROL
  wire start_matrix_cosh;
  wire ready_matrix_cosh;

  wire data_in_i_enable_matrix_cosh;
  wire data_in_j_enable_matrix_cosh;
  wire data_out_i_enable_matrix_cosh;
  wire data_out_j_enable_matrix_cosh;

  // DATA
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
  wire [DATA_SIZE-1:0] size_i_in_matrix_logistic;
  wire [DATA_SIZE-1:0] size_j_in_matrix_logistic;
  wire [DATA_SIZE-1:0] data_in_matrix_logistic;
  wire [DATA_SIZE-1:0] data_out_matrix_logistic;

  // CONTROL



  // DATA

  // MATRIX ONEPLUS
  // CONTROL
  wire start_matrix_oneplus;
  wire ready_matrix_oneplus;

  wire data_in_i_enable_matrix_oneplus;
  wire data_in_j_enable_matrix_oneplus;
  wire data_out_i_enable_matrix_oneplus;
  wire data_out_j_enable_matrix_oneplus;

  // DATA
  wire [DATA_SIZE-1:0] size_i_in_matrix_oneplus;
  wire [DATA_SIZE-1:0] size_j_in_matrix_oneplus;
  wire [DATA_SIZE-1:0] data_in_matrix_oneplus;
  wire [DATA_SIZE-1:0] data_out_matrix_oneplus;

  // CONTROL


  // DATA

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////
  ntm_function_stimulus #(
    // SYSTEM-SIZE
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE),

    .X(X),
    .Y(Y),
    .N(N),
    .W(W),
    .L(L),
    .R(R),

    // SCALAR-FUNCTIONALITY
    .STIMULUS_NTM_SCALAR_COSH_TEST(STIMULUS_NTM_SCALAR_COSH_TEST),
    .STIMULUS_NTM_SCALAR_SINH_TEST(STIMULUS_NTM_SCALAR_SINH_TEST),
    .STIMULUS_NTM_SCALAR_TANH_TEST(STIMULUS_NTM_SCALAR_TANH_TEST),
    .STIMULUS_NTM_SCALAR_LOGISTIC_TEST(STIMULUS_NTM_SCALAR_LOGISTIC_TEST),
    .STIMULUS_NTM_SCALAR_ONEPLUS_TEST(STIMULUS_NTM_SCALAR_ONEPLUS_TEST),
    .STIMULUS_NTM_SCALAR_COSH_CASE_0(STIMULUS_NTM_SCALAR_COSH_CASE_0),
    .STIMULUS_NTM_SCALAR_SINH_CASE_0(STIMULUS_NTM_SCALAR_SINH_CASE_0),
    .STIMULUS_NTM_SCALAR_TANH_CASE_0(STIMULUS_NTM_SCALAR_TANH_CASE_0),
    .STIMULUS_NTM_SCALAR_LOGISTIC_CASE_0(STIMULUS_NTM_SCALAR_LOGISTIC_CASE_0),
    .STIMULUS_NTM_SCALAR_ONEPLUS_CASE_0(STIMULUS_NTM_SCALAR_ONEPLUS_CASE_0),
    .STIMULUS_NTM_SCALAR_COSH_CASE_1(STIMULUS_NTM_SCALAR_COSH_CASE_1),
    .STIMULUS_NTM_SCALAR_SINH_CASE_1(STIMULUS_NTM_SCALAR_SINH_CASE_1),
    .STIMULUS_NTM_SCALAR_TANH_CASE_1(STIMULUS_NTM_SCALAR_TANH_CASE_1),
    .STIMULUS_NTM_SCALAR_LOGISTIC_CASE_1(STIMULUS_NTM_SCALAR_LOGISTIC_CASE_1),
    .STIMULUS_NTM_SCALAR_ONEPLUS_CASE_1(STIMULUS_NTM_SCALAR_ONEPLUS_CASE_1),

    // VECTOR-FUNCTIONALITY
    .STIMULUS_NTM_VECTOR_COSH_TEST(STIMULUS_NTM_VECTOR_COSH_TEST),
    .STIMULUS_NTM_VECTOR_SINH_TEST(STIMULUS_NTM_VECTOR_SINH_TEST),
    .STIMULUS_NTM_VECTOR_TANH_TEST(STIMULUS_NTM_VECTOR_TANH_TEST),
    .STIMULUS_NTM_VECTOR_LOGISTIC_TEST(STIMULUS_NTM_VECTOR_LOGISTIC_TEST),
    .STIMULUS_NTM_VECTOR_ONEPLUS_TEST(STIMULUS_NTM_VECTOR_ONEPLUS_TEST),
    .STIMULUS_NTM_VECTOR_COSH_CASE_0(STIMULUS_NTM_VECTOR_COSH_CASE_0),
    .STIMULUS_NTM_VECTOR_SINH_CASE_0(STIMULUS_NTM_VECTOR_SINH_CASE_0),
    .STIMULUS_NTM_VECTOR_TANH_CASE_0(STIMULUS_NTM_VECTOR_TANH_CASE_0),
    .STIMULUS_NTM_VECTOR_LOGISTIC_CASE_0(STIMULUS_NTM_VECTOR_LOGISTIC_CASE_0),
    .STIMULUS_NTM_VECTOR_ONEPLUS_CASE_0(STIMULUS_NTM_VECTOR_ONEPLUS_CASE_0),
    .STIMULUS_NTM_VECTOR_COSH_CASE_1(STIMULUS_NTM_VECTOR_COSH_CASE_1),
    .STIMULUS_NTM_VECTOR_SINH_CASE_1(STIMULUS_NTM_VECTOR_SINH_CASE_1),
    .STIMULUS_NTM_VECTOR_TANH_CASE_1(STIMULUS_NTM_VECTOR_TANH_CASE_1),
    .STIMULUS_NTM_VECTOR_LOGISTIC_CASE_1(STIMULUS_NTM_VECTOR_LOGISTIC_CASE_1),
    .STIMULUS_NTM_VECTOR_ONEPLUS_CASE_1(STIMULUS_NTM_VECTOR_ONEPLUS_CASE_1),

    // MATRIX-FUNCTIONALITY
    .STIMULUS_NTM_MATRIX_COSH_TEST(STIMULUS_NTM_MATRIX_COSH_TEST),
    .STIMULUS_NTM_MATRIX_SINH_TEST(STIMULUS_NTM_MATRIX_SINH_TEST),
    .STIMULUS_NTM_MATRIX_TANH_TEST(STIMULUS_NTM_MATRIX_TANH_TEST),
    .STIMULUS_NTM_MATRIX_LOGISTIC_TEST(STIMULUS_NTM_MATRIX_LOGISTIC_TEST),
    .STIMULUS_NTM_MATRIX_ONEPLUS_TEST(STIMULUS_NTM_MATRIX_ONEPLUS_TEST),
    .STIMULUS_NTM_MATRIX_COSH_CASE_0(STIMULUS_NTM_MATRIX_COSH_CASE_0),
    .STIMULUS_NTM_MATRIX_SINH_CASE_0(STIMULUS_NTM_MATRIX_SINH_CASE_0),
    .STIMULUS_NTM_MATRIX_TANH_CASE_0(STIMULUS_NTM_MATRIX_TANH_CASE_0),
    .STIMULUS_NTM_MATRIX_LOGISTIC_CASE_0(STIMULUS_NTM_MATRIX_LOGISTIC_CASE_0),
    .STIMULUS_NTM_MATRIX_ONEPLUS_CASE_0(STIMULUS_NTM_MATRIX_ONEPLUS_CASE_0),
    .STIMULUS_NTM_MATRIX_COSH_CASE_1(STIMULUS_NTM_MATRIX_COSH_CASE_1),
    .STIMULUS_NTM_MATRIX_SINH_CASE_1(STIMULUS_NTM_MATRIX_SINH_CASE_1),
    .STIMULUS_NTM_MATRIX_TANH_CASE_1(STIMULUS_NTM_MATRIX_TANH_CASE_1),
    .STIMULUS_NTM_MATRIX_LOGISTIC_CASE_1(STIMULUS_NTM_MATRIX_LOGISTIC_CASE_1),
    .STIMULUS_NTM_MATRIX_ONEPLUS_CASE_1(STIMULUS_NTM_MATRIX_ONEPLUS_CASE_1)
  )
  function_stimulus(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    ///////////////////////////////////////////////////////////////////////
    // STIMULUS SCALAR
    ///////////////////////////////////////////////////////////////////////

    // SCALAR COSH
    // CONTROL
    .SCALAR_COSH_START(start_scalar_cosh),
    .SCALAR_COSH_READY(ready_scalar_cosh),

    // DATA
    .SCALAR_COSH_DATA_IN(data_in_scalar_cosh),
    .SCALAR_COSH_DATA_OUT(data_out_scalar_cosh),

    // SCALAR SINH
    // CONTROL
    .SCALAR_SINH_START(start_scalar_sinh),
    .SCALAR_SINH_READY(ready_scalar_sinh),

    // DATA
    .SCALAR_SINH_DATA_IN(data_in_scalar_sinh),
    .SCALAR_SINH_DATA_OUT(data_out_scalar_sinh),

    // SCALAR TANH
    // CONTROL
    .SCALAR_TANH_START(start_scalar_tanh),
    .SCALAR_TANH_READY(ready_scalar_tanh),

    // DATA
    .SCALAR_TANH_DATA_IN(data_in_scalar_tanh),
    .SCALAR_TANH_DATA_OUT(data_out_scalar_tanh),

    // SCALAR LOGISTIC
    // CONTROL
    .SCALAR_LOGISTIC_START(start_scalar_logistic),
    .SCALAR_LOGISTIC_READY(ready_scalar_logistic),

    // DATA
    .SCALAR_LOGISTIC_DATA_IN(data_in_scalar_logistic),
    .SCALAR_LOGISTIC_DATA_OUT(data_out_scalar_logistic),

    // SCALAR ONEPLUS
    // CONTROL
    .SCALAR_ONEPLUS_START(start_scalar_oneplus),
    .SCALAR_ONEPLUS_READY(ready_scalar_oneplus),

    // DATA
    .SCALAR_ONEPLUS_DATA_IN(data_in_scalar_oneplus),
    .SCALAR_ONEPLUS_DATA_OUT(data_out_scalar_oneplus),

    ///////////////////////////////////////////////////////////////////////
    // STIMULUS VECTOR
    ///////////////////////////////////////////////////////////////////////

    // VECTOR COSH
    // CONTROL
    .VECTOR_COSH_START(start_vector_cosh),
    .VECTOR_COSH_READY(ready_vector_cosh),

    .VECTOR_COSH_DATA_IN_ENABLE(data_in_enable_vector_cosh),
    .VECTOR_COSH_DATA_OUT_ENABLE(data_out_enable_vector_cosh),

    // DATA
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
    .VECTOR_TANH_SIZE_IN(size_in_vector_tanh),
    .VECTOR_TANH_DATA_IN(data_in_vector_tanh),
    .VECTOR_TANH_DATA_OUT(data_out_vector_tanh),

    // VECTOR LOGISTIC
    // CONTROL
    .VECTOR_LOGISTIC_START(start_vector_logistic),
    .VECTOR_LOGISTIC_READY(ready_vector_logistic),

    .VECTOR_LOGISTIC_DATA_IN_ENABLE(data_in_enable_vector_logistic),
    .VECTOR_LOGISTIC_DATA_OUT_ENABLE(data_out_enable_vector_logistic),

    // DATA
    .VECTOR_LOGISTIC_SIZE_IN(size_in_vector_logistic),
    .VECTOR_LOGISTIC_DATA_IN(data_in_vector_logistic),
    .VECTOR_LOGISTIC_DATA_OUT(data_out_vector_logistic),

    // VECTOR ONEPLUS
    // CONTROL
    .VECTOR_ONEPLUS_START(start_vector_oneplus),
    .VECTOR_ONEPLUS_READY(ready_vector_oneplus),

    .VECTOR_ONEPLUS_DATA_IN_ENABLE(data_in_enable_vector_oneplus),
    .VECTOR_ONEPLUS_DATA_OUT_ENABLE(data_out_enable_vector_oneplus),

    // DATA
    .VECTOR_ONEPLUS_SIZE_IN(size_in_vector_oneplus),
    .VECTOR_ONEPLUS_DATA_IN(data_in_vector_oneplus),
    .VECTOR_ONEPLUS_DATA_OUT(data_out_vector_oneplus),

    ///////////////////////////////////////////////////////////////////////
    // STIMULUS MATRIX
    ///////////////////////////////////////////////////////////////////////

    // MATRIX COSH
    // CONTROL
    .MATRIX_COSH_START(start_matrix_cosh),
    .MATRIX_COSH_READY(ready_matrix_cosh),

    .MATRIX_COSH_DATA_IN_I_ENABLE(data_in_i_enable_matrix_cosh),
    .MATRIX_COSH_DATA_IN_J_ENABLE(data_in_j_enable_matrix_cosh),
    .MATRIX_COSH_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_cosh),
    .MATRIX_COSH_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_cosh),

    // DATA
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
    .MATRIX_LOGISTIC_SIZE_I_IN(size_i_in_matrix_logistic),
    .MATRIX_LOGISTIC_SIZE_J_IN(size_j_in_matrix_logistic),
    .MATRIX_LOGISTIC_DATA_IN(data_in_matrix_logistic),
    .MATRIX_LOGISTIC_DATA_OUT(data_out_matrix_logistic),

    // MATRIX ONEPLUS
    // CONTROL
    .MATRIX_ONEPLUS_START(start_matrix_oneplus),
    .MATRIX_ONEPLUS_READY(ready_matrix_oneplus),

    .MATRIX_ONEPLUS_DATA_IN_I_ENABLE(data_in_i_enable_matrix_oneplus),
    .MATRIX_ONEPLUS_DATA_IN_J_ENABLE(data_in_j_enable_matrix_oneplus),
    .MATRIX_ONEPLUS_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_oneplus),
    .MATRIX_ONEPLUS_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_oneplus),

    // DATA
    .MATRIX_ONEPLUS_SIZE_I_IN(size_i_in_matrix_oneplus),
    .MATRIX_ONEPLUS_SIZE_J_IN(size_j_in_matrix_oneplus),
    .MATRIX_ONEPLUS_DATA_IN(data_in_matrix_oneplus),
    .MATRIX_ONEPLUS_DATA_OUT(data_out_matrix_oneplus)
  );

  ///////////////////////////////////////////////////////////////////////
  // SCALAR
  ///////////////////////////////////////////////////////////////////////

  // SCALAR COSH
  ntm_scalar_cosh_function #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  )
  scalar_cosh_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_cosh),
    .READY(ready_scalar_cosh),

    // DATA
    .DATA_IN(data_in_scalar_cosh),
    .DATA_OUT(data_out_scalar_cosh)
  );

  // SCALAR SINH
  ntm_scalar_sinh_function #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  )
  scalar_sinh_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_sinh),
    .READY(ready_scalar_sinh),

    // DATA
    .DATA_IN(data_in_scalar_sinh),
    .DATA_OUT(data_out_scalar_sinh)
  );

  // SCALAR TANH
  ntm_scalar_tanh_function #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  )
  scalar_tanh_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_tanh),
    .READY(ready_scalar_tanh),

    // DATA
    .DATA_IN(data_in_scalar_tanh),
    .DATA_OUT(data_out_scalar_tanh)
  );

  // SCALAR LOGISTIC
  ntm_scalar_logistic_function #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  )
  scalar_logistic_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_logistic),
    .READY(ready_scalar_logistic),

    // DATA
    .DATA_IN(data_in_scalar_logistic),
    .DATA_OUT(data_out_scalar_logistic)
  );

  // SCALAR ONEPLUS
  ntm_scalar_oneplus_function #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  )
  scalar_oneplus_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_oneplus),
    .READY(ready_scalar_oneplus),

    // DATA
    .DATA_IN(data_in_scalar_oneplus),
    .DATA_OUT(data_out_scalar_oneplus)
  );

  ///////////////////////////////////////////////////////////////////////
  // VECTOR
  ///////////////////////////////////////////////////////////////////////

  // VECTOR COSH
  ntm_vector_cosh_function #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
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
    .SIZE_IN(size_in_vector_cosh),
    .DATA_IN(data_in_vector_cosh),
    .DATA_OUT(data_out_vector_cosh)
  );

  // VECTOR SINH
  ntm_vector_sinh_function #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
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
    .SIZE_IN(size_in_vector_sinh),
    .DATA_IN(data_in_vector_sinh),
    .DATA_OUT(data_out_vector_sinh)
  );

  // VECTOR TANH
  ntm_vector_tanh_function #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
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
    .SIZE_IN(size_in_vector_tanh),
    .DATA_IN(data_in_vector_tanh),
    .DATA_OUT(data_out_vector_tanh)
  );

  // VECTOR LOGISTIC
  ntm_vector_logistic_function #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
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
    .SIZE_IN(size_in_vector_logistic),
    .DATA_IN(data_in_vector_logistic),
    .DATA_OUT(data_out_vector_logistic)
  );

  // VECTOR ONEPLUS
  ntm_vector_oneplus_function #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
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
    .SIZE_IN(size_in_vector_oneplus),
    .DATA_IN(data_in_vector_oneplus),
    .DATA_OUT(data_out_vector_oneplus)
  );

  ///////////////////////////////////////////////////////////////////////
  // MATRIX
  ///////////////////////////////////////////////////////////////////////

  // MATRIX COSH
  ntm_matrix_cosh_function #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
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
    .SIZE_I_IN(size_i_in_matrix_cosh),
    .SIZE_J_IN(size_j_in_matrix_cosh),
    .DATA_IN(data_in_matrix_cosh),
    .DATA_OUT(data_out_matrix_cosh)
  );

  // MATRIX SINH
  ntm_matrix_sinh_function #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
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
    .SIZE_I_IN(size_i_in_matrix_sinh),
    .SIZE_J_IN(size_j_in_matrix_sinh),
    .DATA_IN(data_in_matrix_sinh),
    .DATA_OUT(data_out_matrix_sinh)
  );

  // MATRIX TANH
  ntm_matrix_tanh_function #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
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
    .SIZE_I_IN(size_i_in_matrix_tanh),
    .SIZE_J_IN(size_j_in_matrix_tanh),
    .DATA_IN(data_in_matrix_tanh),
    .DATA_OUT(data_out_matrix_tanh)
  );

  // MATRIX LOGISTIC
  ntm_matrix_logistic_function #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
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
    .SIZE_I_IN(size_i_in_matrix_logistic),
    .SIZE_J_IN(size_j_in_matrix_logistic),
    .DATA_IN(data_in_matrix_logistic),
    .DATA_OUT(data_out_matrix_logistic)
  );

  // MATRIX ONEPLUS
  ntm_matrix_oneplus_function #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
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
    .SIZE_I_IN(size_i_in_matrix_oneplus),
    .SIZE_J_IN(size_j_in_matrix_oneplus),
    .DATA_IN(data_in_matrix_oneplus),
    .DATA_OUT(data_out_matrix_oneplus)
  );

endmodule
