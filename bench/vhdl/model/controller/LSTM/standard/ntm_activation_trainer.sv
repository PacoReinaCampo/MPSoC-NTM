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

module ntm_activation_trainer #(
  parameter DATA_SIZE=512
)
  (
    // GLOBAL
    input CLK,
    input RST,

    // CONTROL
    input START,
    output reg READY,

    input H_IN_ENABLE,  // for l in 0 to L-1
    input X_IN_ENABLE,  // for l in 0 to L-1
    input A_IN_ENABLE,  // for l in 0 to L-1
    input I_IN_ENABLE,  // for l in 0 to L-1
    input S_IN_ENABLE,  // for l in 0 to L-1
    output reg W_OUT_L_ENABLE,  // for l in 0 to L-1
    output reg W_OUT_X_ENABLE,  // for x in 0 to X-1
    output reg K_OUT_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
    output reg K_OUT_L_ENABLE,  // for l in 0 to L-1
    output reg K_OUT_K_ENABLE,  // for k in 0 to W-1
    output reg B_OUT_ENABLE,  // for l in 0 to L-1

    // DATA
    input [DATA_SIZE-1:0] SIZE_X_IN,
    input [DATA_SIZE-1:0] SIZE_W_IN,
    input [DATA_SIZE-1:0] SIZE_L_IN,
    input [DATA_SIZE-1:0] SIZE_R_IN,
    input [DATA_SIZE-1:0] H_IN,
    input [DATA_SIZE-1:0] X_IN,
    input [DATA_SIZE-1:0] A_IN,
    input [DATA_SIZE-1:0] I_IN,
    input [DATA_SIZE-1:0] S_IN,
    output reg [DATA_SIZE-1:0] W_OUT,
    output reg [DATA_SIZE-1:0] K_OUT,
    output reg [DATA_SIZE-1:0] B_OUT
  );

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  parameter [2:0] STARTER_STATE = 0;
  parameter [2:0] VECTOR_DIFFERENTIATION_A_STATE = 1;
  parameter [2:0] VECTOR_DIFFERENTIATION_W_STATE = 2;
  parameter [2:0] VECTOR_DIFFERENTIATION_K_STATE = 3;
  parameter [2:0] VECTOR_DIFFERENTIATION_B_STATE = 4;
  parameter [2:0] ENDER_STATE = 5;

  parameter [2:0] STARTER_DA_STATE = 0;
  parameter [2:0] VECTOR_EXPONENTIATOR_DA_STATE = 1;
  parameter [2:0] VECTOR_ADDER_DA_STATE = 2;
  parameter [2:0] VECTOR_FIRST_MULTIPLIER_DA_STATE = 3;
  parameter [2:0] VECTOR_SECOND_MULTIPLIER_DA_STATE = 4;
  parameter [2:0] ENDER_DA_STATE = 5;

  parameter [2:0] STARTER_DW_STATE = 0;
  parameter [2:0] VECTOR_DIFFERENTIATION_DW_STATE = 1;
  parameter [2:0] MATRIX_PRODUCT_DW_STATE = 2;
  parameter [2:0] VECTOR_SUMMATION_DW_STATE = 3;
  parameter [2:0] ENDER_DW_STATE = 4;

  parameter [2:0] STARTER_DK_STATE = 0;
  parameter [2:0] VECTOR_DIFFERENTIATION_DK_STATE = 1;
  parameter [2:0] MATRIX_PRODUCT_DK_STATE = 2;
  parameter [2:0] VECTOR_SUMMATION_DK_STATE = 3;
  parameter [2:0] ENDER_DK_STATE = 4;

  parameter [1:0] STARTER_DB_STATE = 0;
  parameter [1:0] VECTOR_DIFFERENTIATION_DB_STATE = 1;
  parameter [1:0] VECTOR_SUMMATION_DB_STATE = 2;
  parameter [1:0] ENDER_DB_STATE = 3;

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

  reg [2:0] differentiation_a_ctrl_fsm_int;
  reg [2:0] differentiation_w_ctrl_fsm_int;
  reg [2:0] differentiation_k_ctrl_fsm_int;
  reg [1:0] differentiation_b_ctrl_fsm_int;

  // VECTOR SUMMATION
  // CONTROL
  wire start_vector_summation;
  wire ready_vector_summation;
  wire data_in_vector_enable_vector_summation;
  wire data_in_scalar_enable_vector_summation;
  wire data_out_vector_enable_vector_summation;
  wire data_out_scalar_enable_vector_summation;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_summation;
  wire [DATA_SIZE-1:0] size_in_vector_summation;
  wire [DATA_SIZE-1:0] length_in_vector_summation;
  wire [DATA_SIZE-1:0] data_in_vector_summation;
  wire [DATA_SIZE-1:0] data_out_vector_summation;

  // VECTOR MULTIPLIER
  // CONTROL
  wire start_vector_multiplier;
  wire ready_vector_multiplier;
  wire data_a_in_enable_vector_multiplier;
  wire data_b_in_enable_vector_multiplier;
  wire data_out_enable_vector_multiplier;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_multiplier;
  wire [DATA_SIZE-1:0] size_in_vector_multiplier;
  wire [DATA_SIZE-1:0] data_a_in_vector_multiplier;
  wire [DATA_SIZE-1:0] data_b_in_vector_multiplier;
  wire [DATA_SIZE-1:0] data_out_vector_multiplier;

  // VECTOR EXPONENTIATOR
  // CONTROL
  wire start_vector_exponentiator;
  wire ready_vector_exponentiator;

  wire data_a_in_enable_vector_exponentiator;
  wire data_b_in_enable_vector_exponentiator;
  wire data_out_enable_vector_exponentiator;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_exponentiator;
  wire [DATA_SIZE-1:0] size_in_vector_exponentiator;
  wire [DATA_SIZE-1:0] data_a_in_vector_exponentiator;
  wire [DATA_SIZE-1:0] data_b_in_vector_exponentiator;
  wire [DATA_SIZE-1:0] data_out_vector_exponentiator;

  // VECTOR DIFFERENTIATION
  // CONTROL
  wire start_vector_differentiation;
  wire ready_vector_differentiation;

  wire data_in_enable_vector_differentiation;
  wire data_out_enable_vector_differentiation;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_differentiation;
  wire [DATA_SIZE-1:0] size_in_vector_differentiation;
  wire [DATA_SIZE-1:0] data_in_vector_differentiation;
  wire [DATA_SIZE-1:0] data_out_vector_differentiation;

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

  // da(t;l) = ds(t;l) o i(t;l) o (1 - a(t;l)^2)
  // dW(t;l) = summation(da(t;l) · x(t;l))[t in 0 to T]
  // dU(t;l) = summation(da(t+1;l) · h(t;l))[t in 0 to T-1]
  // db(t;l) = summation(da(t;l))[t in 0 to T]

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if(RST == 1'b0) begin
      // Data Outputs
      W_OUT <= ZERO;
      K_OUT <= ZERO;
      B_OUT <= ZERO;

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
            controller_ctrl_fsm_int <= VECTOR_DIFFERENTIATION_A_STATE;
          end
        end

        VECTOR_DIFFERENTIATION_A_STATE : begin  // STEP 1

          case(differentiation_a_ctrl_fsm_int)
            STARTER_DA_STATE : begin  // STEP 0
            end

            VECTOR_EXPONENTIATOR_DA_STATE : begin  // STEP 1
            end

            VECTOR_ADDER_DA_STATE : begin  // STEP 2
            end

            VECTOR_FIRST_MULTIPLIER_DA_STATE : begin  // STEP 3
            end

            VECTOR_SECOND_MULTIPLIER_DA_STATE : begin  // STEP 4
            end

            ENDER_DA_STATE : begin  // STEP 5
            end

            default : begin
              // FSM Control
              differentiation_a_ctrl_fsm_int <= STARTER_DA_STATE;
            end
          endcase
        end

        VECTOR_DIFFERENTIATION_W_STATE : begin  // STEP 1

          case(differentiation_w_ctrl_fsm_int)
            STARTER_DW_STATE : begin  // STEP 0
            end

            VECTOR_DIFFERENTIATION_DW_STATE : begin  // STEP 1
            end

            MATRIX_PRODUCT_DW_STATE : begin  // STEP 2
            end

            VECTOR_SUMMATION_DW_STATE : begin  // STEP 3
            end

            ENDER_DW_STATE : begin  // STEP 4
            end

            default : begin
              // FSM Control
              differentiation_w_ctrl_fsm_int <= STARTER_DW_STATE;
            end
          endcase
        end

        VECTOR_DIFFERENTIATION_K_STATE : begin  // STEP 2

          case(differentiation_k_ctrl_fsm_int)
            STARTER_DK_STATE : begin  // STEP 0
            end

            VECTOR_DIFFERENTIATION_DK_STATE : begin  // STEP 1
            end

            MATRIX_PRODUCT_DK_STATE : begin  // STEP 2
            end

            VECTOR_SUMMATION_DK_STATE : begin  // STEP 3
            end

            ENDER_DK_STATE : begin  // STEP 4
            end

            default : begin
              // FSM Control
              differentiation_k_ctrl_fsm_int <= STARTER_DK_STATE;
            end
          endcase
        end

        VECTOR_DIFFERENTIATION_B_STATE : begin  // STEP 3

          case(differentiation_b_ctrl_fsm_int)
            STARTER_DB_STATE : begin  // STEP 0
            end

            VECTOR_DIFFERENTIATION_DB_STATE : begin  // STEP 1
            end

            VECTOR_SUMMATION_DB_STATE : begin  // STEP 2
            end

            ENDER_DB_STATE : begin  // STEP 3
            end

            default : begin
              // FSM Control
              differentiation_b_ctrl_fsm_int <= STARTER_DB_STATE;
            end
          endcase
        end

        ENDER_STATE : begin  // STEP 4
        end

        default : begin
          // FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // VECTOR SUMMATION
  ntm_vector_summation_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_summation_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_summation),
    .READY(ready_vector_summation),

    .DATA_IN_VECTOR_ENABLE(data_in_vector_enable_vector_summation),
    .DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_vector_summation),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_summation),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_summation),

    // DATA
    .MODULO_IN(modulo_in_vector_summation),
    .SIZE_IN(size_in_vector_summation),
    .LENGTH_IN(length_in_vector_summation),
    .DATA_IN(data_in_vector_summation),
    .DATA_OUT(data_out_vector_summation)
  );

  // VECTOR MULTIPLIER
  ntm_vector_multiplier #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_multiplier(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_multiplier),
    .READY(ready_vector_multiplier),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_multiplier),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_multiplier),
    .DATA_OUT_ENABLE(data_out_enable_vector_multiplier),

    // DATA
    .MODULO_IN(modulo_in_vector_multiplier),
    .SIZE_IN(size_in_vector_multiplier),
    .DATA_A_IN(data_a_in_vector_multiplier),
    .DATA_B_IN(data_b_in_vector_multiplier),
    .DATA_OUT(data_out_vector_multiplier)
  );

  // VECTOR EXPONENTIATOR
  ntm_vector_exponentiator #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_exponentiator(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_exponentiator),
    .READY(ready_vector_exponentiator),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_exponentiator),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_exponentiator),
    .DATA_OUT_ENABLE(data_out_enable_vector_exponentiator),

    // DATA
    .MODULO_IN(modulo_in_vector_exponentiator),
    .SIZE_IN(size_in_vector_exponentiator),
    .DATA_A_IN(data_a_in_vector_exponentiator),
    .DATA_B_IN(data_b_in_vector_exponentiator),
    .DATA_OUT(data_out_vector_exponentiator)
  );

  // VECTOR DIFFERENTIATION
  ntm_vector_differentiation_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_differentiation_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_differentiation),
    .READY(ready_vector_differentiation),

    .DATA_IN_ENABLE(data_in_enable_vector_differentiation),
    .DATA_OUT_ENABLE(data_out_enable_vector_differentiation),

    // DATA
    .MODULO_IN(modulo_in_vector_differentiation),
    .SIZE_IN(size_in_vector_differentiation),
    .DATA_IN(data_in_vector_differentiation),
    .DATA_OUT(data_out_vector_differentiation)
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