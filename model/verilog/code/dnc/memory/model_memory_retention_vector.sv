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

module model_memory_retention_vector #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 64
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input      START,
  output reg READY,

  input F_IN_ENABLE,  // for i in 0 to R-1

  output reg F_OUT_ENABLE,  // for i in 0 to R-1

  input W_IN_I_ENABLE,  // for i in 0 to R-1
  input W_IN_J_ENABLE,  // for j in 0 to N-1

  output reg W_OUT_I_ENABLE,  // for i in 0 to R-1
  output reg W_OUT_J_ENABLE,  // for j in 0 to N-1

  output reg PSI_OUT_ENABLE,  // for j in 0 to N-1

  // DATA
  input [DATA_SIZE-1:0] SIZE_R_IN,
  input [DATA_SIZE-1:0] SIZE_N_IN,

  input [DATA_SIZE-1:0] F_IN,
  input [DATA_SIZE-1:0] W_IN,

  output reg [DATA_SIZE-1:0] PSI_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  parameter [1:0] STARTER_STATE = 0;
  parameter [1:0] VECTOR_MULTIPLIER_STATE = 1;
  parameter [1:0] VECTOR_ADDER_STATE = 2;
  parameter [1:0] VECTOR_MULTIPLICATION_STATE = 2;

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

  // VECTOR MULTIPLICATION
  // CONTROL
  wire                 start_vector_multiplication;
  wire                 ready_vector_multiplication;
  wire                 data_in_vector_enable_vector_multiplication;
  wire                 data_in_scalar_enable_vector_multiplication;
  wire                 data_out_vector_enable_vector_multiplication;
  wire                 data_out_scalar_enable_vector_multiplication;

  // DATA
  wire [DATA_SIZE-1:0] length_in_vector_multiplication;
  wire [DATA_SIZE-1:0] size_in_vector_multiplication;
  wire [DATA_SIZE-1:0] data_in_vector_multiplication;
  wire [DATA_SIZE-1:0] data_out_vector_multiplication;

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

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // psi(t;j) = multiplication(1 - f(t;i)·w(t-1;i;j))[i in 1 to R]

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if (RST == 1'b0) begin
      // Data Outputs
      PSI_OUT <= ZERO_DATA;

      // Control Outputs
      READY   <= 1'b0;
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

        VECTOR_MULTIPLICATION_STATE: begin  // STEP 3
        end
        default: begin
          // FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // VECTOR MULTIPLICATION
  model_vector_multiplication #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_multiplication (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_multiplication),
    .READY(ready_vector_multiplication),

    .DATA_IN_VECTOR_ENABLE (data_in_vector_enable_vector_multiplication),
    .DATA_IN_SCALAR_ENABLE (data_in_scalar_enable_vector_multiplication),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_multiplication),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_multiplication),

    // DATA
    .SIZE_IN  (size_in_vector_multiplication),
    .LENGTH_IN(length_in_vector_multiplication),
    .DATA_IN  (data_in_vector_multiplication),
    .DATA_OUT (data_out_vector_multiplication)
  );

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
