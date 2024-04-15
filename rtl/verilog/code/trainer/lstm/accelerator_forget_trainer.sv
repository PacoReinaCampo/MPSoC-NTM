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

module accelerator_forget_trainer #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 4
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input      START,
  output reg READY,

  input X_IN_ENABLE,  // for x in 0 to X-1

  output reg X_OUT_ENABLE,  // for x in 0 to X-1

  input R_IN_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
  input R_IN_K_ENABLE,  // for k in 0 to W-1

  output reg R_OUT_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
  output reg R_OUT_K_ENABLE,  // for k in 0 to W-1

  input H_IN_ENABLE,  // for l in 0 to L-1

  output reg H_OUT_ENABLE,  // for l in 0 to L-1

  input F_IN_ENABLE,  // for l in 0 to L-1
  input S_IN_ENABLE,  // for l in 0 to L-1

  output reg F_OUT_ENABLE,  // for l in 0 to L-1
  output reg S_OUT_ENABLE,  // for l in 0 to L-1

  output reg W_OUT_L_ENABLE,  // for l in 0 to L-1
  output reg W_OUT_X_ENABLE,  // for x in 0 to X-1

  output reg K_OUT_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
  output reg K_OUT_L_ENABLE,  // for l in 0 to L-1
  output reg K_OUT_K_ENABLE,  // for k in 0 to W-1

  output reg U_OUT_L_ENABLE,  // for l in 0 to L-1
  output reg U_OUT_P_ENABLE,  // for p in 0 to L-1

  output reg B_OUT_ENABLE,  // for l in 0 to L-1

  // DATA
  input [DATA_SIZE-1:0] SIZE_X_IN,
  input [DATA_SIZE-1:0] SIZE_W_IN,
  input [DATA_SIZE-1:0] SIZE_L_IN,
  input [DATA_SIZE-1:0] SIZE_R_IN,

  input [DATA_SIZE-1:0] X_IN,
  input [DATA_SIZE-1:0] R_IN,
  input [DATA_SIZE-1:0] H_IN,

  input [DATA_SIZE-1:0] F_IN,
  input [DATA_SIZE-1:0] S_IN,

  output reg [DATA_SIZE-1:0] W_OUT,
  output reg [DATA_SIZE-1:0] K_OUT,
  output reg [DATA_SIZE-1:0] U_OUT,
  output reg [DATA_SIZE-1:0] B_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  parameter [2:0] STARTER_STATE = 0;
  parameter [2:0] VECTOR_DIFFERENTIATION_F_STATE = 1;
  parameter [2:0] VECTOR_DIFFERENTIATION_W_STATE = 2;
  parameter [2:0] VECTOR_DIFFERENTIATION_K_STATE = 3;
  parameter [2:0] VECTOR_DIFFERENTIATION_U_STATE = 4;
  parameter [2:0] VECTOR_DIFFERENTIATION_B_STATE = 5;

  parameter [2:0] STARTER_DF_STATE = 0;
  parameter [2:0] VECTOR_ADDER_DF_STATE = 1;
  parameter [2:0] VECTOR_FIRST_MULTIPLIER_DF_STATE = 2;
  parameter [2:0] VECTOR_SECOND_MULTIPLIER_DF_STATE = 3;
  parameter [2:0] VECTOR_THIRD_MULTIPLIER_DF_STATE = 4;

  parameter [2:0] STARTER_DW_STATE = 0;
  parameter [2:0] VECTOR_DIFFERENTIATION_DW_STATE = 1;
  parameter [2:0] MATRIX_PRODUCT_DW_STATE = 2;
  parameter [2:0] VECTOR_SUMMATION_DW_STATE = 3;

  parameter [2:0] STARTER_DK_STATE = 0;
  parameter [2:0] VECTOR_DIFFERENTIATION_DK_STATE = 1;
  parameter [2:0] MATRIX_PRODUCT_DK_STATE = 2;
  parameter [2:0] VECTOR_SUMMATION_DK_STATE = 3;

  parameter [2:0] STARTER_DU_STATE = 0;
  parameter [2:0] VECTOR_DIFFERENTIATION_DU_STATE = 1;
  parameter [2:0] MATRIX_PRODUCT_DU_STATE = 2;
  parameter [2:0] VECTOR_SUMMATION_DU_STATE = 3;

  parameter [1:0] STARTER_DB_STATE = 0;
  parameter [1:0] VECTOR_DIFFERENTIATION_DB_STATE = 1;
  parameter [1:0] VECTOR_SUMMATION_DB_STATE = 2;

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
  reg  [          2:0] controller_ctrl_fsm_int;

  reg  [          2:0] differentiation_f_ctrl_fsm_int;
  reg  [          2:0] differentiation_w_ctrl_fsm_int;
  reg  [          2:0] differentiation_k_ctrl_fsm_int;
  reg  [          2:0] differentiation_u_ctrl_fsm_int;
  reg  [          1:0] differentiation_b_ctrl_fsm_int;

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

  // VECTOR MULTIPLIER
  // CONTROL
  wire                 start_vector_float_multiplier;
  wire                 ready_vector_float_multiplier;

  wire                 data_a_in_enable_vector_float_multiplier;
  wire                 data_b_in_enable_vector_float_multiplier;
  wire                 data_out_enable_vector_float_multiplier;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_float_multiplier;
  wire [DATA_SIZE-1:0] data_a_in_vector_float_multiplier;
  wire [DATA_SIZE-1:0] data_b_in_vector_float_multiplier;
  wire [DATA_SIZE-1:0] data_out_vector_float_multiplier;

  // VECTOR ADDER
  // CONTROL
  wire                 start_vector_float_adder;
  wire                 ready_vector_float_adder;

  wire                 operation_vector_float_adder;

  wire                 data_a_in_enable_vector_float_adder;
  wire                 data_b_in_enable_vector_float_adder;
  wire                 data_out_enable_vector_float_adder;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_float_adder;
  wire [DATA_SIZE-1:0] data_a_in_vector_float_adder;
  wire [DATA_SIZE-1:0] data_b_in_vector_float_adder;
  wire [DATA_SIZE-1:0] data_out_vector_float_adder;

  // VECTOR DIFFERENTIATION
  // CONTROL
  wire                 start_vector_differentiation;
  wire                 ready_vector_differentiation;

  wire                 data_in_vector_enable_vector_differentiation;
  wire                 data_in_scalar_enable_vector_differentiation;

  wire                 data_out_vector_enable_vector_differentiation;
  wire                 data_out_scalar_enable_vector_differentiation;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_differentiation;
  wire [DATA_SIZE-1:0] period_in_vector_differentiation;
  wire [DATA_SIZE-1:0] length_in_vector_differentiation;
  wire [DATA_SIZE-1:0] data_in_vector_differentiation;
  wire [DATA_SIZE-1:0] data_out_vector_differentiation;

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

  // df(t;l) = ds(t;l) o s(t-1;l) o f(t;l) o (1 - f(t;l))

  // dW(t;l) = summation(df(t;l) · x(t;x))[t in 0 to T]
  // dK(t;l) = summation(df(t;l) · r(t;i;k))[t in 0 to T-1]
  // dU(t;l) = summation(df(t+1;l) · h(t;l))[t in 0 to T-1]
  // db(l) = summation(df(t;l))[t in 0 to T]

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if (RST == 1'b0) begin
      // Data Outputs
      W_OUT <= ZERO_DATA;
      K_OUT <= ZERO_DATA;
      U_OUT <= ZERO_DATA;
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
            controller_ctrl_fsm_int <= VECTOR_DIFFERENTIATION_F_STATE;
          end
        end

        VECTOR_DIFFERENTIATION_F_STATE: begin  // STEP 1

          case (differentiation_f_ctrl_fsm_int)
            STARTER_DF_STATE: begin  // STEP 0
            end

            VECTOR_ADDER_DF_STATE: begin  // STEP 1
            end

            VECTOR_FIRST_MULTIPLIER_DF_STATE: begin  // STEP 2
            end

            VECTOR_SECOND_MULTIPLIER_DF_STATE: begin  // STEP 3
            end

            VECTOR_THIRD_MULTIPLIER_DF_STATE: begin  // STEP 4
            end

            default: begin
              // FSM Control
              differentiation_f_ctrl_fsm_int <= STARTER_DF_STATE;
            end
          endcase
        end

        VECTOR_DIFFERENTIATION_W_STATE: begin  // STEP 1

          case (differentiation_w_ctrl_fsm_int)
            STARTER_DW_STATE: begin  // STEP 0
            end

            VECTOR_DIFFERENTIATION_DW_STATE: begin  // STEP 1
            end

            MATRIX_PRODUCT_DW_STATE: begin  // STEP 2
            end

            VECTOR_SUMMATION_DW_STATE: begin  // STEP 3
            end

            default: begin
              // FSM Control
              differentiation_w_ctrl_fsm_int <= STARTER_DW_STATE;
            end
          endcase
        end

        VECTOR_DIFFERENTIATION_K_STATE: begin  // STEP 2

          case (differentiation_k_ctrl_fsm_int)
            STARTER_DK_STATE: begin  // STEP 0
            end

            VECTOR_DIFFERENTIATION_DK_STATE: begin  // STEP 1
            end

            MATRIX_PRODUCT_DK_STATE: begin  // STEP 2
            end

            VECTOR_SUMMATION_DK_STATE: begin  // STEP 3
            end

            default: begin
              // FSM Control
              differentiation_k_ctrl_fsm_int <= STARTER_DK_STATE;
            end
          endcase
        end

        VECTOR_DIFFERENTIATION_U_STATE: begin  // STEP 3

          case (differentiation_u_ctrl_fsm_int)
            STARTER_DU_STATE: begin  // STEP 0
            end

            VECTOR_DIFFERENTIATION_DU_STATE: begin  // STEP 1
            end

            MATRIX_PRODUCT_DU_STATE: begin  // STEP 2
            end

            VECTOR_SUMMATION_DU_STATE: begin  // STEP 3
            end

            default: begin
              // FSM Control
              differentiation_u_ctrl_fsm_int <= STARTER_DU_STATE;
            end
          endcase
        end

        VECTOR_DIFFERENTIATION_B_STATE: begin  // STEP 4

          case (differentiation_b_ctrl_fsm_int)
            STARTER_DB_STATE: begin  // STEP 0
            end

            VECTOR_DIFFERENTIATION_DB_STATE: begin  // STEP 1
            end

            VECTOR_SUMMATION_DB_STATE: begin  // STEP 2
            end

            default: begin
              // FSM Control
              differentiation_b_ctrl_fsm_int <= STARTER_DB_STATE;
            end
          endcase
        end

        default: begin
          // FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // VECTOR SUMMATION
  accelerator_vector_summation #(
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

  // VECTOR MULTIPLIER
  accelerator_vector_float_multiplier #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_float_multiplier (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_float_multiplier),
    .READY(ready_vector_float_multiplier),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_float_multiplier),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_float_multiplier),
    .DATA_OUT_ENABLE (data_out_enable_vector_float_multiplier),

    // DATA
    .SIZE_IN  (size_in_vector_float_multiplier),
    .DATA_A_IN(data_a_in_vector_float_multiplier),
    .DATA_B_IN(data_b_in_vector_float_multiplier),
    .DATA_OUT (data_out_vector_float_multiplier)
  );

  // VECTOR ADDER
  accelerator_vector_float_adder #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_float_adder (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_float_adder),
    .READY(ready_vector_float_adder),

    .OPERATION(operation_vector_float_adder),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_float_adder),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_float_adder),
    .DATA_OUT_ENABLE (data_out_enable_vector_float_adder),

    // DATA
    .SIZE_IN  (size_in_vector_float_adder),
    .DATA_A_IN(data_a_in_vector_float_adder),
    .DATA_B_IN(data_b_in_vector_float_adder),
    .DATA_OUT (data_out_vector_float_adder)
  );

  // VECTOR DIFFERENTIATION
  accelerator_vector_differentiation #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_differentiation (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_differentiation),
    .READY(ready_vector_differentiation),

    .DATA_IN_VECTOR_ENABLE(data_in_vector_enable_vector_differentiation),
    .DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_vector_differentiation),

    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_differentiation),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_differentiation),

    // DATA
    .SIZE_IN  (size_in_vector_differentiation),
    .PERIOD_IN(period_in_vector_differentiation),
    .LENGTH_IN(length_in_vector_differentiation),
    .DATA_IN  (data_in_vector_differentiation),
    .DATA_OUT (data_out_vector_differentiation)
  );

  // MATRIX PRODUCT
  accelerator_matrix_product #(
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
