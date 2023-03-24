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

module model_backward_weighting #(
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

  output reg B_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
  output reg B_J_ENABLE,  // for j in 0 to N-1

  output reg B_OUT_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
  output reg B_OUT_J_ENABLE,  // for j in 0 to N-1

  // DATA
  input [DATA_SIZE-1:0] SIZE_R_IN,
  input [DATA_SIZE-1:0] SIZE_N_IN,

  input [DATA_SIZE-1:0] L_IN,
  input [DATA_SIZE-1:0] W_IN,

  output reg [DATA_SIZE-1:0] B_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  parameter [1:0] STARTER_STATE = 0;
  parameter [1:0] MATRIX_PRODUCT_STATE = 1;
  parameter [1:0] MATRIX_TRANSPOSE_STATE = 2;

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
  reg  [          1:0] controller_ctrl_fsm_int;

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

  // b(t;i;j) = transpose(L(t;g;j))·w(t-1;i;j)

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if (RST == 1'b0) begin
      // Data Outputs
      B_OUT <= ZERO_DATA;

      // Control Outputs
      READY <= 1'b0;
    end else begin
      case (controller_ctrl_fsm_int)
        STARTER_STATE: begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if (START == 1'b1) begin
            // FSM Control
            controller_ctrl_fsm_int <= MATRIX_PRODUCT_STATE;
          end
        end

        MATRIX_PRODUCT_STATE: begin  // STEP 1
        end

        MATRIX_TRANSPOSE_STATE: begin  // STEP 2

          // Data Outputs
          B_OUT <= data_out_matrix_product;
        end
        default: begin
          // FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // DATA
  // MATRIX TRANSPOSE
  assign size_i_in_matrix_transpose = SIZE_N_IN;
  assign size_j_in_matrix_transpose = SIZE_N_IN;
  assign data_in_matrix_transpose   = L_IN;

  // MATRIX PRODUCT
  assign size_a_i_in_matrix_product = SIZE_N_IN;
  assign size_a_j_in_matrix_product = SIZE_N_IN;
  assign size_b_i_in_matrix_product = SIZE_N_IN;
  assign size_b_j_in_matrix_product = ONE_CONTROL;
  assign data_a_in_matrix_product   = data_out_matrix_transpose;
  assign data_b_in_matrix_product   = W_IN;

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
