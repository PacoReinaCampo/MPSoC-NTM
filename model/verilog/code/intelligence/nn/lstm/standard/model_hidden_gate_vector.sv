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

module model_hidden_gate_vector #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 4
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input      START,
  output reg READY,

  input S_IN_ENABLE,  // for l in 0 to L-1
  input O_IN_ENABLE,  // for l in 0 to L-1

  output reg S_OUT_ENABLE,  // for l in 0 to L-1
  output reg O_OUT_ENABLE,  // for l in 0 to L-1

  output reg H_OUT_ENABLE,  // for l in 0 to L-1

  // DATA
  input [DATA_SIZE-1:0] SIZE_L_IN,

  input [DATA_SIZE-1:0] S_IN,
  input [DATA_SIZE-1:0] O_IN,

  output reg [DATA_SIZE-1:0] H_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  parameter [1:0] STARTER_STATE = 0;
  parameter [1:0] VECTOR_TANH_STATE = 1;
  parameter [1:0] VECTOR_MULTIPLIER_STATE = 2;

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

  // VECTOR TANH
  // CONTROL
  wire                 start_vector_tanh;
  wire                 ready_vector_tanh;

  wire                 data_in_enable_vector_tanh;
  wire                 data_out_enable_vector_tanh;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_tanh;
  wire [DATA_SIZE-1:0] data_in_vector_tanh;
  wire [DATA_SIZE-1:0] data_out_vector_tanh;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // h(t;l) = o(t;l) o tanh(s(t;l))
  // h(t=0;l) = 0; h(t;l=0) = 0

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if (RST == 1'b0) begin
      // Data Outputs
      H_OUT <= ZERO_DATA;

      // Control Outputs
      READY <= 1'b0;
    end else begin
      case (controller_ctrl_fsm_int)
        STARTER_STATE: begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if (START == 1'b1) begin
            // FSM Control
            controller_ctrl_fsm_int <= VECTOR_TANH_STATE;
          end
        end

        VECTOR_TANH_STATE: begin  // STEP 1
        end

        VECTOR_MULTIPLIER_STATE: begin  // STEP 2

          // Data Outputs
          H_OUT <= data_out_vector_float_multiplier;
        end

        default: begin
          // FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // VECTOR TANH
  assign size_in_vector_tanh               = SIZE_L_IN;
  assign data_in_vector_tanh               = S_IN;

  // VECTOR MULTIPLIER
  assign size_in_vector_float_multiplier   = SIZE_L_IN;
  assign data_a_in_vector_float_multiplier = O_IN;
  assign data_b_in_vector_float_multiplier = data_out_vector_tanh;

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

  // VECTOR TANH
  model_vector_tanh_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_tanh_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_tanh),
    .READY(ready_vector_tanh),

    .DATA_IN_ENABLE (data_in_enable_vector_tanh),
    .DATA_OUT_ENABLE(data_out_enable_vector_tanh),

    // DATA
    .SIZE_IN (size_in_vector_tanh),
    .DATA_IN (data_in_vector_tanh),
    .DATA_OUT(data_out_vector_tanh)
  );

endmodule
