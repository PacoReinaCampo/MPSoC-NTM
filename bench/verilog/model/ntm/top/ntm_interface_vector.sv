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

module ntm_interface_vector(
  CLK,
  RST,
  START,
  READY,
  WK_IN_L_ENABLE,
  WK_IN_K_ENABLE,
  K_OUT_ENABLE,
  WBETA_IN_ENABLE,
  WG_IN_ENABLE,
  WS_IN_L_ENABLE,
  WS_IN_J_ENABLE,
  S_OUT_ENABLE,
  WGAMMA_IN_ENABLE,
  H_IN_ENABLE,
  SIZE_N_IN,
  SIZE_W_IN,
  SIZE_L_IN,
  WK_IN,
  WBETA_IN,
  WG_IN,
  WS_IN,
  WGAMMA_IN,
  H_IN,
  K_OUT,
  BETA_OUT,
  G_OUT,
  S_OUT,
  GAMMA_OUT
);

  parameter DATA_SIZE=512;

  // GLOBAL
  input CLK;
  input RST;

  // CONTROL
  input START;
  output READY;

  // Key Vector
  input WK_IN_L_ENABLE;  // for l in 0 to L-1
  input WK_IN_K_ENABLE;  // for k in 0 to W-1
  output K_OUT_ENABLE;  // for k in 0 to W-1

  // Key Strength
  input WBETA_IN_ENABLE;  // for l in 0 to L-1

  // Interpolation Gate
  input WG_IN_ENABLE;  // for l in 0 to L-1

  // Shift Weighting
  input WS_IN_L_ENABLE;  // for l in 0 to L-1
  input WS_IN_J_ENABLE;  // for j in 0 to N-1
  output S_OUT_ENABLE;  // for j in 0 to N-1

  // Sharpening
  input WGAMMA_IN_ENABLE;  // for l in 0 to L-1

  // Hidden State
  input H_IN_ENABLE;  // for l in 0 to L-1

  // DATA
  input [DATA_SIZE-1:0] SIZE_N_IN;
  input [DATA_SIZE-1:0] SIZE_W_IN;
  input [DATA_SIZE-1:0] SIZE_L_IN;
  input [DATA_SIZE-1:0] WK_IN;
  input [DATA_SIZE-1:0] WBETA_IN;
  input [DATA_SIZE-1:0] WG_IN;
  input [DATA_SIZE-1:0] WS_IN;
  input [DATA_SIZE-1:0] WGAMMA_IN;
  input [DATA_SIZE-1:0] H_IN;
  output [DATA_SIZE-1:0] K_OUT;
  output [DATA_SIZE-1:0] BETA_OUT;
  output [DATA_SIZE-1:0] G_OUT;
  output [DATA_SIZE-1:0] S_OUT;
  output [DATA_SIZE-1:0] GAMMA_OUT;

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

endmodule
