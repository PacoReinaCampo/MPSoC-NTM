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

module dnc_write_interface_vector #(
  parameter DATA_SIZE=512
)
  (
    // GLOBAL
    input CLK,
    input RST,

    // CONTROL
    input START,
    output reg READY,

    // Write Key
    input WK_IN_L_ENABLE,  // for l in 0 to L-1
    input WK_IN_K_ENABLE,  // for k in 0 to W-1

    output reg WK_OUT_L_ENABLE,  // for l in 0 to L-1
    output reg WK_OUT_K_ENABLE,  // for k in 0 to W-1

    output reg K_OUT_ENABLE,  // for k in 0 to W-1

    // Write Strength
    input WBETA_IN_ENABLE,  // for l in 0 to L-1

    output reg WBETA_OUT_ENABLE,  // for l in 0 to L-1

    // Erase Vector
    input WE_IN_L_ENABLE,  // for l in 0 to L-1
    input WE_IN_K_ENABLE,  // for k in 0 to W-1

    output reg WE_OUT_L_ENABLE,  // for l in 0 to L-1
    output reg WE_OUT_K_ENABLE,  // for k in 0 to W-1

    output reg E_OUT_ENABLE,  // for k in 0 to W-1

    // Write Vector
    input WV_IN_L_ENABLE,  // for l in 0 to L-1
    input WV_IN_K_ENABLE,  // for k in 0 to W-1

    output reg WV_OUT_L_ENABLE,  // for l in 0 to L-1
    output reg WV_OUT_K_ENABLE,  // for k in 0 to W-1

    output reg V_OUT_ENABLE,  // for k in 0 to W-1

    // Allocation Gate
    input WGA_IN_ENABLE,  // for l in 0 to L-1

    output reg WGA_OUT_ENABLE,  // for l in 0 to L-1

    // Write Gate
    input WGW_IN_ENABLE,  // for l in 0 to L-1

    output reg WGW_OUT_ENABLE,  // for l in 0 to L-1

    // Hidden State
    input H_IN_ENABLE,  // for l in 0 to L-1

    output reg H_OUT_ENABLE,  // for l in 0 to L-1

    // DATA
    input [DATA_SIZE-1:0] SIZE_W_IN,
    input [DATA_SIZE-1:0] SIZE_L_IN,
    input [DATA_SIZE-1:0] SIZE_R_IN,

    input [DATA_SIZE-1:0] WK_IN,
    input [DATA_SIZE-1:0] WBETA_IN,
    input [DATA_SIZE-1:0] WE_IN,
    input [DATA_SIZE-1:0] WV_IN,
    input [DATA_SIZE-1:0] WGA_IN,
    input [DATA_SIZE-1:0] WGW_IN,

    input [DATA_SIZE-1:0] H_IN,

    output reg [DATA_SIZE-1:0] K_OUT,
    output reg [DATA_SIZE-1:0] BETA_OUT,
    output reg [DATA_SIZE-1:0] E_OUT,
    output reg [DATA_SIZE-1:0] V_OUT,
    output reg [DATA_SIZE-1:0] GA_OUT,
    output reg [DATA_SIZE-1:0] GW_OUT
  );

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  parameter [2:0] STARTER_STATE = 0;
  parameter [2:0] MATRIX_FIRST_PRODUCT_STATE = 1;
  parameter [2:0] MATRIX_SECOND_PRODUCT_STATE = 2;
  parameter [2:0] MATRIX_THIRD_PRODUCT_STATE = 3;
  parameter [2:0] SCALAR_FIRST_PRODUCT_STATE = 4;
  parameter [2:0] SCALAR_SECOND_PRODUCT_STATE = 5;
  parameter [2:0] SCALAR_THIRD_PRODUCT_STATE = 6;

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  parameter ZERO = 0;
  parameter ONE = 1;
  parameter FULL = 1;

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

  // Finite State Machine
  reg [2:0] controller_ctrl_fsm_int;

  // SCALAR PRODUCT
  // CONTROL
  wire start_scalar_product;
  wire ready_scalar_product;

  wire data_a_in_enable_scalar_product;
  wire data_b_in_enable_scalar_product;
  wire data_out_enable_scalar_product;

  // DATA
  reg [DATA_SIZE-1:0] modulo_in_scalar_product;
  reg [DATA_SIZE-1:0] length_in_scalar_product;
  reg [DATA_SIZE-1:0] data_a_in_scalar_product;
  reg [DATA_SIZE-1:0] data_b_in_scalar_product;
  wire [DATA_SIZE-1:0] data_out_scalar_product;

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
  reg [DATA_SIZE-1:0] modulo_in_matrix_product;
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
      K_OUT    <= ZERO;
      BETA_OUT <= ZERO;
      E_OUT    <= ZERO;
      V_OUT    <= ZERO;
      GA_OUT   <= ZERO;
      GW_OUT   <= ZERO;

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
          modulo_in_matrix_product   <= FULL;
          size_a_i_in_matrix_product <= SIZE_W_IN;
          size_a_j_in_matrix_product <= SIZE_L_IN;
          size_b_i_in_matrix_product <= SIZE_L_IN;
          size_b_j_in_matrix_product <= ONE;
          data_a_in_matrix_product   <= WK_IN;
          data_b_in_matrix_product   <= H_IN;

          // Data Outputs
          K_OUT <= data_out_matrix_product;
        end

        MATRIX_SECOND_PRODUCT_STATE : begin  // STEP 2

          // Data Inputs
          modulo_in_matrix_product   <= FULL;
          size_a_i_in_matrix_product <= SIZE_W_IN;
          size_a_j_in_matrix_product <= SIZE_L_IN;
          size_b_i_in_matrix_product <= SIZE_L_IN;
          size_b_j_in_matrix_product <= ONE;
          data_a_in_matrix_product   <= WE_IN;
          data_b_in_matrix_product   <= H_IN;

          // Data Outputs
          E_OUT <= data_out_matrix_product;
        end

        MATRIX_THIRD_PRODUCT_STATE : begin  // STEP 3

          // Data Inputs
          modulo_in_matrix_product   <= FULL;
          size_a_i_in_matrix_product <= SIZE_W_IN;
          size_a_j_in_matrix_product <= SIZE_L_IN;
          size_b_i_in_matrix_product <= SIZE_L_IN;
          size_b_j_in_matrix_product <= ONE;
          data_a_in_matrix_product   <= WV_IN;
          data_b_in_matrix_product   <= H_IN;

          // Data Outputs
          V_OUT <= data_out_matrix_product;
        end

        SCALAR_FIRST_PRODUCT_STATE : begin  // STEP 4

          // Data Inputs
          modulo_in_scalar_product <= FULL;
          length_in_scalar_product <= SIZE_L_IN;
          data_a_in_scalar_product <= WBETA_IN;
          data_b_in_scalar_product <= H_IN;

          // Data Outputs
          BETA_OUT <= data_out_scalar_product;
        end

        SCALAR_SECOND_PRODUCT_STATE : begin  // STEP 5

          // Data Inputs
          modulo_in_scalar_product <= FULL;
          length_in_scalar_product <= SIZE_L_IN;
          data_a_in_scalar_product <= WGA_IN;
          data_b_in_scalar_product <= H_IN;

          // Data Outputs
          GA_OUT <= data_out_scalar_product;
        end

        SCALAR_THIRD_PRODUCT_STATE : begin  // STEP 6

          // Data Inputs
          modulo_in_scalar_product <= FULL;
          length_in_scalar_product <= SIZE_L_IN;
          data_a_in_scalar_product <= WGW_IN;
          data_b_in_scalar_product <= H_IN;

          // Data Outputs
          GW_OUT <= data_out_scalar_product;
        end
        default : begin
          // FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

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
