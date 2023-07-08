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

module accelerator_addressing #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 4
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input      START,
  output reg READY,

  input K_IN_ENABLE,  // for k in 0 to W-1
  input S_IN_ENABLE,  // for k in 0 to W-1

  input K_OUT_ENABLE,  // for k in 0 to W-1
  input S_OUT_ENABLE,  // for k in 0 to W-1

  input M_IN_J_ENABLE,  // for j in 0 to N-1
  input M_IN_K_ENABLE,  // for k in 0 to W-1

  input M_OUT_J_ENABLE,  // for j in 0 to N-1
  input M_OUT_K_ENABLE,  // for k in 0 to W-1

  input      W_IN_ENABLE,  // for j in 0 to N-1
  output reg W_OUT_ENABLE, // for j in 0 to N-1

  // DATA
  input [DATA_SIZE-1:0] SIZE_N_IN,
  input [DATA_SIZE-1:0] SIZE_W_IN,

  input [DATA_SIZE-1:0] K_IN,
  input [DATA_SIZE-1:0] BETA_IN,
  input [DATA_SIZE-1:0] G_IN,
  input [DATA_SIZE-1:0] S_IN,
  input [DATA_SIZE-1:0] GAMMA_IN,

  input [DATA_SIZE-1:0] M_IN,
  input [DATA_SIZE-1:0] W_IN,

  output reg [DATA_SIZE-1:0] W_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  parameter [2:0] STARTER_STATE = 0;
  parameter [2:0] VECTOR_CONTENT_BASED_ADDRESSING_STATE = 1;
  parameter [2:0] VECTOR_INTERPOLATION_STATE = 2;
  parameter [2:0] VECTOR_CONVOLUTION_STATE = 3;
  parameter [2:0] VECTOR_SHARPENING_STATE = 4;

  parameter [2:0] STARTER_INTERPOLATION_STATE = 0;
  parameter [2:0] VECTOR_FIRST_MULTIPLIER_INTERPOLATION_STATE = 1;
  parameter [2:0] VECTOR_FIRST_ADDER_INTERPOLATION_STATE = 2;
  parameter [2:0] VECTOR_SECOND_MULTIPLIER_INTERPOLATION_STATE = 3;
  parameter [2:0] VECTOR_SECOND_ADDER_INTERPOLATION_STATE = 4;

  parameter [2:0] STARTER_SHARPENING_STATE = 0;
  parameter [2:0] VECTOR_EXPONENTIATOR_SHARPENING_STATE = 1;
  parameter [2:0] VECTOR_SUMMATION_SHARPENING_STATE = 2;
  parameter [2:0] VECTOR_DIVIDER_SHARPENING_STATE = 3;

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
  reg  [          2:0] controller_ctrl_interpolation_fsm_int;
  reg  [          2:0] controller_ctrl_sharpening_fsm_int;

  // VECTOR CONTENT BASED ADDRESSING
  // CONTROL
  wire                 start_vector_content_based_addressing;
  wire                 ready_vector_content_based_addressing;

  wire                 k_in_enable_vector_content_based_addressing;

  wire                 k_out_enable_vector_content_based_addressing;

  wire                 m_in_i_enable_vector_content_based_addressing;
  wire                 m_in_j_enable_vector_content_based_addressing;

  wire                 m_out_i_enable_vector_content_based_addressing;
  wire                 m_out_j_enable_vector_content_based_addressing;

  wire                 c_out_enable_vector_content_based_addressing;

  // DATA
  reg  [DATA_SIZE-1:0] size_i_in_vector_content_based_addressing;
  reg  [DATA_SIZE-1:0] size_j_in_vector_content_based_addressing;

  reg  [DATA_SIZE-1:0] k_in_vector_content_based_addressing;
  reg  [DATA_SIZE-1:0] beta_in_vector_content_based_addressing;
  reg  [DATA_SIZE-1:0] m_in_vector_content_based_addressing;

  wire [DATA_SIZE-1:0] c_out_vector_content_based_addressing;

  // VECTOR ADDER
  // CONTROL
  wire                 start_vector_adder;
  wire                 ready_vector_adder;

  wire                 operation_vector_adder;

  wire                 data_a_in_enable_vector_adder;
  wire                 data_b_in_enable_vector_adder;
  wire                 data_out_enable_vector_adder;

  // DATA
  reg  [DATA_SIZE-1:0] size_in_vector_adder;
  reg  [DATA_SIZE-1:0] data_a_in_vector_adder;
  reg  [DATA_SIZE-1:0] data_b_in_vector_adder;
  wire [DATA_SIZE-1:0] data_out_vector_adder;

  // VECTOR MULTIPLIER
  // CONTROL
  wire                 start_vector_multiplier;
  wire                 ready_vector_multiplier;

  wire                 data_a_in_enable_vector_multiplier;
  wire                 data_b_in_enable_vector_multiplier;
  wire                 data_out_enable_vector_multiplier;

  // DATA
  reg  [DATA_SIZE-1:0] size_in_vector_multiplier;
  reg  [DATA_SIZE-1:0] data_a_in_vector_multiplier;
  reg  [DATA_SIZE-1:0] data_b_in_vector_multiplier;
  wire [DATA_SIZE-1:0] data_out_vector_multiplier;

  // VECTOR DIVIDER
  // CONTROL
  wire                 start_vector_divider;
  wire                 ready_vector_divider;

  wire                 data_a_in_enable_vector_divider;
  wire                 data_b_in_enable_vector_divider;
  wire                 data_out_enable_vector_divider;

  // DATA
  reg  [DATA_SIZE-1:0] size_in_vector_divider;
  reg  [DATA_SIZE-1:0] data_a_in_vector_divider;
  reg  [DATA_SIZE-1:0] data_b_in_vector_divider;
  wire [DATA_SIZE-1:0] data_out_vector_divider;

  // VECTOR EXPONENTIATOR
  // CONTROL
  wire                 start_vector_exponentiator_function;
  wire                 ready_vector_exponentiator_function;

  wire                 data_in_enable_vector_exponentiator_function;
  wire                 data_out_enable_vector_exponentiator_function;

  // DATA
  reg  [DATA_SIZE-1:0] size_in_vector_exponentiator_function;
  reg  [DATA_SIZE-1:0] data_in_vector_exponentiator_function;
  wire [DATA_SIZE-1:0] data_out_vector_exponentiator_function;

  // VECTOR SUMMATION
  // CONTROL
  wire                 start_vector_summation;
  wire                 ready_vector_summation;

  wire                 data_in_vector_enable_vector_summation;
  wire                 data_in_scalar_enable_vector_summation;
  wire                 data_out_vector_enable_vector_summation;
  wire                 data_out_scalar_enable_vector_summation;

  // DATA
  reg  [DATA_SIZE-1:0] size_in_vector_summation;
  reg  [DATA_SIZE-1:0] length_in_vector_summation;
  reg  [DATA_SIZE-1:0] data_in_vector_summation;
  wire [DATA_SIZE-1:0] data_out_vector_summation;

  // VECTOR CONVOLUTION
  // CONTROL
  wire                 start_vector_convolution;
  wire                 ready_vector_convolution;

  wire                 data_a_in_vector_enable_vector_convolution;
  wire                 data_a_in_scalar_enable_vector_convolution;
  wire                 data_b_in_vector_enable_vector_convolution;
  wire                 data_b_in_scalar_enable_vector_convolution;
  wire                 data_out_vector_enable_vector_convolution;
  wire                 data_out_scalar_enable_vector_convolution;

  // DATA
  reg  [DATA_SIZE-1:0] size_in_vector_convolution;
  reg  [DATA_SIZE-1:0] length_in_vector_convolution;
  reg  [DATA_SIZE-1:0] data_a_in_vector_convolution;
  reg  [DATA_SIZE-1:0] data_b_in_vector_convolution;
  wire [DATA_SIZE-1:0] data_out_vector_convolution;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // wc(t;i;j) = C(M(t;j;k),k(t;i;k),beta(t;i))
  // wg(t;i;j) = g(t;i)·wc(t;i;j) + (1 - g(t;i))·w(t-1;i;j)
  // w(t;i;j) = wg(t;i;j)*s(t;i;k)
  // w(t;i;j) = exponentiation(w(t;i;j),gamma(t;i)) / summation(exponentiation(w(t;i;j),gamma(t;i)))[j in 0 to N-1]

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if (RST == 1'b0) begin
      // Data Outputs
      W_OUT <= ZERO_DATA;

      // Control Outputs
      READY <= 1'b0;
    end else begin
      case (controller_ctrl_fsm_int)
        STARTER_STATE: begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if (START == 1'b1) begin
            // FSM Control
            controller_ctrl_fsm_int <= VECTOR_CONTENT_BASED_ADDRESSING_STATE;
          end
        end

        VECTOR_CONTENT_BASED_ADDRESSING_STATE: begin  // STEP 1

          // Data Inputs
          size_i_in_vector_content_based_addressing <= SIZE_N_IN;
          size_j_in_vector_content_based_addressing <= SIZE_W_IN;
          k_in_vector_content_based_addressing      <= K_IN;
          beta_in_vector_content_based_addressing   <= BETA_IN;
          m_in_vector_content_based_addressing      <= M_IN;
        end

        VECTOR_INTERPOLATION_STATE: begin  // STEP 2

          case (controller_ctrl_interpolation_fsm_int)
            STARTER_INTERPOLATION_STATE: begin  // STEP 0
            end

            VECTOR_FIRST_MULTIPLIER_INTERPOLATION_STATE: begin  // STEP 1

              // Data Inputs
              size_in_vector_multiplier   <= FULL;
              data_a_in_vector_multiplier <= FULL;
              data_b_in_vector_multiplier <= FULL;
            end

            VECTOR_FIRST_ADDER_INTERPOLATION_STATE: begin  // STEP 2

              // Data Inputs
              size_in_vector_adder   <= FULL;
              data_a_in_vector_adder <= FULL;
              data_b_in_vector_adder <= FULL;
            end

            VECTOR_SECOND_MULTIPLIER_INTERPOLATION_STATE: begin  // STEP 3

              // Data Inputs
              size_in_vector_multiplier   <= FULL;
              data_a_in_vector_multiplier <= FULL;
              data_b_in_vector_multiplier <= FULL;
            end

            VECTOR_SECOND_ADDER_INTERPOLATION_STATE: begin  // STEP 4

              // Data Inputs
              size_in_vector_adder   <= FULL;
              data_a_in_vector_adder <= FULL;
              data_b_in_vector_adder <= FULL;
            end
            default: begin
              // FSM Control
              controller_ctrl_interpolation_fsm_int <= STARTER_INTERPOLATION_STATE;
            end
          endcase
        end

        VECTOR_CONVOLUTION_STATE: begin  // STEP 3

          // Data Inputs
          size_in_vector_convolution   <= FULL;
          length_in_vector_convolution <= FULL;
          data_a_in_vector_convolution <= FULL;
          data_b_in_vector_convolution <= FULL;
        end

        VECTOR_SHARPENING_STATE: begin  // STEP 4

          case (controller_ctrl_sharpening_fsm_int)
            STARTER_SHARPENING_STATE: begin  // STEP 0
            end

            VECTOR_EXPONENTIATOR_SHARPENING_STATE: begin  // STEP 1

              // Data Inputs
              size_in_vector_exponentiator_function <= FULL;
              data_in_vector_exponentiator_function <= FULL;
            end

            VECTOR_SUMMATION_SHARPENING_STATE: begin  // STEP 2

              // Data Inputs
              size_in_vector_summation   <= FULL;
              length_in_vector_summation <= FULL;
              data_in_vector_summation   <= FULL;
            end

            VECTOR_DIVIDER_SHARPENING_STATE: begin  // STEP 3

              // Data Inputs
              size_in_vector_divider   <= FULL;
              data_a_in_vector_divider <= FULL;
              data_b_in_vector_divider <= FULL;
            end
            default: begin
              // FSM Control
              controller_ctrl_sharpening_fsm_int <= STARTER_SHARPENING_STATE;
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

  // VECTOR CONTENT BASED ADDRESSING
  accelerator_content_based_addressing #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) accelerator_content_based_addressing_i (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_content_based_addressing),
    .READY(ready_vector_content_based_addressing),

    .K_IN_ENABLE(k_in_enable_vector_content_based_addressing),

    .K_OUT_ENABLE(k_out_enable_vector_content_based_addressing),

    .M_IN_I_ENABLE(m_in_i_enable_vector_content_based_addressing),
    .M_IN_J_ENABLE(m_in_j_enable_vector_content_based_addressing),

    .M_OUT_I_ENABLE(m_out_i_enable_vector_content_based_addressing),
    .M_OUT_J_ENABLE(m_out_j_enable_vector_content_based_addressing),

    .C_OUT_ENABLE(c_out_enable_vector_content_based_addressing),

    // DATA
    .SIZE_I_IN(size_i_in_vector_content_based_addressing),
    .SIZE_J_IN(size_j_in_vector_content_based_addressing),

    .K_IN   (k_in_vector_content_based_addressing),
    .BETA_IN(beta_in_vector_content_based_addressing),
    .M_IN   (m_in_vector_content_based_addressing),

    .C_OUT(c_out_vector_content_based_addressing)
  );

  // VECTOR ADDER
  accelerator_vector_adder #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_adder (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_adder),
    .READY(ready_vector_adder),

    .OPERATION(operation_vector_adder),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_adder),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_adder),
    .DATA_OUT_ENABLE (data_out_enable_vector_adder),

    // DATA
    .SIZE_IN  (size_in_vector_adder),
    .DATA_A_IN(data_a_in_vector_adder),
    .DATA_B_IN(data_b_in_vector_adder),
    .DATA_OUT (data_out_vector_adder)
  );

  // VECTOR MULTIPLIER
  accelerator_vector_multiplier #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_multiplier (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_multiplier),
    .READY(ready_vector_multiplier),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_multiplier),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_multiplier),
    .DATA_OUT_ENABLE (data_out_enable_vector_multiplier),

    // DATA
    .SIZE_IN  (size_in_vector_multiplier),
    .DATA_A_IN(data_a_in_vector_multiplier),
    .DATA_B_IN(data_b_in_vector_multiplier),
    .DATA_OUT (data_out_vector_multiplier)
  );

  // VECTOR DIVIDER
  accelerator_vector_divider #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_divider (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_divider),
    .READY(ready_vector_divider),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_divider),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_divider),
    .DATA_OUT_ENABLE (data_out_enable_vector_divider),

    // DATA
    .SIZE_IN  (size_in_vector_divider),
    .DATA_A_IN(data_a_in_vector_divider),
    .DATA_B_IN(data_b_in_vector_divider),
    .DATA_OUT (data_out_vector_divider)
  );

  // VECTOR EXPONENTIATOR
  accelerator_vector_exponentiator_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_exponentiator_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_exponentiator_function),
    .READY(ready_vector_exponentiator_function),

    .DATA_IN_ENABLE (data_in_enable_vector_exponentiator_function),
    .DATA_OUT_ENABLE(data_out_enable_vector_exponentiator_function),

    // DATA
    .SIZE_IN (size_in_vector_exponentiator_function),
    .DATA_IN (data_in_vector_exponentiator_function),
    .DATA_OUT(data_out_vector_exponentiator_function)
  );

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

  // VECTOR CONVOLUTION
  accelerator_vector_convolution_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_convolution_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_convolution),
    .READY(ready_vector_convolution),

    .DATA_A_IN_VECTOR_ENABLE(data_a_in_vector_enable_vector_convolution),
    .DATA_A_IN_SCALAR_ENABLE(data_a_in_scalar_enable_vector_convolution),
    .DATA_B_IN_VECTOR_ENABLE(data_b_in_vector_enable_vector_convolution),
    .DATA_B_IN_SCALAR_ENABLE(data_b_in_scalar_enable_vector_convolution),
    .DATA_OUT_VECTOR_ENABLE (data_out_vector_enable_vector_convolution),
    .DATA_OUT_SCALAR_ENABLE (data_out_scalar_enable_vector_convolution),

    // DATA
    .SIZE_IN  (size_in_vector_convolution),
    .LENGTH_IN(length_in_vector_convolution),
    .DATA_A_IN(data_a_in_vector_convolution),
    .DATA_B_IN(data_b_in_vector_convolution),
    .DATA_OUT (data_out_vector_convolution)
  );

endmodule
