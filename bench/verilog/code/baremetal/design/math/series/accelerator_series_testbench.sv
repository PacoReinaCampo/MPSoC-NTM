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

module accelerator_function_testbench;

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  // SYSTEM-SIZE
  parameter DATA_SIZE = 64;
  parameter CONTROL_SIZE = 64;

  parameter X = 64;
  parameter Y = 64;
  parameter N = 64;
  parameter W = 64;
  parameter L = 64;
  parameter R = 64;

  // SCALAR-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_SCALAR_COSH_TEST = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_SINH_TEST = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_TANH_TEST = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_EXPONENTIATOR_TEST = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_LOGARITHM_TEST = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_COSH_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_SINH_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_TANH_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_EXPONENTIATOR_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_LOGARITHM_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_COSH_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_SINH_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_TANH_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_EXPONENTIATOR_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_LOGARITHM_CASE_1 = 0;

  // VECTOR-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_VECTOR_COSH_TEST = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_SINH_TEST = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_TANH_TEST = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_EXPONENTIATOR_TEST = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_LOGARITHM_TEST = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_COSH_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_SINH_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_TANH_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_EXPONENTIATOR_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_LOGARITHM_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_COSH_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_SINH_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_TANH_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_EXPONENTIATOR_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_LOGARITHM_CASE_1 = 0;

  // MATRIX-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_MATRIX_COSH_TEST = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_SINH_TEST = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_TANH_TEST = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_EXPONENTIATOR_TEST = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_LOGARITHM_TEST = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_COSH_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_SINH_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_TANH_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_EXPONENTIATOR_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_LOGARITHM_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_COSH_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_SINH_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_TANH_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_EXPONENTIATOR_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_LOGARITHM_CASE_1 = 0;

  //////////////////////////////////////////////////////////////////////////////
  // Signals
  //////////////////////////////////////////////////////////////////////////////

  // GLOBAL
  wire                 CLK;
  wire                 RST;

  //////////////////////////////////////////////////////////////////////////////
  // SCALAR
  //////////////////////////////////////////////////////////////////////////////

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
  wire                 start_scalar_cosh;
  wire                 ready_scalar_cosh;

  // DATA
  wire [DATA_SIZE-1:0] data_in_scalar_cosh;
  wire [DATA_SIZE-1:0] data_out_scalar_cosh;

  // SCALAR SINH
  // CONTROL
  wire                 start_scalar_sinh;
  wire                 ready_scalar_sinh;

  // DATA
  wire [DATA_SIZE-1:0] data_in_scalar_sinh;
  wire [DATA_SIZE-1:0] data_out_scalar_sinh;

  // SCALAR TANH
  // CONTROL
  wire                 start_scalar_tanh;
  wire                 ready_scalar_tanh;

  // DATA
  wire [DATA_SIZE-1:0] data_in_scalar_tanh;
  wire [DATA_SIZE-1:0] data_out_scalar_tanh;

  // SCALAR EXPONENTIATOR
  // CONTROL
  wire                 start_scalar_exponentiator;
  wire                 ready_scalar_exponentiator;

  // DATA
  wire [DATA_SIZE-1:0] data_in_scalar_exponentiator;
  wire [DATA_SIZE-1:0] data_out_scalar_exponentiator;

  // CONTROL


  // DATA

  // SCALAR LOGARITHM
  // CONTROL
  wire                 start_scalar_logarithm;
  wire                 ready_scalar_logarithm;

  // DATA
  wire [DATA_SIZE-1:0] data_in_scalar_logarithm;
  wire [DATA_SIZE-1:0] data_out_scalar_logarithm;

  // CONTROL


  // DATA

  //////////////////////////////////////////////////////////////////////////////
  // VECTOR
  //////////////////////////////////////////////////////////////////////////////

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
  wire                 start_vector_cosh;
  wire                 ready_vector_cosh;

  wire                 data_in_enable_vector_cosh;
  wire                 data_out_enable_vector_cosh;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_cosh;
  wire [DATA_SIZE-1:0] data_in_vector_cosh;
  wire [DATA_SIZE-1:0] data_out_vector_cosh;

  // VECTOR SINH
  // CONTROL
  wire                 start_vector_sinh;
  wire                 ready_vector_sinh;

  wire                 data_in_enable_vector_sinh;
  wire                 data_out_enable_vector_sinh;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_sinh;
  wire [DATA_SIZE-1:0] data_in_vector_sinh;
  wire [DATA_SIZE-1:0] data_out_vector_sinh;

  // VECTOR TANH
  // CONTROL
  wire                 start_vector_tanh;
  wire                 ready_vector_tanh;

  wire                 data_in_enable_vector_tanh;
  wire                 data_out_enable_vector_tanh;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_tanh;
  wire [DATA_SIZE-1:0] data_in_vector_tanh;
  wire [DATA_SIZE-1:0] data_out_vector_tanh;

  // VECTOR EXPONENTIATOR
  // CONTROL
  wire                 start_vector_exponentiator;
  wire                 ready_vector_exponentiator;

  wire                 data_in_enable_vector_exponentiator;
  wire                 data_out_enable_vector_exponentiator;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_exponentiator;
  wire [DATA_SIZE-1:0] data_in_vector_exponentiator;
  wire [DATA_SIZE-1:0] data_out_vector_exponentiator;

  // CONTROL



  // DATA

  // VECTOR LOGARITHM
  // CONTROL
  wire                 start_vector_logarithm;
  wire                 ready_vector_logarithm;

  wire                 data_in_enable_vector_logarithm;
  wire                 data_out_enable_vector_logarithm;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_logarithm;
  wire [DATA_SIZE-1:0] data_in_vector_logarithm;
  wire [DATA_SIZE-1:0] data_out_vector_logarithm;

  // CONTROL


  // DATA

  //////////////////////////////////////////////////////////////////////////////
  // MATRIX
  //////////////////////////////////////////////////////////////////////////////

  // MATRIX COSH
  // CONTROL
  wire                 start_matrix_cosh;
  wire                 ready_matrix_cosh;

  wire                 data_in_i_enable_matrix_cosh;
  wire                 data_in_j_enable_matrix_cosh;
  wire                 data_out_i_enable_matrix_cosh;
  wire                 data_out_j_enable_matrix_cosh;

  // DATA
  wire [DATA_SIZE-1:0] size_i_in_matrix_cosh;
  wire [DATA_SIZE-1:0] size_j_in_matrix_cosh;
  wire [DATA_SIZE-1:0] data_in_matrix_cosh;
  wire [DATA_SIZE-1:0] data_out_matrix_cosh;

  // MATRIX SINH
  // CONTROL
  wire                 start_matrix_sinh;
  wire                 ready_matrix_sinh;

  wire                 data_in_i_enable_matrix_sinh;
  wire                 data_in_j_enable_matrix_sinh;
  wire                 data_out_i_enable_matrix_sinh;
  wire                 data_out_j_enable_matrix_sinh;

  // DATA
  wire [DATA_SIZE-1:0] size_i_in_matrix_sinh;
  wire [DATA_SIZE-1:0] size_j_in_matrix_sinh;
  wire [DATA_SIZE-1:0] data_in_matrix_sinh;
  wire [DATA_SIZE-1:0] data_out_matrix_sinh;

  // MATRIX TANH
  // CONTROL
  wire                 start_matrix_tanh;
  wire                 ready_matrix_tanh;

  wire                 data_in_i_enable_matrix_tanh;
  wire                 data_in_j_enable_matrix_tanh;
  wire                 data_out_i_enable_matrix_tanh;
  wire                 data_out_j_enable_matrix_tanh;

  // DATA
  wire [DATA_SIZE-1:0] size_i_in_matrix_tanh;
  wire [DATA_SIZE-1:0] size_j_in_matrix_tanh;
  wire [DATA_SIZE-1:0] data_in_matrix_tanh;
  wire [DATA_SIZE-1:0] data_out_matrix_tanh;

  // MATRIX EXPONENTIATOR
  // CONTROL
  wire                 start_matrix_exponentiator;
  wire                 ready_matrix_exponentiator;

  wire                 data_in_i_enable_matrix_exponentiator;
  wire                 data_in_j_enable_matrix_exponentiator;
  wire                 data_out_i_enable_matrix_exponentiator;
  wire                 data_out_j_enable_matrix_exponentiator;

  // DATA
  wire [DATA_SIZE-1:0] size_i_in_matrix_exponentiator;
  wire [DATA_SIZE-1:0] size_j_in_matrix_exponentiator;
  wire [DATA_SIZE-1:0] data_in_matrix_exponentiator;
  wire [DATA_SIZE-1:0] data_out_matrix_exponentiator;

  // CONTROL



  // DATA

  // MATRIX LOGARITHM
  // CONTROL
  wire                 start_matrix_logarithm;
  wire                 ready_matrix_logarithm;

  wire                 data_in_i_enable_matrix_logarithm;
  wire                 data_in_j_enable_matrix_logarithm;
  wire                 data_out_i_enable_matrix_logarithm;
  wire                 data_out_j_enable_matrix_logarithm;

  // DATA
  wire [DATA_SIZE-1:0] size_i_in_matrix_logarithm;
  wire [DATA_SIZE-1:0] size_j_in_matrix_logarithm;
  wire [DATA_SIZE-1:0] data_in_matrix_logarithm;
  wire [DATA_SIZE-1:0] data_out_matrix_logarithm;

  // CONTROL


  // DATA

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////
  accelerator_function_stimulus #(
    // SYSTEM-SIZE
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE),

    .X(X),
    .Y(Y),
    .N(N),
    .W(W),
    .L(L),
    .R(R),

    // SCALAR-FUNCTIONALITY
    .STIMULUS_ACCELERATOR_SCALAR_COSH_TEST           (STIMULUS_ACCELERATOR_SCALAR_COSH_TEST),
    .STIMULUS_ACCELERATOR_SCALAR_SINH_TEST           (STIMULUS_ACCELERATOR_SCALAR_SINH_TEST),
    .STIMULUS_ACCELERATOR_SCALAR_TANH_TEST           (STIMULUS_ACCELERATOR_SCALAR_TANH_TEST),
    .STIMULUS_ACCELERATOR_SCALAR_EXPONENTIATOR_TEST  (STIMULUS_ACCELERATOR_SCALAR_EXPONENTIATOR_TEST),
    .STIMULUS_ACCELERATOR_SCALAR_LOGARITHM_TEST      (STIMULUS_ACCELERATOR_SCALAR_LOGARITHM_TEST),
    .STIMULUS_ACCELERATOR_SCALAR_COSH_CASE_0         (STIMULUS_ACCELERATOR_SCALAR_COSH_CASE_0),
    .STIMULUS_ACCELERATOR_SCALAR_SINH_CASE_0         (STIMULUS_ACCELERATOR_SCALAR_SINH_CASE_0),
    .STIMULUS_ACCELERATOR_SCALAR_TANH_CASE_0         (STIMULUS_ACCELERATOR_SCALAR_TANH_CASE_0),
    .STIMULUS_ACCELERATOR_SCALAR_EXPONENTIATOR_CASE_0(STIMULUS_ACCELERATOR_SCALAR_EXPONENTIATOR_CASE_0),
    .STIMULUS_ACCELERATOR_SCALAR_LOGARITHM_CASE_0    (STIMULUS_ACCELERATOR_SCALAR_LOGARITHM_CASE_0),
    .STIMULUS_ACCELERATOR_SCALAR_COSH_CASE_1         (STIMULUS_ACCELERATOR_SCALAR_COSH_CASE_1),
    .STIMULUS_ACCELERATOR_SCALAR_SINH_CASE_1         (STIMULUS_ACCELERATOR_SCALAR_SINH_CASE_1),
    .STIMULUS_ACCELERATOR_SCALAR_TANH_CASE_1         (STIMULUS_ACCELERATOR_SCALAR_TANH_CASE_1),
    .STIMULUS_ACCELERATOR_SCALAR_EXPONENTIATOR_CASE_1(STIMULUS_ACCELERATOR_SCALAR_EXPONENTIATOR_CASE_1),
    .STIMULUS_ACCELERATOR_SCALAR_LOGARITHM_CASE_1    (STIMULUS_ACCELERATOR_SCALAR_LOGARITHM_CASE_1),

    // VECTOR-FUNCTIONALITY
    .STIMULUS_ACCELERATOR_VECTOR_COSH_TEST           (STIMULUS_ACCELERATOR_VECTOR_COSH_TEST),
    .STIMULUS_ACCELERATOR_VECTOR_SINH_TEST           (STIMULUS_ACCELERATOR_VECTOR_SINH_TEST),
    .STIMULUS_ACCELERATOR_VECTOR_TANH_TEST           (STIMULUS_ACCELERATOR_VECTOR_TANH_TEST),
    .STIMULUS_ACCELERATOR_VECTOR_EXPONENTIATOR_TEST  (STIMULUS_ACCELERATOR_VECTOR_EXPONENTIATOR_TEST),
    .STIMULUS_ACCELERATOR_VECTOR_LOGARITHM_TEST      (STIMULUS_ACCELERATOR_VECTOR_LOGARITHM_TEST),
    .STIMULUS_ACCELERATOR_VECTOR_COSH_CASE_0         (STIMULUS_ACCELERATOR_VECTOR_COSH_CASE_0),
    .STIMULUS_ACCELERATOR_VECTOR_SINH_CASE_0         (STIMULUS_ACCELERATOR_VECTOR_SINH_CASE_0),
    .STIMULUS_ACCELERATOR_VECTOR_TANH_CASE_0         (STIMULUS_ACCELERATOR_VECTOR_TANH_CASE_0),
    .STIMULUS_ACCELERATOR_VECTOR_EXPONENTIATOR_CASE_0(STIMULUS_ACCELERATOR_VECTOR_EXPONENTIATOR_CASE_0),
    .STIMULUS_ACCELERATOR_VECTOR_LOGARITHM_CASE_0    (STIMULUS_ACCELERATOR_VECTOR_LOGARITHM_CASE_0),
    .STIMULUS_ACCELERATOR_VECTOR_COSH_CASE_1         (STIMULUS_ACCELERATOR_VECTOR_COSH_CASE_1),
    .STIMULUS_ACCELERATOR_VECTOR_SINH_CASE_1         (STIMULUS_ACCELERATOR_VECTOR_SINH_CASE_1),
    .STIMULUS_ACCELERATOR_VECTOR_TANH_CASE_1         (STIMULUS_ACCELERATOR_VECTOR_TANH_CASE_1),
    .STIMULUS_ACCELERATOR_VECTOR_EXPONENTIATOR_CASE_1(STIMULUS_ACCELERATOR_VECTOR_EXPONENTIATOR_CASE_1),
    .STIMULUS_ACCELERATOR_VECTOR_LOGARITHM_CASE_1    (STIMULUS_ACCELERATOR_VECTOR_LOGARITHM_CASE_1),

    // MATRIX-FUNCTIONALITY
    .STIMULUS_ACCELERATOR_MATRIX_COSH_TEST           (STIMULUS_ACCELERATOR_MATRIX_COSH_TEST),
    .STIMULUS_ACCELERATOR_MATRIX_SINH_TEST           (STIMULUS_ACCELERATOR_MATRIX_SINH_TEST),
    .STIMULUS_ACCELERATOR_MATRIX_TANH_TEST           (STIMULUS_ACCELERATOR_MATRIX_TANH_TEST),
    .STIMULUS_ACCELERATOR_MATRIX_EXPONENTIATOR_TEST  (STIMULUS_ACCELERATOR_MATRIX_EXPONENTIATOR_TEST),
    .STIMULUS_ACCELERATOR_MATRIX_LOGARITHM_TEST      (STIMULUS_ACCELERATOR_MATRIX_LOGARITHM_TEST),
    .STIMULUS_ACCELERATOR_MATRIX_COSH_CASE_0         (STIMULUS_ACCELERATOR_MATRIX_COSH_CASE_0),
    .STIMULUS_ACCELERATOR_MATRIX_SINH_CASE_0         (STIMULUS_ACCELERATOR_MATRIX_SINH_CASE_0),
    .STIMULUS_ACCELERATOR_MATRIX_TANH_CASE_0         (STIMULUS_ACCELERATOR_MATRIX_TANH_CASE_0),
    .STIMULUS_ACCELERATOR_MATRIX_EXPONENTIATOR_CASE_0(STIMULUS_ACCELERATOR_MATRIX_EXPONENTIATOR_CASE_0),
    .STIMULUS_ACCELERATOR_MATRIX_LOGARITHM_CASE_0    (STIMULUS_ACCELERATOR_MATRIX_LOGARITHM_CASE_0),
    .STIMULUS_ACCELERATOR_MATRIX_COSH_CASE_1         (STIMULUS_ACCELERATOR_MATRIX_COSH_CASE_1),
    .STIMULUS_ACCELERATOR_MATRIX_SINH_CASE_1         (STIMULUS_ACCELERATOR_MATRIX_SINH_CASE_1),
    .STIMULUS_ACCELERATOR_MATRIX_TANH_CASE_1         (STIMULUS_ACCELERATOR_MATRIX_TANH_CASE_1),
    .STIMULUS_ACCELERATOR_MATRIX_EXPONENTIATOR_CASE_1(STIMULUS_ACCELERATOR_MATRIX_EXPONENTIATOR_CASE_1),
    .STIMULUS_ACCELERATOR_MATRIX_LOGARITHM_CASE_1    (STIMULUS_ACCELERATOR_MATRIX_LOGARITHM_CASE_1)
  ) function_stimulus (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    //////////////////////////////////////////////////////////////////////////////
    // STIMULUS SCALAR
    //////////////////////////////////////////////////////////////////////////////

    // SCALAR COSH
    // CONTROL
    .SCALAR_COSH_START(start_scalar_cosh),
    .SCALAR_COSH_READY(ready_scalar_cosh),

    // DATA
    .SCALAR_COSH_DATA_IN (data_in_scalar_cosh),
    .SCALAR_COSH_DATA_OUT(data_out_scalar_cosh),

    // SCALAR SINH
    // CONTROL
    .SCALAR_SINH_START(start_scalar_sinh),
    .SCALAR_SINH_READY(ready_scalar_sinh),

    // DATA
    .SCALAR_SINH_DATA_IN (data_in_scalar_sinh),
    .SCALAR_SINH_DATA_OUT(data_out_scalar_sinh),

    // SCALAR TANH
    // CONTROL
    .SCALAR_TANH_START(start_scalar_tanh),
    .SCALAR_TANH_READY(ready_scalar_tanh),

    // DATA
    .SCALAR_TANH_DATA_IN (data_in_scalar_tanh),
    .SCALAR_TANH_DATA_OUT(data_out_scalar_tanh),

    // SCALAR EXPONENTIATOR
    // CONTROL
    .SCALAR_EXPONENTIATOR_START(start_scalar_exponentiator),
    .SCALAR_EXPONENTIATOR_READY(ready_scalar_exponentiator),

    // DATA
    .SCALAR_EXPONENTIATOR_DATA_IN (data_in_scalar_exponentiator),
    .SCALAR_EXPONENTIATOR_DATA_OUT(data_out_scalar_exponentiator),

    // SCALAR LOGARITHM
    // CONTROL
    .SCALAR_LOGARITHM_START(start_scalar_logarithm),
    .SCALAR_LOGARITHM_READY(ready_scalar_logarithm),

    // DATA
    .SCALAR_LOGARITHM_DATA_IN (data_in_scalar_logarithm),
    .SCALAR_LOGARITHM_DATA_OUT(data_out_scalar_logarithm),

    //////////////////////////////////////////////////////////////////////////////
    // STIMULUS VECTOR
    //////////////////////////////////////////////////////////////////////////////

    // VECTOR COSH
    // CONTROL
    .VECTOR_COSH_START(start_vector_cosh),
    .VECTOR_COSH_READY(ready_vector_cosh),

    .VECTOR_COSH_DATA_IN_ENABLE (data_in_enable_vector_cosh),
    .VECTOR_COSH_DATA_OUT_ENABLE(data_out_enable_vector_cosh),

    // DATA
    .VECTOR_COSH_SIZE_IN (size_in_vector_cosh),
    .VECTOR_COSH_DATA_IN (data_in_vector_cosh),
    .VECTOR_COSH_DATA_OUT(data_out_vector_cosh),

    // VECTOR SINH
    // CONTROL
    .VECTOR_SINH_START(start_vector_sinh),
    .VECTOR_SINH_READY(ready_vector_sinh),

    .VECTOR_SINH_DATA_IN_ENABLE (data_in_enable_vector_sinh),
    .VECTOR_SINH_DATA_OUT_ENABLE(data_out_enable_vector_sinh),

    // DATA
    .VECTOR_SINH_SIZE_IN (size_in_vector_sinh),
    .VECTOR_SINH_DATA_IN (data_in_vector_sinh),
    .VECTOR_SINH_DATA_OUT(data_out_vector_sinh),

    // VECTOR TANH
    // CONTROL
    .VECTOR_TANH_START          (start_vector_tanh),
    .VECTOR_TANH_READY          (ready_vector_tanh),
    .VECTOR_TANH_DATA_IN_ENABLE (data_in_enable_vector_tanh),
    .VECTOR_TANH_DATA_OUT_ENABLE(data_out_enable_vector_tanh),

    // DATA
    .VECTOR_TANH_SIZE_IN (size_in_vector_tanh),
    .VECTOR_TANH_DATA_IN (data_in_vector_tanh),
    .VECTOR_TANH_DATA_OUT(data_out_vector_tanh),

    // VECTOR EXPONENTIATOR
    // CONTROL
    .VECTOR_EXPONENTIATOR_START(start_vector_exponentiator),
    .VECTOR_EXPONENTIATOR_READY(ready_vector_exponentiator),

    .VECTOR_EXPONENTIATOR_DATA_IN_ENABLE (data_in_enable_vector_exponentiator),
    .VECTOR_EXPONENTIATOR_DATA_OUT_ENABLE(data_out_enable_vector_exponentiator),

    // DATA
    .VECTOR_EXPONENTIATOR_SIZE_IN (size_in_vector_exponentiator),
    .VECTOR_EXPONENTIATOR_DATA_IN (data_in_vector_exponentiator),
    .VECTOR_EXPONENTIATOR_DATA_OUT(data_out_vector_exponentiator),

    // VECTOR LOGARITHM
    // CONTROL
    .VECTOR_LOGARITHM_START(start_vector_logarithm),
    .VECTOR_LOGARITHM_READY(ready_vector_logarithm),

    .VECTOR_LOGARITHM_DATA_IN_ENABLE (data_in_enable_vector_logarithm),
    .VECTOR_LOGARITHM_DATA_OUT_ENABLE(data_out_enable_vector_logarithm),

    // DATA
    .VECTOR_LOGARITHM_SIZE_IN (size_in_vector_logarithm),
    .VECTOR_LOGARITHM_DATA_IN (data_in_vector_logarithm),
    .VECTOR_LOGARITHM_DATA_OUT(data_out_vector_logarithm),

    //////////////////////////////////////////////////////////////////////////////
    // STIMULUS MATRIX
    //////////////////////////////////////////////////////////////////////////////

    // MATRIX COSH
    // CONTROL
    .MATRIX_COSH_START(start_matrix_cosh),
    .MATRIX_COSH_READY(ready_matrix_cosh),

    .MATRIX_COSH_DATA_IN_I_ENABLE (data_in_i_enable_matrix_cosh),
    .MATRIX_COSH_DATA_IN_J_ENABLE (data_in_j_enable_matrix_cosh),
    .MATRIX_COSH_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_cosh),
    .MATRIX_COSH_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_cosh),

    // DATA
    .MATRIX_COSH_SIZE_I_IN(size_i_in_matrix_cosh),
    .MATRIX_COSH_SIZE_J_IN(size_j_in_matrix_cosh),
    .MATRIX_COSH_DATA_IN  (data_in_matrix_cosh),
    .MATRIX_COSH_DATA_OUT (data_out_matrix_cosh),

    // MATRIX SINH
    // CONTROL
    .MATRIX_SINH_START(start_matrix_sinh),
    .MATRIX_SINH_READY(ready_matrix_sinh),

    .MATRIX_SINH_DATA_IN_I_ENABLE (data_in_i_enable_matrix_sinh),
    .MATRIX_SINH_DATA_IN_J_ENABLE (data_in_j_enable_matrix_sinh),
    .MATRIX_SINH_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_sinh),
    .MATRIX_SINH_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_sinh),

    // DATA
    .MATRIX_SINH_SIZE_I_IN(size_i_in_matrix_sinh),
    .MATRIX_SINH_SIZE_J_IN(size_j_in_matrix_sinh),
    .MATRIX_SINH_DATA_IN  (data_in_matrix_sinh),
    .MATRIX_SINH_DATA_OUT (data_out_matrix_sinh),

    // MATRIX TANH
    // CONTROL
    .MATRIX_TANH_START(start_matrix_tanh),
    .MATRIX_TANH_READY(ready_matrix_tanh),

    .MATRIX_TANH_DATA_IN_I_ENABLE (data_in_i_enable_matrix_tanh),
    .MATRIX_TANH_DATA_IN_J_ENABLE (data_in_j_enable_matrix_tanh),
    .MATRIX_TANH_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_tanh),
    .MATRIX_TANH_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_tanh),

    // DATA
    .MATRIX_TANH_SIZE_I_IN(size_i_in_matrix_tanh),
    .MATRIX_TANH_SIZE_J_IN(size_j_in_matrix_tanh),
    .MATRIX_TANH_DATA_IN  (data_in_matrix_tanh),
    .MATRIX_TANH_DATA_OUT (data_out_matrix_tanh),

    // MATRIX EXPONENTIATOR
    // CONTROL
    .MATRIX_EXPONENTIATOR_START(start_matrix_exponentiator),
    .MATRIX_EXPONENTIATOR_READY(ready_matrix_exponentiator),

    .MATRIX_EXPONENTIATOR_DATA_IN_I_ENABLE (data_in_i_enable_matrix_exponentiator),
    .MATRIX_EXPONENTIATOR_DATA_IN_J_ENABLE (data_in_j_enable_matrix_exponentiator),
    .MATRIX_EXPONENTIATOR_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_exponentiator),
    .MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_exponentiator),

    // DATA
    .MATRIX_EXPONENTIATOR_SIZE_I_IN(size_i_in_matrix_exponentiator),
    .MATRIX_EXPONENTIATOR_SIZE_J_IN(size_j_in_matrix_exponentiator),
    .MATRIX_EXPONENTIATOR_DATA_IN  (data_in_matrix_exponentiator),
    .MATRIX_EXPONENTIATOR_DATA_OUT (data_out_matrix_exponentiator),

    // MATRIX LOGARITHM
    // CONTROL
    .MATRIX_LOGARITHM_START(start_matrix_logarithm),
    .MATRIX_LOGARITHM_READY(ready_matrix_logarithm),

    .MATRIX_LOGARITHM_DATA_IN_I_ENABLE (data_in_i_enable_matrix_logarithm),
    .MATRIX_LOGARITHM_DATA_IN_J_ENABLE (data_in_j_enable_matrix_logarithm),
    .MATRIX_LOGARITHM_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_logarithm),
    .MATRIX_LOGARITHM_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_logarithm),

    // DATA
    .MATRIX_LOGARITHM_SIZE_I_IN(size_i_in_matrix_logarithm),
    .MATRIX_LOGARITHM_SIZE_J_IN(size_j_in_matrix_logarithm),
    .MATRIX_LOGARITHM_DATA_IN  (data_in_matrix_logarithm),
    .MATRIX_LOGARITHM_DATA_OUT (data_out_matrix_logarithm)
  );

  //////////////////////////////////////////////////////////////////////////////
  // SCALAR
  //////////////////////////////////////////////////////////////////////////////

  // SCALAR COSH
  accelerator_scalar_cosh_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_cosh_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_cosh),
    .READY(ready_scalar_cosh),

    // DATA
    .DATA_IN (data_in_scalar_cosh),
    .DATA_OUT(data_out_scalar_cosh)
  );

  // SCALAR SINH
  accelerator_scalar_sinh_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_sinh_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_sinh),
    .READY(ready_scalar_sinh),

    // DATA
    .DATA_IN (data_in_scalar_sinh),
    .DATA_OUT(data_out_scalar_sinh)
  );

  // SCALAR TANH
  accelerator_scalar_tanh_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_tanh_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_tanh),
    .READY(ready_scalar_tanh),

    // DATA
    .DATA_IN (data_in_scalar_tanh),
    .DATA_OUT(data_out_scalar_tanh)
  );

  // SCALAR EXPONENTIATOR
  accelerator_scalar_exponentiator_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_exponentiator_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_exponentiator),
    .READY(ready_scalar_exponentiator),

    // DATA
    .DATA_IN (data_in_scalar_exponentiator),
    .DATA_OUT(data_out_scalar_exponentiator)
  );

  // SCALAR LOGARITHM
  accelerator_scalar_logarithm_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_logarithm_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_logarithm),
    .READY(ready_scalar_logarithm),

    // DATA
    .DATA_IN (data_in_scalar_logarithm),
    .DATA_OUT(data_out_scalar_logarithm)
  );

  //////////////////////////////////////////////////////////////////////////////
  // VECTOR
  //////////////////////////////////////////////////////////////////////////////

  // VECTOR COSH
  accelerator_vector_cosh_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_cosh_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_cosh),
    .READY(ready_vector_cosh),

    .DATA_IN_ENABLE (data_in_enable_vector_cosh),
    .DATA_OUT_ENABLE(data_out_enable_vector_cosh),

    // DATA
    .SIZE_IN (size_in_vector_cosh),
    .DATA_IN (data_in_vector_cosh),
    .DATA_OUT(data_out_vector_cosh)
  );

  // VECTOR SINH
  accelerator_vector_sinh_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_sinh_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_sinh),
    .READY(ready_vector_sinh),

    .DATA_IN_ENABLE (data_in_enable_vector_sinh),
    .DATA_OUT_ENABLE(data_out_enable_vector_sinh),

    // DATA
    .SIZE_IN (size_in_vector_sinh),
    .DATA_IN (data_in_vector_sinh),
    .DATA_OUT(data_out_vector_sinh)
  );

  // VECTOR TANH
  accelerator_vector_tanh_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_tanh_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_tanh),
    .READY(ready_vector_tanh),

    .DATA_IN_ENABLE (data_in_enable_vector_tanh),
    .DATA_OUT_ENABLE(data_out_enable_vector_tanh),

    // DATA
    .SIZE_IN (size_in_vector_tanh),
    .DATA_IN (data_in_vector_tanh),
    .DATA_OUT(data_out_vector_tanh)
  );

  // VECTOR EXPONENTIATOR
  accelerator_vector_exponentiator_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_exponentiator_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_exponentiator),
    .READY(ready_vector_exponentiator),

    .DATA_IN_ENABLE (data_in_enable_vector_exponentiator),
    .DATA_OUT_ENABLE(data_out_enable_vector_exponentiator),

    // DATA
    .SIZE_IN (size_in_vector_exponentiator),
    .DATA_IN (data_in_vector_exponentiator),
    .DATA_OUT(data_out_vector_exponentiator)
  );

  // VECTOR LOGARITHM
  accelerator_vector_logarithm_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_logarithm_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_logarithm),
    .READY(ready_vector_logarithm),

    .DATA_IN_ENABLE (data_in_enable_vector_logarithm),
    .DATA_OUT_ENABLE(data_out_enable_vector_logarithm),

    // DATA
    .SIZE_IN (size_in_vector_logarithm),
    .DATA_IN (data_in_vector_logarithm),
    .DATA_OUT(data_out_vector_logarithm)
  );

  //////////////////////////////////////////////////////////////////////////////
  // MATRIX
  //////////////////////////////////////////////////////////////////////////////

  // MATRIX COSH
  accelerator_matrix_cosh_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) matrix_cosh_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_cosh),
    .READY(ready_matrix_cosh),

    .DATA_IN_I_ENABLE (data_in_i_enable_matrix_cosh),
    .DATA_IN_J_ENABLE (data_in_j_enable_matrix_cosh),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_cosh),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_cosh),

    // DATA
    .SIZE_I_IN(size_i_in_matrix_cosh),
    .SIZE_J_IN(size_j_in_matrix_cosh),
    .DATA_IN  (data_in_matrix_cosh),
    .DATA_OUT (data_out_matrix_cosh)
  );

  // MATRIX SINH
  accelerator_matrix_sinh_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) matrix_sinh_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_sinh),
    .READY(ready_matrix_sinh),

    .DATA_IN_I_ENABLE (data_in_i_enable_matrix_sinh),
    .DATA_IN_J_ENABLE (data_in_j_enable_matrix_sinh),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_sinh),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_sinh),

    // DATA
    .SIZE_I_IN(size_i_in_matrix_sinh),
    .SIZE_J_IN(size_j_in_matrix_sinh),
    .DATA_IN  (data_in_matrix_sinh),
    .DATA_OUT (data_out_matrix_sinh)
  );

  // MATRIX TANH
  accelerator_matrix_tanh_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) matrix_tanh_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_tanh),
    .READY(ready_matrix_tanh),

    .DATA_IN_I_ENABLE (data_in_i_enable_matrix_tanh),
    .DATA_IN_J_ENABLE (data_in_j_enable_matrix_tanh),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_tanh),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_tanh),

    // DATA
    .SIZE_I_IN(size_i_in_matrix_tanh),
    .SIZE_J_IN(size_j_in_matrix_tanh),
    .DATA_IN  (data_in_matrix_tanh),
    .DATA_OUT (data_out_matrix_tanh)
  );

  // MATRIX EXPONENTIATOR
  accelerator_matrix_exponentiator_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) matrix_exponentiator_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_exponentiator),
    .READY(ready_matrix_exponentiator),

    .DATA_IN_I_ENABLE (data_in_i_enable_matrix_exponentiator),
    .DATA_IN_J_ENABLE (data_in_j_enable_matrix_exponentiator),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_exponentiator),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_exponentiator),

    // DATA
    .SIZE_I_IN(size_i_in_matrix_exponentiator),
    .SIZE_J_IN(size_j_in_matrix_exponentiator),
    .DATA_IN  (data_in_matrix_exponentiator),
    .DATA_OUT (data_out_matrix_exponentiator)
  );

  // MATRIX LOGARITHM
  accelerator_matrix_logarithm_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) matrix_logarithm_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_logarithm),
    .READY(ready_matrix_logarithm),

    .DATA_IN_I_ENABLE (data_in_i_enable_matrix_logarithm),
    .DATA_IN_J_ENABLE (data_in_j_enable_matrix_logarithm),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_logarithm),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_logarithm),

    // DATA
    .SIZE_I_IN(size_i_in_matrix_logarithm),
    .SIZE_J_IN(size_j_in_matrix_logarithm),
    .DATA_IN  (data_in_matrix_logarithm),
    .DATA_OUT (data_out_matrix_logarithm)
  );

endmodule
