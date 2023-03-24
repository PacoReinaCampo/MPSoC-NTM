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

module model_forward_weighting #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 64
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input      START,
  output reg READY,

  input L_IN_G_ENABLE,  // for g in 0 to N-1 (square matrix)
  input L_IN_J_ENABLE,  // for j in 0 to N-1 (square matrix)

  input W_IN_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
  input W_IN_J_ENABLE,  // for j in 0 to N-1

  output reg F_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
  output reg F_J_ENABLE,  // for j in 0 to N-1

  output reg F_OUT_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
  output reg F_OUT_J_ENABLE,  // for j in 0 to N-1

  // DATA
  input [DATA_SIZE-1:0] SIZE_R_IN,
  input [DATA_SIZE-1:0] SIZE_N_IN,

  input [DATA_SIZE-1:0] L_IN,
  input [DATA_SIZE-1:0] W_IN,

  output reg [DATA_SIZE-1:0] F_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  parameter ZERO_CONTROL = 0;
  parameter ONE_CONTROL = 1;
  parameter TWO_CONTROL = 2;
  parameter THREE_CONTROL = 3;

  parameter ZERO_DATA = 0;
  parameter ONE_DATA = 1;
  parameter TWO_DATA = 2;
  parameter THREE_DATA = 3;

  parameter FULL = 1;
  parameter EMPTY = 0;

  parameter EULER = 0;

  //////////////////////////////////////////////////////////////////////////////
  // Signals
  //////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // f(t;i;j) = L(t;g;j)·w(t-1;i;j)

  // ASSIGNATIONS
  // CONTROL
  assign start_matrix_product              = START;
  assign READY                             = ready_matrix_product;
  assign data_a_in_i_enable_matrix_product = L_IN_G_ENABLE;
  assign data_a_in_j_enable_matrix_product = L_IN_J_ENABLE;
  assign data_b_in_i_enable_matrix_product = W_IN_I_ENABLE;
  assign data_b_in_j_enable_matrix_product = W_IN_J_ENABLE;
  assign F_OUT_I_ENABLE                    = data_out_i_enable_matrix_product;
  assign F_OUT_J_ENABLE                    = data_out_j_enable_matrix_product;

  // DATA
  assign size_a_i_in_matrix_product        = SIZE_N_IN;
  assign size_a_j_in_matrix_product        = SIZE_N_IN;
  assign size_b_i_in_matrix_product        = SIZE_R_IN;
  assign size_b_j_in_matrix_product        = SIZE_N_IN;
  assign data_a_in_matrix_product          = L_IN;
  assign data_b_in_matrix_product          = W_IN;
  assign F_OUT                             = data_out_matrix_product;

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

endmodule
