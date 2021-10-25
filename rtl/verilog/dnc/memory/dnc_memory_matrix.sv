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

module dnc_memory_matrix(
  CLK,
  RST,
  START,
  READY,
  M_IN_J_ENABLE,
  M_IN_K_ENABLE,
  W_IN_J_ENABLE,
  V_IN_K_ENABLE,
  E_IN_K_ENABLE,
  M_OUT_J_ENABLE,
  M_OUT_K_ENABLE,
  SIZE_N_IN,
  SIZE_W_IN,
  M_IN,
  W_IN,
  V_IN,
  E_IN,
  M_OUT
);

  parameter DATA_SIZE=512;

  // GLOBAL
  input CLK;
  input RST;

  // CONTROL
  input START;
  output READY;

  input M_IN_J_ENABLE;  // for j in 0 to N-1
  input M_IN_K_ENABLE;  // for k in 0 to W-1
  input W_IN_J_ENABLE;  // for j in 0 to N-1
  input V_IN_K_ENABLE;  // for k in 0 to W-1
  input E_IN_K_ENABLE;  // for k in 0 to W-1
  output M_OUT_J_ENABLE;  // for j in 0 to N-1
  output M_OUT_K_ENABLE;  // for k in 0 to W-1

  // DATA
  input [DATA_SIZE-1:0] SIZE_N_IN;
  input [DATA_SIZE-1:0] SIZE_W_IN;
  input [DATA_SIZE-1:0] M_IN;
  input [DATA_SIZE-1:0] W_IN;
  input [DATA_SIZE-1:0] V_IN;
  input E_IN;
  output [DATA_SIZE-1:0] M_OUT;

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  parameter ZERO = 0;
  parameter ONE = 1;
  parameter TWO = 2;
  parameter THREE = 3;

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

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

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  // M(t;j;k) = M(t-1;j;k) o (E - w(t;j)·transpose(e(t;k))) + w(t;j)·transpose(v(t;k))

  // MATRIX TRANSPOSE
  ntm_matrix_transpose #(
    .DATA_SIZE(DATA_SIZE),
    .SIZE_I(THREE),
    .SIZE_J(THREE)
  )
  ntm_matrix_transpose_i(
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
    .DATA_OUT(data_out_matrix_transpose));

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

endmodule
