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

module model_algebra_testbench;

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  parameter DATA_SIZE = 64;
  parameter CONTROL_SIZE = 4;

  parameter X = 64;  // x in 0 to X-1
  parameter Y = 64;  // y in 0 to Y-1
  parameter N = 64;  // j in 0 to N-1
  parameter W = 64;  // k in 0 to W-1
  parameter L = 64;  // l in 0 to L-1
  parameter R = 64;  // i in 0 to R-1

  parameter SIZE_I = 64;
  parameter SIZE_J = 64;

  parameter SIZE = 64;

  // VECTOR-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_DOT_PRODUCT_TEST = 0;

  parameter STIMULUS_ACCELERATOR_DOT_PRODUCT_CASE_0 = 0;

  parameter STIMULUS_ACCELERATOR_DOT_PRODUCT_CASE_1 = 0;

  // MATRIX-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_MATRIX_PRODUCT_TEST = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_TRANSPOSE_TEST = 0;

  parameter STIMULUS_ACCELERATOR_MATRIX_PRODUCT_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_TRANSPOSE_CASE_0 = 0;

  parameter STIMULUS_ACCELERATOR_MATRIX_PRODUCT_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_TRANSPOSE_CASE_1 = 0;

  // TENSOR-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_TENSOR_PRODUCT_TEST = 0;
  parameter STIMULUS_ACCELERATOR_TENSOR_TRANSPOSE_TEST = 0;

  parameter STIMULUS_ACCELERATOR_TENSOR_PRODUCT_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_TENSOR_TRANSPOSE_CASE_0 = 0;

  parameter STIMULUS_ACCELERATOR_TENSOR_PRODUCT_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_TENSOR_TRANSPOSE_CASE_1 = 0;

  //////////////////////////////////////////////////////////////////////////////
  // Signals
  //////////////////////////////////////////////////////////////////////////////

  // GLOBAL
  wire                 CLK;
  wire                 RST;

  // DOT PRODUCT
  // CONTROL
  wire                 start_dot_product;
  wire                 ready_dot_product;

  wire                 data_a_in_enable_dot_product;
  wire                 data_b_in_enable_dot_product;
  wire                 data_out_enable_dot_product;

  // DATA
  wire [DATA_SIZE-1:0] length_in_dot_product;
  wire [DATA_SIZE-1:0] data_a_in_dot_product;
  wire [DATA_SIZE-1:0] data_b_in_dot_product;
  wire [DATA_SIZE-1:0] data_out_dot_product;

  // MATRIX PRODUCT
  // CONTROL
  wire                 start_matrix_product;
  wire                 ready_matrix_product;

  wire                 data_a_in_i_enable_matrix_product;
  wire                 data_a_in_j_enable_matrix_product;
  wire                 data_b_in_i_enable_matrix_product;
  wire                 data_b_in_j_enable_matrix_product;
  wire                 data_out_i_enable_matrix_product;
  wire                 data_out_j_enable_matrix_product;

  // DATA
  wire [DATA_SIZE-1:0] size_a_i_in_matrix_product;
  wire [DATA_SIZE-1:0] size_a_j_in_matrix_product;
  wire [DATA_SIZE-1:0] size_b_i_in_matrix_product;
  wire [DATA_SIZE-1:0] size_b_j_in_matrix_product;
  wire [DATA_SIZE-1:0] data_a_in_matrix_product;
  wire [DATA_SIZE-1:0] data_b_in_matrix_product;
  wire [DATA_SIZE-1:0] data_out_matrix_product;

  // MATRIX TRANSPOSE
  // CONTROL
  wire                 start_matrix_transpose;
  wire                 ready_matrix_transpose;

  wire                 data_in_i_enable_matrix_transpose;
  wire                 data_in_j_enable_matrix_transpose;
  wire                 data_out_i_enable_matrix_transpose;
  wire                 data_out_j_enable_matrix_transpose;

  // DATA
  wire [DATA_SIZE-1:0] size_i_in_matrix_transpose;
  wire [DATA_SIZE-1:0] size_j_in_matrix_transpose;
  wire [DATA_SIZE-1:0] data_in_matrix_transpose;
  wire [DATA_SIZE-1:0] data_out_matrix_transpose;

  // TENSOR TRANSPOSE
  // CONTROL
  wire                 start_tensor_transpose;
  wire                 ready_tensor_transpose;

  wire                 data_in_i_enable_tensor_transpose;
  wire                 data_in_j_enable_tensor_transpose;
  wire                 data_in_k_enable_tensor_transpose;

  wire                 data_out_i_enable_tensor_transpose;
  wire                 data_out_j_enable_tensor_transpose;
  wire                 data_out_k_enable_tensor_transpose;

  // DATA
  wire [DATA_SIZE-1:0] size_i_in_tensor_transpose;
  wire [DATA_SIZE-1:0] size_j_in_tensor_transpose;
  wire [DATA_SIZE-1:0] size_k_in_tensor_transpose;
  wire [DATA_SIZE-1:0] data_in_tensor_transpose;
  wire [DATA_SIZE-1:0] data_out_tensor_transpose;

  // TENSOR PRODUCT
  // CONTROL
  wire                 start_tensor_product;
  wire                 ready_tensor_product;

  wire                 data_a_in_i_enable_tensor_product;
  wire                 data_a_in_j_enable_tensor_product;
  wire                 data_a_in_k_enable_tensor_product;
  wire                 data_b_in_i_enable_tensor_product;
  wire                 data_b_in_j_enable_tensor_product;
  wire                 data_b_in_k_enable_tensor_product;
  wire                 data_out_i_enable_tensor_product;
  wire                 data_out_j_enable_tensor_product;
  wire                 data_out_k_enable_tensor_product;

  // DATA
  wire [DATA_SIZE-1:0] size_a_i_in_tensor_product;
  wire [DATA_SIZE-1:0] size_a_j_in_tensor_product;
  wire [DATA_SIZE-1:0] size_a_k_in_tensor_product;
  wire [DATA_SIZE-1:0] size_b_i_in_tensor_product;
  wire [DATA_SIZE-1:0] size_b_j_in_tensor_product;
  wire [DATA_SIZE-1:0] size_b_k_in_tensor_product;
  wire [DATA_SIZE-1:0] data_a_in_tensor_product;
  wire [DATA_SIZE-1:0] data_b_in_tensor_product;
  wire [DATA_SIZE-1:0] data_out_tensor_product;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  model_algebra_stimulus #(
    // SYSTEM-SIZE
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE),

    .X(X),
    .Y(Y),
    .N(N),
    .W(W),
    .L(L),
    .R(R),

    // VECTOR-FUNCTIONALITY
    .STIMULUS_ACCELERATOR_DOT_PRODUCT_TEST(STIMULUS_ACCELERATOR_DOT_PRODUCT_TEST),

    .STIMULUS_ACCELERATOR_DOT_PRODUCT_CASE_0(STIMULUS_ACCELERATOR_DOT_PRODUCT_CASE_0),

    .STIMULUS_ACCELERATOR_DOT_PRODUCT_CASE_1(STIMULUS_ACCELERATOR_DOT_PRODUCT_CASE_1),

    // MATRIX-FUNCTIONALITY
    .STIMULUS_ACCELERATOR_MATRIX_PRODUCT_TEST  (STIMULUS_ACCELERATOR_MATRIX_PRODUCT_TEST),
    .STIMULUS_ACCELERATOR_MATRIX_TRANSPOSE_TEST(STIMULUS_ACCELERATOR_MATRIX_TRANSPOSE_TEST),

    .STIMULUS_ACCELERATOR_MATRIX_PRODUCT_CASE_0  (STIMULUS_ACCELERATOR_MATRIX_PRODUCT_CASE_0),
    .STIMULUS_ACCELERATOR_MATRIX_TRANSPOSE_CASE_0(STIMULUS_ACCELERATOR_MATRIX_TRANSPOSE_CASE_0),

    .STIMULUS_ACCELERATOR_MATRIX_PRODUCT_CASE_1  (STIMULUS_ACCELERATOR_MATRIX_PRODUCT_CASE_1),
    .STIMULUS_ACCELERATOR_MATRIX_TRANSPOSE_CASE_1(STIMULUS_ACCELERATOR_MATRIX_TRANSPOSE_CASE_1),

    // TENSOR-FUNCTIONALITY
    .STIMULUS_ACCELERATOR_TENSOR_PRODUCT_TEST  (STIMULUS_ACCELERATOR_TENSOR_PRODUCT_TEST),
    .STIMULUS_ACCELERATOR_TENSOR_TRANSPOSE_TEST(STIMULUS_ACCELERATOR_TENSOR_TRANSPOSE_TEST),

    .STIMULUS_ACCELERATOR_TENSOR_PRODUCT_CASE_0  (STIMULUS_ACCELERATOR_TENSOR_PRODUCT_CASE_0),
    .STIMULUS_ACCELERATOR_TENSOR_TRANSPOSE_CASE_0(STIMULUS_ACCELERATOR_TENSOR_TRANSPOSE_CASE_0),

    .STIMULUS_ACCELERATOR_TENSOR_PRODUCT_CASE_1  (STIMULUS_ACCELERATOR_TENSOR_PRODUCT_CASE_1),
    .STIMULUS_ACCELERATOR_TENSOR_TRANSPOSE_CASE_1(STIMULUS_ACCELERATOR_TENSOR_TRANSPOSE_CASE_1)
  ) algebra_stimulus (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // DOT PRODUCT
    // CONTROL
    .DOT_PRODUCT_START(start_dot_product),
    .DOT_PRODUCT_READY(ready_dot_product),

    .DOT_PRODUCT_DATA_A_IN_ENABLE(data_a_in_enable_dot_product),
    .DOT_PRODUCT_DATA_B_IN_ENABLE(data_b_in_enable_dot_product),
    .DOT_PRODUCT_DATA_OUT_ENABLE (data_out_enable_dot_product),

    // DATA
    .DOT_PRODUCT_LENGTH_IN(length_in_dot_product),
    .DOT_PRODUCT_DATA_A_IN(data_a_in_dot_product),
    .DOT_PRODUCT_DATA_B_IN(data_b_in_matrix_product),
    .DOT_PRODUCT_DATA_OUT (data_out_matrix_product),

    // MATRIX PRODUCT
    // CONTROL
    .MATRIX_PRODUCT_START(start_matrix_product),
    .MATRIX_PRODUCT_READY(ready_matrix_product),

    .MATRIX_PRODUCT_DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_product),
    .MATRIX_PRODUCT_DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_product),
    .MATRIX_PRODUCT_DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_product),
    .MATRIX_PRODUCT_DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_product),
    .MATRIX_PRODUCT_DATA_OUT_I_ENABLE (data_out_i_enable_matrix_product),
    .MATRIX_PRODUCT_DATA_OUT_J_ENABLE (data_out_j_enable_matrix_product),

    // DATA
    .MATRIX_PRODUCT_SIZE_A_I_IN(size_a_i_in_matrix_product),
    .MATRIX_PRODUCT_SIZE_A_J_IN(size_a_j_in_matrix_product),
    .MATRIX_PRODUCT_SIZE_B_I_IN(size_b_i_in_matrix_product),
    .MATRIX_PRODUCT_SIZE_B_J_IN(size_b_j_in_matrix_product),
    .MATRIX_PRODUCT_DATA_A_IN  (data_a_in_matrix_product),
    .MATRIX_PRODUCT_DATA_B_IN  (data_b_in_matrix_product),
    .MATRIX_PRODUCT_DATA_OUT   (data_out_matrix_product),

    // MATRIX TRANSPOSE
    // CONTROL
    .MATRIX_TRANSPOSE_START(start_matrix_transpose),
    .MATRIX_TRANSPOSE_READY(ready_matrix_transpose),

    .MATRIX_TRANSPOSE_DATA_IN_I_ENABLE (data_in_i_enable_matrix_transpose),
    .MATRIX_TRANSPOSE_DATA_IN_J_ENABLE (data_in_j_enable_matrix_transpose),
    .MATRIX_TRANSPOSE_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_transpose),
    .MATRIX_TRANSPOSE_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_transpose),

    // DATA
    .MATRIX_TRANSPOSE_SIZE_I_IN(size_i_in_matrix_transpose),
    .MATRIX_TRANSPOSE_SIZE_J_IN(size_j_in_matrix_transpose),
    .MATRIX_TRANSPOSE_DATA_IN  (data_in_matrix_transpose),
    .MATRIX_TRANSPOSE_DATA_OUT (data_out_matrix_transpose),

    // TENSOR PRODUCT
    // CONTROL
    .TENSOR_PRODUCT_START(start_tensor_product),
    .TENSOR_PRODUCT_READY(ready_tensor_product),

    .TENSOR_PRODUCT_DATA_A_IN_I_ENABLE(data_a_in_i_enable_tensor_product),
    .TENSOR_PRODUCT_DATA_A_IN_J_ENABLE(data_a_in_j_enable_tensor_product),
    .TENSOR_PRODUCT_DATA_A_IN_K_ENABLE(data_a_in_k_enable_tensor_product),
    .TENSOR_PRODUCT_DATA_B_IN_I_ENABLE(data_b_in_i_enable_tensor_product),
    .TENSOR_PRODUCT_DATA_B_IN_J_ENABLE(data_b_in_j_enable_tensor_product),
    .TENSOR_PRODUCT_DATA_B_IN_K_ENABLE(data_b_in_k_enable_tensor_product),
    .TENSOR_PRODUCT_DATA_OUT_I_ENABLE (data_out_i_enable_tensor_product),
    .TENSOR_PRODUCT_DATA_OUT_J_ENABLE (data_out_j_enable_tensor_product),
    .TENSOR_PRODUCT_DATA_OUT_K_ENABLE (data_out_k_enable_tensor_product),

    // DATA
    .TENSOR_PRODUCT_SIZE_A_I_IN(size_a_i_in_tensor_product),
    .TENSOR_PRODUCT_SIZE_A_J_IN(size_a_j_in_tensor_product),
    .TENSOR_PRODUCT_SIZE_A_K_IN(size_a_k_in_tensor_product),
    .TENSOR_PRODUCT_SIZE_B_I_IN(size_b_i_in_tensor_product),
    .TENSOR_PRODUCT_SIZE_B_J_IN(size_b_j_in_tensor_product),
    .TENSOR_PRODUCT_SIZE_B_K_IN(size_b_k_in_tensor_product),
    .TENSOR_PRODUCT_DATA_A_IN  (data_a_in_tensor_product),
    .TENSOR_PRODUCT_DATA_B_IN  (data_b_in_tensor_product),
    .TENSOR_PRODUCT_DATA_OUT   (data_out_tensor_product),

    // TENSOR TRANSPOSE
    // CONTROL
    .TENSOR_TRANSPOSE_START(start_tensor_transpose),
    .TENSOR_TRANSPOSE_READY(ready_tensor_transpose),

    .TENSOR_TRANSPOSE_DATA_IN_I_ENABLE(data_in_i_enable_tensor_transpose),
    .TENSOR_TRANSPOSE_DATA_IN_J_ENABLE(data_in_j_enable_tensor_transpose),
    .TENSOR_TRANSPOSE_DATA_IN_K_ENABLE(data_in_k_enable_tensor_transpose),

    .TENSOR_TRANSPOSE_DATA_OUT_I_ENABLE(data_out_i_enable_tensor_transpose),
    .TENSOR_TRANSPOSE_DATA_OUT_J_ENABLE(data_out_j_enable_tensor_transpose),
    .TENSOR_TRANSPOSE_DATA_OUT_K_ENABLE(data_out_k_enable_tensor_transpose),

    // DATA
    .TENSOR_TRANSPOSE_SIZE_I_IN(size_i_in_tensor_transpose),
    .TENSOR_TRANSPOSE_SIZE_J_IN(size_j_in_tensor_transpose),
    .TENSOR_TRANSPOSE_SIZE_K_IN(size_k_in_tensor_transpose),
    .TENSOR_TRANSPOSE_DATA_IN  (data_in_tensor_transpose),
    .TENSOR_TRANSPOSE_DATA_OUT (data_out_tensor_transpose)
  );

  // DOT PRODUCT
  model_dot_product #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) dot_product (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_dot_product),
    .READY(ready_dot_product),

    .DATA_A_IN_ENABLE(data_a_in_enable_dot_product),
    .DATA_B_IN_ENABLE(data_b_in_enable_dot_product),
    .DATA_OUT_ENABLE (data_out_enable_dot_product),

    // DATA
    .LENGTH_IN(length_in_dot_product),
    .DATA_A_IN(data_a_in_dot_product),
    .DATA_B_IN(data_b_in_dot_product),
    .DATA_OUT (data_out_dot_product)
  );

  // MATRIX PRODUCT
  model_matrix_product #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) matrix_product (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_product),
    .READY(ready_matrix_product),

    .DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_product),
    .DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_product),
    .DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_product),
    .DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_product),
    .DATA_OUT_I_ENABLE (data_out_i_enable_matrix_product),
    .DATA_OUT_J_ENABLE (data_out_j_enable_matrix_product),

    // DATA
    .SIZE_A_I_IN(size_a_i_in_matrix_product),
    .SIZE_A_J_IN(size_a_j_in_matrix_product),
    .SIZE_B_I_IN(size_b_i_in_matrix_product),
    .SIZE_B_J_IN(size_b_j_in_matrix_product),
    .DATA_A_IN  (data_a_in_matrix_product),
    .DATA_B_IN  (data_b_in_matrix_product),
    .DATA_OUT   (data_out_matrix_product)
  );

  // MATRIX TRANSPOSE
  model_matrix_transpose #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) matrix_transpose (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_transpose),
    .READY(ready_matrix_transpose),

    .DATA_IN_I_ENABLE (data_in_i_enable_matrix_transpose),
    .DATA_IN_J_ENABLE (data_in_j_enable_matrix_transpose),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_transpose),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_transpose),

    // DATA
    .SIZE_I_IN(size_i_in_matrix_transpose),
    .SIZE_J_IN(size_j_in_matrix_transpose),
    .DATA_IN  (data_in_matrix_transpose),
    .DATA_OUT (data_out_matrix_transpose)
  );

  // TENSOR PRODUCT
  model_tensor_product #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) tensor_product (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_tensor_product),
    .READY(ready_tensor_product),

    .DATA_A_IN_I_ENABLE(data_a_in_i_enable_tensor_product),
    .DATA_A_IN_J_ENABLE(data_a_in_j_enable_tensor_product),
    .DATA_A_IN_K_ENABLE(data_a_in_k_enable_tensor_product),
    .DATA_B_IN_I_ENABLE(data_b_in_i_enable_tensor_product),
    .DATA_B_IN_J_ENABLE(data_b_in_j_enable_tensor_product),
    .DATA_B_IN_K_ENABLE(data_b_in_k_enable_tensor_product),
    .DATA_OUT_I_ENABLE (data_out_i_enable_tensor_product),
    .DATA_OUT_J_ENABLE (data_out_j_enable_tensor_product),
    .DATA_OUT_K_ENABLE (data_out_k_enable_tensor_product),

    // DATA
    .SIZE_A_I_IN(size_a_i_in_tensor_product),
    .SIZE_A_J_IN(size_a_j_in_tensor_product),
    .SIZE_A_K_IN(size_a_k_in_tensor_product),
    .SIZE_B_I_IN(size_b_i_in_tensor_product),
    .SIZE_B_J_IN(size_b_j_in_tensor_product),
    .SIZE_B_K_IN(size_b_k_in_tensor_product),
    .DATA_A_IN  (data_a_in_tensor_product),
    .DATA_B_IN  (data_b_in_tensor_product),
    .DATA_OUT   (data_out_tensor_product)
  );

  // TENSOR TRANSPOSE
  model_tensor_transpose #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) tensor_transpose (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_tensor_transpose),
    .READY(ready_tensor_transpose),

    .DATA_IN_I_ENABLE(data_in_i_enable_tensor_transpose),
    .DATA_IN_J_ENABLE(data_in_j_enable_tensor_transpose),
    .DATA_IN_K_ENABLE(data_in_k_enable_tensor_transpose),

    .DATA_OUT_I_ENABLE(data_out_i_enable_tensor_transpose),
    .DATA_OUT_J_ENABLE(data_out_j_enable_tensor_transpose),
    .DATA_OUT_K_ENABLE(data_out_k_enable_tensor_transpose),

    // DATA
    .SIZE_I_IN(size_i_in_tensor_transpose),
    .SIZE_J_IN(size_j_in_tensor_transpose),
    .SIZE_K_IN(size_k_in_tensor_transpose),
    .DATA_IN  (data_in_tensor_transpose),
    .DATA_OUT (data_out_tensor_transpose)
  );

endmodule
