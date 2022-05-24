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

module model_tensor_multiplication #(
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

  input DATA_IN_ENABLE,
  output reg DATA_OUT_ENABLE,

  // DATA
  input [CONTROL_SIZE-1:0] SIZE_I_IN,
  input [CONTROL_SIZE-1:0] SIZE_J_IN,
  input [CONTROL_SIZE-1:0] SIZE_K_IN,
  input [CONTROL_SIZE-1:0] LENGTH_IN,
  input [DATA_SIZE-1:0] DATA_IN,
  output reg [DATA_SIZE-1:0] DATA_OUT
  );

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  parameter [1:0] STARTER_STATE = 0;
  parameter [1:0] INPUT_STATE = 1;
  parameter [1:0] ENDER_STATE = 2;

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
  reg [1:0] multiplication_ctrl_fsm_int;

  // Internal Signals
  reg [CONTROL_SIZE-1:0] index_loop;

  // SCALAR MULTIPLIER
  // CONTROL
  reg start_scalar_float_multiplier;
  wire ready_scalar_float_multiplier;

  // DATA
  reg [DATA_SIZE-1:0] data_a_in_scalar_float_multiplier;
  reg [DATA_SIZE-1:0] data_b_in_scalar_float_multiplier;
  wire [DATA_SIZE-1:0] data_out_scalar_float_multiplier;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if(RST == 1'b0) begin
      // Data Outputs
      DATA_OUT <= ZERO_DATA;

      // Control Outputs
      READY <= 1'b0;

      // Assignations
      index_loop <= ZERO_DATA;
    end
    else begin
      case(multiplication_ctrl_fsm_int)
        STARTER_STATE : begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if(START == 1'b1) begin
            // Assignations
            index_loop <= ZERO_DATA;

            // FSM Control
            multiplication_ctrl_fsm_int <= INPUT_STATE;
          end
        end
        INPUT_STATE : begin  // STEP 1
          if(DATA_IN_ENABLE == 1'b1) begin
            // Data Inputs

            data_a_in_scalar_float_multiplier <= DATA_IN;
            data_b_in_scalar_float_multiplier <= data_out_scalar_float_multiplier;

            // Control Internal
            start_scalar_float_multiplier <= 1'b1;

              // FSM Control
            multiplication_ctrl_fsm_int <= ENDER_STATE;
          end
          // Control Outputs
          DATA_OUT_ENABLE <= 1'b0;
        end
        ENDER_STATE : begin  // STEP 2
          if(ready_scalar_float_multiplier == 1'b1) begin
            if(index_loop == (LENGTH_IN - ONE_CONTROL)) begin
              // Control Outputs
              READY <= 1'b1;

              // FSM Control
              multiplication_ctrl_fsm_int <= STARTER_STATE;
            end
            else begin
              // Control Internal
              index_loop <= (index_loop + ONE_CONTROL);

              // FSM Control
              multiplication_ctrl_fsm_int <= INPUT_STATE;
            end

            // Data Outputs
            DATA_OUT <= data_out_scalar_float_multiplier;

            // Control Outputs
            DATA_OUT_ENABLE <= 1'b1;
          end
          else begin
            // Control Internal
            start_scalar_float_multiplier <= 1'b0;
          end
        end
        default : begin
          // FSM Control
          multiplication_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // SCALAR MULTIPLIER
  model_scalar_float_multiplier #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  )
  scalar_float_multiplier(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_float_multiplier),
    .READY(ready_scalar_float_multiplier),

    // DATA
    .DATA_A_IN(data_a_in_scalar_float_multiplier),
    .DATA_B_IN(data_b_in_scalar_float_multiplier),
    .DATA_OUT(data_out_scalar_float_multiplier)
  );

endmodule
