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

module model_vector_fixed_divider #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 64
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input      START,
  output reg READY,

  input      DATA_A_IN_ENABLE,
  input      DATA_B_IN_ENABLE,
  output reg DATA_OUT_ENABLE,

  // DATA
  input      [DATA_SIZE-1:0] SIZE_IN,
  input      [DATA_SIZE-1:0] DATA_A_IN,
  input      [DATA_SIZE-1:0] DATA_B_IN,
  output reg [DATA_SIZE-1:0] DATA_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  parameter [1:0] STARTER_STATE = 0;
  parameter [1:0] INPUT_STATE = 1;
  parameter [1:0] ENDER_STATE = 2;

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
  reg  [             1:0] divider_ctrl_fsm_int;

  // Data Internal
  reg  [CONTROL_SIZE-1:0] index_loop;

  reg                     data_a_in_divider_int;
  reg                     data_b_in_divider_int;

  // DIVIDER
  // CONTROL
  reg                     start_scalar_fixed_divider;
  wire                    ready_scalar_fixed_divider;

  // DATA
  reg  [   DATA_SIZE-1:0] data_a_in_scalar_fixed_divider;
  reg  [   DATA_SIZE-1:0] data_b_in_scalar_fixed_divider;
  wire [   DATA_SIZE-1:0] data_out_scalar_fixed_divider;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // DATA_OUT = DATA_A_IN / DATA_B_IN = M_A_IN / M_B_IN · 2^(E_A_IN - E_B_IN)

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if (RST == 1'b0) begin
      // Data Outputs
      DATA_OUT              <= ZERO_DATA;

      // Control Outputs
      READY                 <= 1'b0;

      // Assignations
      index_loop            <= ZERO_DATA;

      data_a_in_divider_int <= 1'b0;
      data_b_in_divider_int <= 1'b0;
    end else begin
      case (divider_ctrl_fsm_int)
        STARTER_STATE: begin
          // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if (START == 1'b1) begin
            // Assignations
            index_loop           <= ZERO_DATA;

            // FSM Control
            divider_ctrl_fsm_int <= INPUT_STATE;
          end
        end
        INPUT_STATE: begin
          // STEP 1
          if (DATA_A_IN_ENABLE == 1'b1) begin
            // Data Inputs
            data_a_in_scalar_fixed_divider <= DATA_A_IN;

            // Control Internal
            data_a_in_divider_int          <= 1'b1;
          end
          if (DATA_B_IN_ENABLE == 1'b1) begin
            // Data Inputs
            data_b_in_scalar_fixed_divider <= DATA_B_IN;

            // Control Internal
            data_b_in_divider_int          <= 1'b1;
          end
          if (data_a_in_divider_int == 1'b1 && data_b_in_divider_int == 1'b1) begin
            if (index_loop == ZERO_DATA) begin
              // Control Internal
              start_scalar_fixed_divider <= 1'b1;
            end
            // Data Inputs

            // FSM Control
            divider_ctrl_fsm_int <= ENDER_STATE;
          end

          // Control Outputs
          DATA_OUT_ENABLE <= 1'b0;
        end
        ENDER_STATE: begin
          // STEP 2
          if (ready_scalar_fixed_divider == 1'b1) begin
            if (index_loop == (SIZE_IN - ONE_CONTROL)) begin
              // Control Outputs
              READY                <= 1'b1;

              // FSM Control
              divider_ctrl_fsm_int <= STARTER_STATE;
            end else begin
              // Control Internal
              index_loop           <= (index_loop + ONE_CONTROL);

              // FSM Control
              divider_ctrl_fsm_int <= INPUT_STATE;
            end
            // Data Outputs
            DATA_OUT        <= data_out_scalar_fixed_divider;

            // Control Outputs
            DATA_OUT_ENABLE <= 1'b1;
          end else begin
            // Control Internal
            start_scalar_fixed_divider <= 1'b0;
            data_a_in_divider_int      <= 1'b0;
            data_b_in_divider_int      <= 1'b0;
          end
        end
        default: begin
          // FSM Control
          divider_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // DIVIDER
  model_scalar_fixed_divider #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_fixed_divider (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_fixed_divider),
    .READY(ready_scalar_fixed_divider),

    // DATA
    .DATA_A_IN(data_a_in_scalar_fixed_divider),
    .DATA_B_IN(data_b_in_scalar_fixed_divider),
    .DATA_OUT (data_out_scalar_fixed_divider)
  );

endmodule
