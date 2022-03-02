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

module ntm_interface_vector #(
  parameter DATA_SIZE=64,
  parameter CONTROL_SIZE=64
)
  (
    // GLOBAL
    input CLK,
    input RST,

    // CONTROL
    input START,
    output reg READY,

    // Key Vector
    input WK_IN_L_ENABLE,  // for l in 0 to L-1
    input WK_IN_K_ENABLE,  // for k in 0 to W-1

    output reg WK_OUT_L_ENABLE,  // for l in 0 to L-1
    output reg WK_OUT_K_ENABLE,  // for k in 0 to W-1

    output reg K_OUT_ENABLE,  // for k in 0 to W-1

    // Key Strength
    input WBETA_IN_ENABLE,  // for l in 0 to L-1

    output reg WBETA_OUT_ENABLE,  // for l in 0 to L-1

    // Interpolation Gate
    input WG_IN_ENABLE,  // for l in 0 to L-1

    output reg WG_OUT_ENABLE,  // for l in 0 to L-1

    // Shift Weighting
    input WS_IN_L_ENABLE,  // for l in 0 to L-1
    input WS_IN_J_ENABLE,  // for j in 0 to N-1

    output reg WS_OUT_L_ENABLE,  // for l in 0 to L-1
    output reg WS_OUT_J_ENABLE,  // for j in 0 to N-1

    output reg S_OUT_ENABLE,  // for j in 0 to N-1

    // Sharpening
    input WGAMMA_IN_ENABLE,  // for l in 0 to L-1

    output reg WGAMMA_OUT_ENABLE,  // for l in 0 to L-1

    // Hidden State
    input H_IN_ENABLE,  // for l in 0 to L-1

    // DATA
    input [DATA_SIZE-1:0] SIZE_N_IN,
    input [DATA_SIZE-1:0] SIZE_W_IN,
    input [DATA_SIZE-1:0] SIZE_L_IN,

    input [DATA_SIZE-1:0] WK_IN,
    input [DATA_SIZE-1:0] WBETA_IN,
    input [DATA_SIZE-1:0] WG_IN,
    input [DATA_SIZE-1:0] WS_IN,
    input [DATA_SIZE-1:0] WGAMMA_IN,
    input [DATA_SIZE-1:0] H_IN,

    output reg [DATA_SIZE-1:0] K_OUT,
    output reg [DATA_SIZE-1:0] BETA_OUT,
    output reg [DATA_SIZE-1:0] G_OUT,
    output reg [DATA_SIZE-1:0] S_OUT,
    output reg [DATA_SIZE-1:0] GAMMA_OUT
  );

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  parameter [2:0] STARTER_STATE = 0;
  parameter [2:0] MATRIX_FIRST_PRODUCT_STATE = 1;
  parameter [2:0] MATRIX_SECOND_PRODUCT_STATE = 2;
  parameter [2:0] SCALAR_FIRST_PRODUCT_STATE = 3;
  parameter [2:0] SCALAR_SECOND_PRODUCT_STATE = 4;
  parameter [2:0] SCALAR_THIRD_PRODUCT_STATE = 5;

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  parameter ZERO_CONTROL  = 0;
  parameter ONE_CONTROL   = 1;
  parameter TWO_CONTROL   = 2;
  parameter THREE_CONTROL = 3;

  parameter ZERO_DATA  = 0;
  parameter ONE_DATA   = 1;
  parameter TWO_DATA   = 2;
  parameter THREE_DATA = 3;

  parameter FULL  = 1;
  parameter EMPTY = 0;

  parameter EULER = 0;

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

  // Finite State Machine
  reg [2:0] controller_ctrl_fsm_int;

  // SCALAR PRODUCT
  // CONTROL
  wire start_dot_product;
  wire ready_dot_product;

  wire data_a_in_enable_dot_product;
  wire data_b_in_enable_dot_product;
  wire data_out_enable_dot_product;

  // DATA
  reg [DATA_SIZE-1:0] length_in_dot_product;
  reg [DATA_SIZE-1:0] data_a_in_dot_product;
  reg [DATA_SIZE-1:0] data_b_in_dot_product;
  wire [DATA_SIZE-1:0] data_out_dot_product;

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
  reg [DATA_SIZE-1:0] size_a_i_in_matrix_product;
  reg [DATA_SIZE-1:0] size_a_j_in_matrix_product;
  reg [DATA_SIZE-1:0] size_b_i_in_matrix_product;
  reg [DATA_SIZE-1:0] size_b_j_in_matrix_product;
  reg [DATA_SIZE-1:0] data_a_in_matrix_product;
  reg [DATA_SIZE-1:0] data_b_in_matrix_product;
  wire [DATA_SIZE-1:0] data_out_matrix_product;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  // xi(t;?) = U(t;?;l)·h(t;l)

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if(RST == 1'b0) begin
      // Data Outputs
      K_OUT     <= ZERO_DATA;
      BETA_OUT  <= ZERO_DATA;
      G_OUT     <= ZERO_DATA;
      S_OUT     <= ZERO_DATA;
      GAMMA_OUT <= ZERO_DATA;

      // Control Outputs
      READY <= 1'b0;
    end
    else begin
      case(controller_ctrl_fsm_int)
        STARTER_STATE : begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if(START == 1'b1) begin
            // FSM Control
            controller_ctrl_fsm_int <= MATRIX_FIRST_PRODUCT_STATE;
          end
        end

        MATRIX_FIRST_PRODUCT_STATE : begin  // STEP 1

          // Data Inputs
          size_a_i_in_matrix_product <= SIZE_W_IN;
          size_a_j_in_matrix_product <= SIZE_L_IN;
          size_b_i_in_matrix_product <= SIZE_L_IN;
          size_b_j_in_matrix_product <= ONE_CONTROL;
          data_a_in_matrix_product   <= WK_IN;
          data_b_in_matrix_product   <= H_IN;

          // Data Outputs
          K_OUT <= data_out_matrix_product;
        end

        MATRIX_SECOND_PRODUCT_STATE : begin  // STEP 2

          // Data Inputs
          size_a_i_in_matrix_product <= SIZE_N_IN;
          size_a_j_in_matrix_product <= SIZE_L_IN;
          size_b_i_in_matrix_product <= SIZE_L_IN;
          size_b_j_in_matrix_product <= ONE_CONTROL;
          data_a_in_matrix_product   <= WS_IN;
          data_b_in_matrix_product   <= H_IN;

          // Data Outputs
          S_OUT <= data_out_matrix_product;
        end

        SCALAR_FIRST_PRODUCT_STATE : begin  // STEP 3

          // Data Inputs
          length_in_dot_product <= SIZE_L_IN;
          data_a_in_dot_product <= WBETA_IN;
          data_b_in_dot_product <= H_IN;

          // Data Outputs
          BETA_OUT <= data_out_dot_product;
        end

        SCALAR_SECOND_PRODUCT_STATE : begin  // STEP 4

          // Data Inputs
          length_in_dot_product <= SIZE_L_IN;
          data_a_in_dot_product <= WG_IN;
          data_b_in_dot_product <= H_IN;

          // Data Outputs
          G_OUT <= data_out_dot_product;
        end

        SCALAR_THIRD_PRODUCT_STATE : begin  // STEP 5

          // Data Inputs
          length_in_dot_product <= SIZE_L_IN;
          data_a_in_dot_product <= WGAMMA_IN;
          data_b_in_dot_product <= H_IN;

          // Data Outputs
          GAMMA_OUT <= data_out_dot_product;
        end
        default : begin
          // FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // SCALAR PRODUCT
  ntm_dot_product #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  )
  dot_product(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_dot_product),
    .READY(ready_dot_product),

    .DATA_A_IN_ENABLE(data_a_in_enable_dot_product),
    .DATA_B_IN_ENABLE(data_b_in_enable_dot_product),
    .DATA_OUT_ENABLE(data_out_enable_dot_product),

    // DATA
    .LENGTH_IN(length_in_dot_product),
    .DATA_A_IN(data_a_in_dot_product),
    .DATA_B_IN(data_b_in_dot_product),
    .DATA_OUT(data_out_dot_product)
  );

  // MATRIX PRODUCT
  ntm_matrix_product #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
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
    .SIZE_A_I_IN(size_a_i_in_matrix_product),
    .SIZE_A_J_IN(size_a_j_in_matrix_product),
    .SIZE_B_I_IN(size_b_i_in_matrix_product),
    .SIZE_B_J_IN(size_b_j_in_matrix_product),
    .DATA_A_IN(data_a_in_matrix_product),
    .DATA_B_IN(data_b_in_matrix_product),
    .DATA_OUT(data_out_matrix_product)
  );

endmodule
