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

module model_output_vector #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 64
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input      START,
  output reg READY,

  input K_IN_I_ENABLE,  // for i in 0 to R-1
  input K_IN_Y_ENABLE,  // for y in 0 to Y-1
  input K_IN_K_ENABLE,  // for k in 0 to W-1

  output reg K_OUT_I_ENABLE,  // for i in 0 to R-1
  output reg K_OUT_Y_ENABLE,  // for y in 0 to Y-1
  output reg K_OUT_K_ENABLE,  // for k in 0 to W-1

  input R_IN_I_ENABLE,  // for i in 0 to R-1
  input R_IN_K_ENABLE,  // for j in 0 to W-1

  output reg R_OUT_I_ENABLE,  // for i in 0 to R-1
  output reg R_OUT_K_ENABLE,  // for j in 0 to W-1

  input U_IN_Y_ENABLE,  // for y in 0 to Y-1
  input U_IN_L_ENABLE,  // for l in 0 to L-1

  output reg U_OUT_Y_ENABLE,  // for y in 0 to Y-1
  output reg U_OUT_L_ENABLE,  // for l in 0 to L-1

  input H_IN_ENABLE,  // for l in 0 to L-1

  output reg H_OUT_ENABLE,  // for l in 0 to L-1

  output reg Y_OUT_ENABLE,  // for y in 0 to Y-1

  // DATA
  input [DATA_SIZE-1:0] SIZE_Y_IN,
  input [DATA_SIZE-1:0] SIZE_L_IN,
  input [DATA_SIZE-1:0] SIZE_W_IN,
  input [DATA_SIZE-1:0] SIZE_R_IN,

  input [DATA_SIZE-1:0] K_IN,
  input [DATA_SIZE-1:0] R_IN,

  input [DATA_SIZE-1:0] U_IN,
  input [DATA_SIZE-1:0] H_IN,

  output reg [DATA_SIZE-1:0] Y_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  parameter [2:0] STARTER_STATE = 0;
  parameter [2:0] MATRIX_FIRST_PRODUCT_I_STATE = 1;
  parameter [2:0] MATRIX_FIRST_PRODUCT_J_STATE = 2;
  parameter [2:0] MATRIX_SECOND_PRODUCT_I_STATE = 3;
  parameter [2:0] MATRIX_SECOND_PRODUCT_J_STATE = 4;
  parameter [2:0] VECTOR_SUMMATION_STATE = 5;

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

  // Finite State Machine
  reg  [          1:0] output_vector_ctrl_fsm_int;

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

  // VECTOR SUMMATION
  // CONTROL
  wire                 start_vector_summation;
  wire                 ready_vector_summation;

  wire                 data_in_vector_enable_vector_summation;
  wire                 data_in_scalar_enable_vector_summation;
  wire                 data_out_vector_enable_vector_summation;
  wire                 data_out_scalar_enable_vector_summation;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_summation;
  wire [DATA_SIZE-1:0] length_in_vector_summation;
  wire [DATA_SIZE-1:0] data_in_vector_summation;
  wire [DATA_SIZE-1:0] data_out_vector_summation;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // y(t;y) = K(i;y;k)·r(t;i;k) + U(y;l)·h(t;l)

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if (RST == 1'b0) begin
      // Data Outputs
      Y_OUT <= ZERO_DATA;

      // Control Outputs
      READY <= 1'b0;
    end else begin
      case (output_vector_ctrl_fsm_int)
        STARTER_STATE: begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if (START == 1'b1) begin
            // FSM Control
            output_vector_ctrl_fsm_int <= MATRIX_FIRST_PRODUCT_I_STATE;
          end
        end

        MATRIX_FIRST_PRODUCT_I_STATE: begin  // STEP 1
        end

        MATRIX_FIRST_PRODUCT_J_STATE: begin  // STEP 2
        end

        MATRIX_SECOND_PRODUCT_I_STATE: begin  // STEP 3
        end

        MATRIX_SECOND_PRODUCT_J_STATE: begin  // STEP 4
        end

        VECTOR_SUMMATION_STATE: begin  // STEP 5

          // Data Outputs
          Y_OUT <= data_out_vector_summation;
        end
        default: begin
          // FSM Control
          output_vector_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // DATA
  // MATRIX PRODUCT
  assign size_a_i_in_matrix_product = SIZE_Y_IN;
  assign size_a_j_in_matrix_product = SIZE_R_IN;
  assign size_b_i_in_matrix_product = SIZE_Y_IN;
  assign size_b_j_in_matrix_product = SIZE_R_IN;
  assign data_a_in_matrix_product   = K_IN;
  assign data_b_in_matrix_product   = R_IN;

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

  // VECTOR SUMMATION
  model_vector_summation #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_summation (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_summation),
    .READY(ready_vector_summation),

    .DATA_IN_VECTOR_ENABLE (data_in_vector_enable_vector_summation),
    .DATA_IN_SCALAR_ENABLE (data_in_scalar_enable_vector_summation),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_summation),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_summation),

    // DATA
    .SIZE_IN  (size_in_vector_summation),
    .LENGTH_IN(length_in_vector_summation),
    .DATA_IN  (data_in_vector_summation),
    .DATA_OUT (data_out_vector_summation)
  );

endmodule
