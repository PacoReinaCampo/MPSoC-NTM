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

module ntm_algebra_testbench;

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  parameter DATA_SIZE=512;

  parameter X=64;  // x in 0 to X-1
  parameter Y=64;  // y in 0 to Y-1
  parameter N=64;  // j in 0 to N-1
  parameter W=64;  // k in 0 to W-1
  parameter L=64;  // l in 0 to L-1
  parameter R=64;  // i in 0 to R-1

  parameter SIZE_I=64;
  parameter SIZE_J=64;

  parameter SIZE=64;

  // FUNCTIONALITY
  parameter STIMULUS_NTM_MATRIX_DETERMINANT_TEST   = 0;
  parameter STIMULUS_NTM_MATRIX_INVERSION_TEST     = 0;
  parameter STIMULUS_NTM_MATRIX_PRODUCT_TEST       = 0;
  parameter STIMULUS_NTM_MATRIX_RANK_TEST          = 0;
  parameter STIMULUS_NTM_MATRIX_TRANSPOSE_TEST     = 0;
  parameter STIMULUS_NTM_SCALAR_PRODUCT_TEST       = 0;
  parameter STIMULUS_NTM_TENSOR_PRODUCT_TEST       = 0;
  parameter STIMULUS_NTM_MATRIX_DETERMINANT_CASE_0 = 0;
  parameter STIMULUS_NTM_MATRIX_INVERSION_CASE_0   = 0;
  parameter STIMULUS_NTM_MATRIX_PRODUCT_CASE_0     = 0;
  parameter STIMULUS_NTM_MATRIX_RANK_CASE_0        = 0;
  parameter STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_0   = 0;
  parameter STIMULUS_NTM_SCALAR_PRODUCT_CASE_0     = 0;
  parameter STIMULUS_NTM_TENSOR_PRODUCT_CASE_0     = 0;
  parameter STIMULUS_NTM_MATRIX_DETERMINANT_CASE_1 = 0;
  parameter STIMULUS_NTM_MATRIX_INVERSION_CASE_1   = 0;
  parameter STIMULUS_NTM_MATRIX_PRODUCT_CASE_1     = 0;
  parameter STIMULUS_NTM_MATRIX_RANK_CASE_1        = 0;
  parameter STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_1   = 0;
  parameter STIMULUS_NTM_SCALAR_PRODUCT_CASE_1     = 0;
  parameter STIMULUS_NTM_TENSOR_PRODUCT_CASE_1     = 0;
  
  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

  // GLOBAL
  wire CLK;
  wire RST;

  // MATRIX DETERMINANT
  // CONTROL
  wire start_matrix_determinant;
  wire ready_matrix_determinant;

  wire data_in_i_enable_matrix_determinant;
  wire data_in_j_enable_matrix_determinant;
  wire data_out_i_enable_matrix_determinant;
  wire data_out_j_enable_matrix_determinant;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_determinant;
  wire [DATA_SIZE-1:0] data_in_matrix_determinant;
  wire [DATA_SIZE-1:0] data_out_matrix_determinant;

  // MATRIX INVERSION
  // CONTROL
  wire start_matrix_inversion;
  wire ready_matrix_inversion;

  wire data_in_i_enable_matrix_inversion;
  wire data_in_j_enable_matrix_inversion;
  wire data_out_i_enable_matrix_inversion;
  wire data_out_j_enable_matrix_inversion;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_inversion;
  wire [DATA_SIZE-1:0] data_in_matrix_inversion;
  wire [DATA_SIZE-1:0] data_out_matrix_inversion;

  // MATRIX PRODUCT
  // CONTROL
  wire start_matrix_product;
  wire ready_matrix_product;

  wire data_a_in_i_enable_matrix_product;
  wire data_a_in_j_enable_matrix_product;
  wire data_b_in_i_enable_matrix_product;
  wire data_b_in_j_enable_matrix_product;
  wire data_out_i_enable_matrix_product;
  wire data_out_j_enable_matrix_product;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_product;
  wire [DATA_SIZE-1:0] size_a_i_in_matrix_product;
  wire [DATA_SIZE-1:0] size_a_j_in_matrix_product;
  wire [DATA_SIZE-1:0] size_b_i_in_matrix_product;
  wire [DATA_SIZE-1:0] size_b_j_in_matrix_product;
  wire [DATA_SIZE-1:0] data_a_in_matrix_product;
  wire [DATA_SIZE-1:0] data_b_in_matrix_product;
  wire [DATA_SIZE-1:0] data_out_matrix_product;

  // MATRIX RANK
  // CONTROL
  wire start_matrix_rank;
  wire ready_matrix_rank;

  wire data_in_i_enable_matrix_rank;
  wire data_in_j_enable_matrix_rank;
  wire data_out_i_enable_matrix_rank;
  wire data_out_j_enable_matrix_rank;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_rank;
  wire [DATA_SIZE-1:0] data_in_matrix_rank;
  wire [DATA_SIZE-1:0] data_out_matrix_rank;

  // MATRIX TRANSPOSE
  // CONTROL
  wire start_matrix_transpose;
  wire ready_matrix_transpose;

  wire data_in_i_enable_matrix_transpose;
  wire data_in_j_enable_matrix_transpose;
  wire data_out_i_enable_matrix_transpose;
  wire data_out_j_enable_matrix_transpose;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_transpose;
  wire [DATA_SIZE-1:0] data_in_matrix_transpose;
  wire [DATA_SIZE-1:0] data_out_matrix_transpose;

  // SCALAR PRODUCT
  // CONTROL
  wire start_scalar_product;
  wire ready_scalar_product;

  wire data_a_in_enable_scalar_product;
  wire data_b_in_enable_scalar_product;
  wire data_out_enable_scalar_product;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_product;
  wire [DATA_SIZE-1:0] length_in_scalar_product;
  wire [DATA_SIZE-1:0] data_a_in_scalar_product;
  wire [DATA_SIZE-1:0] data_b_in_scalar_product;
  wire [DATA_SIZE-1:0] data_out_scalar_product;

  // TENSOR PRODUCT
  // CONTROL
  wire start_tensor_product;
  wire ready_tensor_product;

  wire data_a_in_i_enable_tensor_product;
  wire data_a_in_j_enable_tensor_product;
  wire data_a_in_k_enable_tensor_product;
  wire data_b_in_i_enable_tensor_product;
  wire data_b_in_j_enable_tensor_product;
  wire data_b_in_k_enable_tensor_product;
  wire data_out_i_enable_tensor_product;
  wire data_out_j_enable_tensor_product;
  wire data_out_k_enable_tensor_product;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_tensor_product;
  wire [DATA_SIZE-1:0] size_a_i_in_tensor_product;
  wire [DATA_SIZE-1:0] size_a_j_in_tensor_product;
  wire [DATA_SIZE-1:0] size_a_k_in_tensor_product;
  wire [DATA_SIZE-1:0] size_b_i_in_tensor_product;
  wire [DATA_SIZE-1:0] size_b_j_in_tensor_product;
  wire [DATA_SIZE-1:0] size_b_k_in_tensor_product;
  wire [DATA_SIZE-1:0] data_a_in_tensor_product;
  wire [DATA_SIZE-1:0] data_b_in_tensor_product;
  wire [DATA_SIZE-1:0] data_out_tensor_product;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  ntm_algebra_stimulus #(
    // SYSTEM-SIZE
    .DATA_SIZE(DATA_SIZE),

    .X(X),
    .Y(Y),
    .N(N),
    .W(W),
    .L(L),
    .R(R),

    // FUNCTIONALITY
    .STIMULUS_NTM_MATRIX_DETERMINANT_TEST(STIMULUS_NTM_MATRIX_DETERMINANT_TEST),
    .STIMULUS_NTM_MATRIX_INVERSION_TEST(STIMULUS_NTM_MATRIX_INVERSION_TEST),
    .STIMULUS_NTM_MATRIX_PRODUCT_TEST(STIMULUS_NTM_MATRIX_PRODUCT_TEST),
    .STIMULUS_NTM_MATRIX_RANK_TEST(STIMULUS_NTM_MATRIX_RANK_TEST),
    .STIMULUS_NTM_MATRIX_TRANSPOSE_TEST(STIMULUS_NTM_MATRIX_TRANSPOSE_TEST),
    .STIMULUS_NTM_SCALAR_PRODUCT_TEST(STIMULUS_NTM_SCALAR_PRODUCT_TEST),
    .STIMULUS_NTM_TENSOR_PRODUCT_TEST(STIMULUS_NTM_TENSOR_PRODUCT_TEST),

    .STIMULUS_NTM_MATRIX_DETERMINANT_CASE_0(STIMULUS_NTM_MATRIX_DETERMINANT_CASE_0),
    .STIMULUS_NTM_MATRIX_INVERSION_CASE_0(STIMULUS_NTM_MATRIX_INVERSION_CASE_0),
    .STIMULUS_NTM_MATRIX_PRODUCT_CASE_0(STIMULUS_NTM_MATRIX_PRODUCT_CASE_0),
    .STIMULUS_NTM_MATRIX_RANK_CASE_0(STIMULUS_NTM_MATRIX_RANK_CASE_0),
    .STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_0(STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_0),
    .STIMULUS_NTM_SCALAR_PRODUCT_CASE_0(STIMULUS_NTM_SCALAR_PRODUCT_CASE_0),
    .STIMULUS_NTM_TENSOR_PRODUCT_CASE_0(STIMULUS_NTM_TENSOR_PRODUCT_CASE_0),

    .STIMULUS_NTM_MATRIX_DETERMINANT_CASE_1(STIMULUS_NTM_MATRIX_DETERMINANT_CASE_1),
    .STIMULUS_NTM_MATRIX_INVERSION_CASE_1(STIMULUS_NTM_MATRIX_INVERSION_CASE_1),
    .STIMULUS_NTM_MATRIX_PRODUCT_CASE_1(STIMULUS_NTM_MATRIX_PRODUCT_CASE_1),
    .STIMULUS_NTM_MATRIX_RANK_CASE_1(STIMULUS_NTM_MATRIX_RANK_CASE_1),
    .STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_1(STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_1),
    .STIMULUS_NTM_SCALAR_PRODUCT_CASE_1(STIMULUS_NTM_SCALAR_PRODUCT_CASE_1),
    .STIMULUS_NTM_TENSOR_PRODUCT_CASE_1(STIMULUS_NTM_TENSOR_PRODUCT_CASE_1)
  )
  algebra_stimulus(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // MATRIX DETERMINANT
    // CONTROL
    .MATRIX_DETERMINANT_START(start_matrix_determinant),
    .MATRIX_DETERMINANT_READY(ready_matrix_determinant),

    .MATRIX_DETERMINANT_DATA_IN_I_ENABLE(data_in_i_enable_matrix_determinant),
    .MATRIX_DETERMINANT_DATA_IN_J_ENABLE(data_in_j_enable_matrix_determinant),
    .MATRIX_DETERMINANT_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_determinant),
    .MATRIX_DETERMINANT_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_determinant),

    // DATA
    .MATRIX_DETERMINANT_MODULO_IN(modulo_in_matrix_determinant),
    .MATRIX_DETERMINANT_DATA_IN(data_in_matrix_determinant),
    .MATRIX_DETERMINANT_DATA_OUT(data_out_matrix_determinant),

    // MATRIX INVERSION
    // CONTROL
    .MATRIX_INVERSION_START(start_matrix_inversion),
    .MATRIX_INVERSION_READY(ready_matrix_inversion),
    .MATRIX_INVERSION_DATA_IN_I_ENABLE(data_in_i_enable_matrix_inversion),
    .MATRIX_INVERSION_DATA_IN_J_ENABLE(data_in_j_enable_matrix_inversion),
    .MATRIX_INVERSION_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_inversion),
    .MATRIX_INVERSION_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_inversion),

    // DATA
    .MATRIX_INVERSION_MODULO_IN(modulo_in_matrix_inversion),
    .MATRIX_INVERSION_DATA_IN(data_in_matrix_inversion),
    .MATRIX_INVERSION_DATA_OUT(data_out_matrix_inversion),

    // MATRIX PRODUCT
    // CONTROL
    .MATRIX_PRODUCT_START(start_matrix_product),
    .MATRIX_PRODUCT_READY(ready_matrix_product),

    .MATRIX_PRODUCT_DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_product),
    .MATRIX_PRODUCT_DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_product),
    .MATRIX_PRODUCT_DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_product),
    .MATRIX_PRODUCT_DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_product),
    .MATRIX_PRODUCT_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_product),
    .MATRIX_PRODUCT_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_product),

    // DATA
    .MATRIX_PRODUCT_MODULO_IN(modulo_in_matrix_product),
    .MATRIX_PRODUCT_SIZE_A_I_IN(size_a_i_in_matrix_product),
    .MATRIX_PRODUCT_SIZE_A_J_IN(size_a_j_in_matrix_product),
    .MATRIX_PRODUCT_SIZE_B_I_IN(size_b_i_in_matrix_product),
    .MATRIX_PRODUCT_SIZE_B_J_IN(size_b_j_in_matrix_product),
    .MATRIX_PRODUCT_DATA_A_IN(data_a_in_matrix_product),
    .MATRIX_PRODUCT_DATA_B_IN(data_b_in_matrix_product),
    .MATRIX_PRODUCT_DATA_OUT(data_out_matrix_product),

    // MATRIX RANK
    // CONTROL
    .MATRIX_RANK_START(start_matrix_rank),
    .MATRIX_RANK_READY(ready_matrix_rank),

    .MATRIX_RANK_DATA_IN_I_ENABLE(data_in_i_enable_matrix_rank),
    .MATRIX_RANK_DATA_IN_J_ENABLE(data_in_j_enable_matrix_rank),
    .MATRIX_RANK_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_rank),
    .MATRIX_RANK_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_rank),

    // DATA
    .MATRIX_RANK_MODULO_IN(modulo_in_matrix_rank),
    .MATRIX_RANK_DATA_IN(data_in_matrix_rank),
    .MATRIX_RANK_DATA_OUT(data_out_matrix_rank),

    // MATRIX TRANSPOSE
    // CONTROL
    .MATRIX_TRANSPOSE_START(start_matrix_transpose),
    .MATRIX_TRANSPOSE_READY(ready_matrix_transpose),

    .MATRIX_TRANSPOSE_DATA_IN_I_ENABLE(data_in_i_enable_matrix_transpose),
    .MATRIX_TRANSPOSE_DATA_IN_J_ENABLE(data_in_j_enable_matrix_transpose),
    .MATRIX_TRANSPOSE_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_transpose),
    .MATRIX_TRANSPOSE_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_transpose),

    // DATA
    .MATRIX_TRANSPOSE_MODULO_IN(modulo_in_matrix_transpose),
    .MATRIX_TRANSPOSE_DATA_IN(data_in_matrix_transpose),
    .MATRIX_TRANSPOSE_DATA_OUT(data_out_matrix_transpose),

    // SCALAR PRODUCT
    // CONTROL
    .SCALAR_PRODUCT_START(start_scalar_product),
    .SCALAR_PRODUCT_READY(ready_scalar_product),

    .SCALAR_PRODUCT_DATA_A_IN_ENABLE(data_a_in_enable_scalar_product),
    .SCALAR_PRODUCT_DATA_B_IN_ENABLE(data_b_in_enable_scalar_product),
    .SCALAR_PRODUCT_DATA_OUT_ENABLE(data_out_enable_scalar_product),

    // DATA
    .SCALAR_PRODUCT_MODULO_IN(modulo_in_scalar_product),
    .SCALAR_PRODUCT_LENGTH_IN(length_in_scalar_product),
    .SCALAR_PRODUCT_DATA_A_IN(data_a_in_scalar_product),
    .SCALAR_PRODUCT_DATA_B_IN(data_b_in_matrix_product),
    .SCALAR_PRODUCT_DATA_OUT(data_out_matrix_product),

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
    .TENSOR_PRODUCT_DATA_OUT_I_ENABLE(data_out_i_enable_tensor_product),
    .TENSOR_PRODUCT_DATA_OUT_J_ENABLE(data_out_j_enable_tensor_product),
    .TENSOR_PRODUCT_DATA_OUT_K_ENABLE(data_out_k_enable_tensor_product),

    // DATA
    .TENSOR_PRODUCT_MODULO_IN(modulo_in_tensor_product),
    .TENSOR_PRODUCT_SIZE_A_I_IN(size_a_i_in_tensor_product),
    .TENSOR_PRODUCT_SIZE_A_J_IN(size_a_j_in_tensor_product),
    .TENSOR_PRODUCT_SIZE_A_K_IN(size_a_k_in_tensor_product),
    .TENSOR_PRODUCT_SIZE_B_I_IN(size_b_i_in_tensor_product),
    .TENSOR_PRODUCT_SIZE_B_J_IN(size_b_j_in_tensor_product),
    .TENSOR_PRODUCT_SIZE_B_K_IN(size_b_k_in_tensor_product),
    .TENSOR_PRODUCT_DATA_A_IN(data_a_in_tensor_product),
    .TENSOR_PRODUCT_DATA_B_IN(data_b_in_tensor_product),
    .TENSOR_PRODUCT_DATA_OUT(data_out_tensor_product)
  );

  // MATRIX DETERMINANT
  ntm_matrix_determinant #(
    .DATA_SIZE(DATA_SIZE),

    .SIZE_I(SIZE_I),
    .SIZE_J(SIZE_J)
  )
  matrix_determinant(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_determinant),
    .READY(ready_matrix_determinant),

    .DATA_IN_I_ENABLE(data_in_i_enable_matrix_determinant),
    .DATA_IN_J_ENABLE(data_in_j_enable_matrix_determinant),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_determinant),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_determinant),

    // DATA
    .MODULO_IN(modulo_in_matrix_determinant),
    .DATA_IN(data_in_matrix_determinant),
    .DATA_OUT(data_out_matrix_determinant)
  );

  // MATRIX INVERSION
  ntm_matrix_inversion #(
    .DATA_SIZE(DATA_SIZE),

    .SIZE_I(SIZE_I),
    .SIZE_J(SIZE_J)
  )
  matrix_inversion(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_inversion),
    .READY(ready_matrix_inversion),

    .DATA_IN_I_ENABLE(data_in_i_enable_matrix_inversion),
    .DATA_IN_J_ENABLE(data_in_j_enable_matrix_inversion),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_inversion),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_inversion),

    // DATA
    .MODULO_IN(modulo_in_matrix_inversion),
    .DATA_IN(data_in_matrix_inversion),
    .DATA_OUT(data_out_matrix_inversion)
  );

  // MATRIX PRODUCT
  ntm_matrix_product #(
    .DATA_SIZE(DATA_SIZE)
  )
  matrix_product(
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
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_product),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_product),

    // DATA
    .MODULO_IN(modulo_in_matrix_product),
    .SIZE_A_I_IN(size_a_i_in_matrix_product),
    .SIZE_A_J_IN(size_a_j_in_matrix_product),
    .SIZE_B_I_IN(size_b_i_in_matrix_product),
    .SIZE_B_J_IN(size_b_j_in_matrix_product),
    .DATA_A_IN(data_a_in_matrix_product),
    .DATA_B_IN(data_b_in_matrix_product),
    .DATA_OUT(data_out_matrix_product)
  );

  // MATRIX RANK
  ntm_matrix_rank #(
    .DATA_SIZE(DATA_SIZE),

    .SIZE_I(SIZE_I),
    .SIZE_J(SIZE_J)
  )
  matrix_rank(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_rank),
    .READY(ready_matrix_rank),

    .DATA_IN_I_ENABLE(data_in_i_enable_matrix_rank),
    .DATA_IN_J_ENABLE(data_in_j_enable_matrix_rank),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_rank),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_rank),

    // DATA
    .MODULO_IN(modulo_in_matrix_rank),
    .DATA_IN(data_in_matrix_rank),
    .DATA_OUT(data_out_matrix_rank)
  );

  // MATRIX TRANSPOSE
  ntm_matrix_transpose #(
    .DATA_SIZE(DATA_SIZE),

    .SIZE_I(SIZE_I),
    .SIZE_J(SIZE_J)
  )
  matrix_transpose(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_transpose),
    .READY(ready_matrix_transpose),

    .DATA_IN_I_ENABLE(data_in_i_enable_matrix_transpose),
    .DATA_IN_J_ENABLE(data_in_j_enable_matrix_transpose),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_transpose),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_transpose),

    // DATA
    .MODULO_IN(modulo_in_matrix_transpose),
    .DATA_IN(data_in_matrix_transpose),
    .DATA_OUT(data_out_matrix_transpose)
  );

  // SCALAR PRODUCT
  ntm_scalar_product #(
    .DATA_SIZE(DATA_SIZE)
  )
  scalar_product(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_product),
    .READY(ready_scalar_product),

    .DATA_A_IN_ENABLE(data_a_in_enable_scalar_product),
    .DATA_B_IN_ENABLE(data_b_in_enable_scalar_product),
    .DATA_OUT_ENABLE(data_out_enable_scalar_product),

    // DATA
    .MODULO_IN(modulo_in_scalar_product),
    .LENGTH_IN(length_in_scalar_product),
    .DATA_A_IN(data_a_in_scalar_product),
    .DATA_B_IN(data_b_in_scalar_product),
    .DATA_OUT(data_out_scalar_product)
  );

  // TENSOR PRODUCT
  ntm_tensor_product #(
    .DATA_SIZE(DATA_SIZE)
  )
  tensor_product(
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
    .DATA_OUT_I_ENABLE(data_out_i_enable_tensor_product),
    .DATA_OUT_J_ENABLE(data_out_j_enable_tensor_product),
    .DATA_OUT_K_ENABLE(data_out_k_enable_tensor_product),

    // DATA
    .MODULO_IN(modulo_in_tensor_product),
    .SIZE_A_I_IN(size_a_i_in_tensor_product),
    .SIZE_A_J_IN(size_a_j_in_tensor_product),
    .SIZE_A_K_IN(size_a_k_in_tensor_product),
    .SIZE_B_I_IN(size_b_i_in_tensor_product),
    .SIZE_B_J_IN(size_b_j_in_tensor_product),
    .SIZE_B_K_IN(size_b_k_in_tensor_product),
    .DATA_A_IN(data_a_in_tensor_product),
    .DATA_B_IN(data_b_in_tensor_product),
    .DATA_OUT(data_out_tensor_product)
  );

endmodule
