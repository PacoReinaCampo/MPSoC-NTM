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

module model_temporal_link_matrix #(
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

  input W_IN_ENABLE,  // for j in 0 to N-1
  input P_IN_ENABLE,  // for j in 0 to N-1

  output reg W_OUT_ENABLE,  // for j in 0 to N-1
  output reg P_OUT_ENABLE,  // for j in 0 to N-1

  output reg L_OUT_G_ENABLE,  // for g in 0 to N-1 (square matrix)
  output reg L_OUT_J_ENABLE,  // for j in 0 to N-1 (square matrix)

  // DATA
  input [DATA_SIZE-1:0] SIZE_N_IN,

  input [DATA_SIZE-1:0] L_IN,
  input [DATA_SIZE-1:0] W_IN,
  input [DATA_SIZE-1:0] P_IN,

  output reg [DATA_SIZE-1:0] L_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  parameter [1:0] STARTER_STATE = 0;
  parameter [1:0] VECTOR_MULTIPLIER_STATE = 1;
  parameter [1:0] VECTOR_ADDER_STATE = 2;

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

  // SCALAR ADDER
  // CONTROL
  wire                 start_scalar_float_adder;
  wire                 ready_scalar_float_adder;

  wire                 operation_scalar_float_adder;

  // DATA
  wire [DATA_SIZE-1:0] data_a_in_scalar_float_adder;
  wire [DATA_SIZE-1:0] data_b_in_scalar_float_adder;
  wire [DATA_SIZE-1:0] data_out_scalar_float_adder;

  // SCALAR MULTIPLIER
  // CONTROL
  wire                 start_scalar_float_multiplier;
  wire                 ready_scalar_float_multiplier;
  // DATA
  wire [DATA_SIZE-1:0] data_a_in_scalar_float_multiplier;
  wire [DATA_SIZE-1:0] data_b_in_scalar_float_multiplier;
  wire [DATA_SIZE-1:0] data_out_scalar_float_multiplier;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // L(t)[g;j] = (1 - w(t;j)[i] - w(t;j)[j])·L(t-1)[g;j] + w(t;j)[i]·p(t-1;j)[j]
  // L(t=0)[g,j] = 0

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if (RST == 1'b0) begin
      // Data Outputs
      L_OUT <= ZERO_DATA;

      // Control Outputs
      READY <= 1'b0;
    end else begin
      case (controller_ctrl_fsm_int)
        STARTER_STATE: begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if (START == 1'b1) begin
            // FSM Control
            controller_ctrl_fsm_int <= VECTOR_MULTIPLIER_STATE;
          end
        end

        VECTOR_MULTIPLIER_STATE: begin  // STEP 1
        end

        VECTOR_ADDER_STATE: begin  // STEP 2
        end
        default: begin
          // FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // SCALAR ADDER
  model_scalar_float_adder #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_float_adder (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_float_adder),
    .READY(ready_scalar_float_adder),

    .OPERATION(operation_scalar_float_adder),

    // DATA
    .DATA_A_IN(data_a_in_scalar_float_adder),
    .DATA_B_IN(data_b_in_scalar_float_adder),
    .DATA_OUT (data_out_scalar_float_adder)
  );

  // SCALAR MULTIPLIER
  model_scalar_float_multiplier #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_float_multiplier (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_float_multiplier),
    .READY(ready_scalar_float_adder),

    // DATA
    .DATA_A_IN(data_a_in_scalar_float_multiplier),
    .DATA_B_IN(data_b_in_scalar_float_multiplier),
    .DATA_OUT (data_out_scalar_float_multiplier)
  );

endmodule
