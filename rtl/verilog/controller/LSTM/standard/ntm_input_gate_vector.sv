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

module ntm_input_gate_vector(
  CLK,
  RST,
  START,
  READY,
  W_IN_L_ENABLE,
  W_IN_X_ENABLE,
  X_IN_ENABLE,
  K_IN_I_ENABLE,
  K_IN_L_ENABLE,
  K_IN_K_ENABLE,
  R_IN_I_ENABLE,
  R_IN_K_ENABLE,
  U_IN_ENABLE,
  H_IN_ENABLE,
  B_IN_ENABLE,
  I_OUT_ENABLE,
  SIZE_X_IN,
  SIZE_W_IN,
  SIZE_L_IN,
  SIZE_R_IN,
  W_IN,
  X_IN,
  K_IN,
  R_IN,
  U_IN,
  H_IN,
  B_IN,
  I_OUT
);

  parameter [31:0] DATA_SIZE=512;

  // GLOBAL
  input CLK;
  input RST;

  // CONTROL
  input START;
  output READY;

  input W_IN_L_ENABLE;// for l in 0 to L-1
  input W_IN_X_ENABLE;// for x in 0 to X-1
  input X_IN_ENABLE;// for x in 0 to X-1
  input K_IN_I_ENABLE;// for i in 0 to R-1 (read heads flow)
  input K_IN_L_ENABLE;// for l in 0 to L-1
  input K_IN_K_ENABLE;// for k in 0 to W-1
  input R_IN_I_ENABLE;// for i in 0 to R-1 (read heads flow)
  input R_IN_K_ENABLE;// for k in 0 to W-1
  input U_IN_ENABLE;// for l in 0 to L-1 (square matrix)
  input H_IN_ENABLE;// for l in 0 to L-1
  input B_IN_ENABLE;// for l in 0 to L-1
  output I_OUT_ENABLE;// for l in 0 to L-1

  // DATA
  input [DATA_SIZE-1:0] SIZE_X_IN;
  input [DATA_SIZE-1:0] SIZE_W_IN;
  input [DATA_SIZE-1:0] SIZE_L_IN;
  input [DATA_SIZE-1:0] SIZE_R_IN;
  input [DATA_SIZE-1:0] W_IN;
  input [DATA_SIZE-1:0] X_IN;
  input [DATA_SIZE-1:0] K_IN;
  input [DATA_SIZE-1:0] R_IN;
  input [DATA_SIZE-1:0] U_IN;
  input [DATA_SIZE-1:0] H_IN;
  input [DATA_SIZE-1:0] B_IN;
  output [DATA_SIZE-1:0] I_OUT;

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

  // VECTOR ADDER
  // CONTROL
  wire start_vector_adder;
  wire ready_vector_adder;
  wire operation_vector_adder;
  wire data_a_in_enable_vector_adder;
  wire data_b_in_enable_vector_adder;
  wire data_out_enable_vector_adder;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_adder;
  wire [DATA_SIZE-1:0] size_in_vector_adder;
  wire [DATA_SIZE-1:0] data_a_in_vector_adder;
  wire [DATA_SIZE-1:0] data_b_in_vector_adder;
  wire [DATA_SIZE-1:0] data_out_vector_adder;

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

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  // i(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + U(l;l)·h(t-1;l) + U(l-1;l-1)·h(t;l-1) + b(t;l))

  // VECTOR ADDER
  ntm_vector_adder #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_adder(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_adder),
    .READY(ready_vector_adder),

    .OPERATION(operation_vector_adder),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_adder),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_adder),
    .DATA_OUT_ENABLE(data_out_enable_vector_adder),

    // DATA
    .MODULO_IN(modulo_in_vector_adder),
    .SIZE_IN(size_in_vector_adder),
    .DATA_A_IN(data_a_in_vector_adder),
    .DATA_B_IN(data_b_in_vector_adder),
    .DATA_OUT(data_out_vector_adder)
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

endmodule
