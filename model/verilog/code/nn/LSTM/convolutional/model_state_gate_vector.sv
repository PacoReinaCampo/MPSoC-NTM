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

module model_state_gate_vector #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 4
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input      START,
  output reg READY,

  input I_IN_ENABLE,  // for l in 0 to L-1
  input F_IN_ENABLE,  // for l in 0 to L-1
  input A_IN_ENABLE,  // for l in 0 to L-1

  output reg I_OUT_ENABLE,  // for l in 0 to L-1
  output reg F_OUT_ENABLE,  // for l in 0 to L-1
  output reg A_OUT_ENABLE,  // for l in 0 to L-1

  input S_IN_ENABLE,  // for l in 0 to L-1

  output reg S_OUT_ENABLE,  // for l in 0 to L-1

  // DATA
  input [DATA_SIZE-1:0] SIZE_L_IN,

  input [DATA_SIZE-1:0] I_IN,
  input [DATA_SIZE-1:0] F_IN,
  input [DATA_SIZE-1:0] A_IN,

  input [DATA_SIZE-1:0] S_IN,

  output reg [DATA_SIZE-1:0] S_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  parameter [2:0] STARTER_STATE = 0;
  parameter [2:0] VECTOR_FIRST_MULTIPLIER_STATE = 1;
  parameter [2:0] VECTOR_FIRST_ADDER_STATE = 2;
  parameter [2:0] VECTOR_SECOND_MULTIPLIER_STATE = 3;
  parameter [2:0] VECTOR_SECOND_ADDER_STATE = 4;

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
  reg  [             2:0] controller_ctrl_fsm_int;

  // Data Internal
  wire [CONTROL_SIZE-1:0] index_loop;

  wire [   DATA_SIZE-1:0] data_int_vector_float_multiplier;

  // VECTOR ADDER
  // CONTROL
  wire                    start_vector_float_adder;
  wire                    ready_vector_float_adder;

  wire                    operation_vector_float_adder;

  wire                    data_a_in_enable_vector_float_adder;
  wire                    data_b_in_enable_vector_float_adder;
  wire                    data_out_enable_vector_float_adder;

  // DATA
  reg  [   DATA_SIZE-1:0] size_in_vector_float_adder;
  reg  [   DATA_SIZE-1:0] data_a_in_vector_float_adder;
  reg  [   DATA_SIZE-1:0] data_b_in_vector_float_adder;
  wire [   DATA_SIZE-1:0] data_out_vector_float_adder;

  // VECTOR MULTIPLIER
  // CONTROL
  wire                    start_vector_float_multiplier;
  wire                    ready_vector_float_multiplier;

  wire                    data_a_in_enable_vector_float_multiplier;
  wire                    data_b_in_enable_vector_float_multiplier;
  wire                    data_out_enable_vector_float_multiplier;

  // DATA
  reg  [   DATA_SIZE-1:0] size_in_vector_float_multiplier;
  reg  [   DATA_SIZE-1:0] data_a_in_vector_float_multiplier;
  reg  [   DATA_SIZE-1:0] data_b_in_vector_float_multiplier;
  wire [   DATA_SIZE-1:0] data_out_vector_float_multiplier;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // s(t;l) = f(t;l) o s(t-1;l) + i(t;l) o a(t;l)
  // s(t=0;l) = 0

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if (RST == 1'b0) begin
      // Data Outputs
      S_OUT <= ZERO_DATA;

      // Control Outputs
      READY <= 1'b0;
    end else begin
      case (controller_ctrl_fsm_int)
        STARTER_STATE: begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if (START == 1'b1) begin
            // FSM Control
            controller_ctrl_fsm_int <= VECTOR_FIRST_MULTIPLIER_STATE;
          end
        end

        VECTOR_FIRST_MULTIPLIER_STATE: begin  // STEP 1

          // Data Outputs
          size_in_vector_float_multiplier   <= SIZE_L_IN;
          data_a_in_vector_float_multiplier <= F_IN;
          data_b_in_vector_float_multiplier <= S_IN;
        end

        VECTOR_FIRST_ADDER_STATE: begin  // STEP 2

          // Data Outputs
          size_in_vector_float_adder   <= SIZE_L_IN;
          data_a_in_vector_float_adder <= ZERO_DATA;
          data_b_in_vector_float_adder <= data_out_vector_float_multiplier;
        end

        VECTOR_SECOND_MULTIPLIER_STATE: begin  // STEP 3

          // Data Outputs
          size_in_vector_float_multiplier   <= SIZE_L_IN;
          data_a_in_vector_float_multiplier <= I_IN;
          data_b_in_vector_float_multiplier <= A_IN;
        end

        VECTOR_SECOND_ADDER_STATE: begin  // STEP 4

          // Data Outputs
          size_in_vector_float_adder   <= SIZE_L_IN;
          data_a_in_vector_float_adder <= data_out_vector_float_adder;
          data_b_in_vector_float_adder <= data_out_vector_float_multiplier;

          // Data Outputs
          S_OUT                        <= data_out_vector_float_adder;
        end

        default: begin
          // FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // VECTOR ADDER
  model_vector_float_adder #(
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

  // VECTOR MULTIPLIER
  model_vector_float_multiplier #(
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

endmodule
