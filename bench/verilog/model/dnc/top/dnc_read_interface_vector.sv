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

module dnc_read_interface_vector #(
  parameter DATA_SIZE=512
)
  (
    // GLOBAL
    input CLK,
    input RST,

    // CONTROL
    input START,
    output reg READY,

    // Read Key
    input WK_IN_I_ENABLE,  // for i in 0 to R-1
    input WK_IN_L_ENABLE,  // for l in 0 to L-1
    input WK_IN_K_ENABLE,  // for k in 0 to W-1
    output reg K_OUT_I_ENABLE,  // for i in 0 to R-1
    output reg K_OUT_K_ENABLE,  // for k in 0 to W-1

    // Read Strength
    input WBETA_IN_I_ENABLE,  // for i in 0 to R-1
    input WBETA_IN_L_ENABLE,  // for l in 0 to L-1
    output reg BETA_OUT_ENABLE,  // for i in 0 to R-1

    // Free Gate
    input WF_IN_I_ENABLE,  // for i in 0 to R-1
    input WF_IN_L_ENABLE,  // for l in 0 to L-1
    output reg F_OUT_ENABLE,  // for i in 0 to R-1

    // Read Mode
    input WPI_IN_I_ENABLE,  // for i in 0 to R-1
    input WPI_IN_L_ENABLE,  // for l in 0 to L-1
    output reg PI_OUT_ENABLE,  // for i in 0 to R-1

    // Hidden State
    input H_IN_ENABLE,  // for l in 0 to L-1

    // DATA
    input [DATA_SIZE-1:0] SIZE_W_IN,
    input [DATA_SIZE-1:0] SIZE_L_IN,
    input [DATA_SIZE-1:0] SIZE_R_IN,
    input [DATA_SIZE-1:0] WK_IN,
    input [DATA_SIZE-1:0] WBETA_IN,
    input [DATA_SIZE-1:0] WF_IN,
    input [DATA_SIZE-1:0] WPI_IN,
    input [DATA_SIZE-1:0] H_IN,
    output reg [DATA_SIZE-1:0] K_OUT,
    output reg [DATA_SIZE-1:0] BETA_OUT,
    output reg [DATA_SIZE-1:0] F_OUT,
    output reg [DATA_SIZE-1:0] PI_OUT
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
  wire [DATA_SIZE-1:0] data_a_in_tensor_product;
  wire [DATA_SIZE-1:0] data_b_in_tensor_product;
  wire [DATA_SIZE-1:0] data_out_tensor_product;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  // xi(t;?) = U(t;?;l)·h(t;l)

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
    .DATA_A_IN(data_a_in_tensor_product),
    .DATA_B_IN(data_b_in_tensor_product),
    .DATA_OUT(data_out_tensor_product)
  );

endmodule
