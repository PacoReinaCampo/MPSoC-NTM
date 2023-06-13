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

module accelerator_vector_cosh_function #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 64
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input      START,
  output reg READY,

  input      DATA_IN_ENABLE,
  output reg DATA_OUT_ENABLE,

  // DATA
  input      [DATA_SIZE-1:0] SIZE_IN,
  input      [DATA_SIZE-1:0] DATA_IN,
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
  reg  [             1:0] cosh_ctrl_fsm_int;

  // Data Internal
  reg  [CONTROL_SIZE-1:0] index_loop;

  // ONE_CONTROLPLUS
  // CONTROL
  reg                     start_scalar_cosh;
  wire                    ready_scalar_cosh;

  // DATA
  reg  [   DATA_SIZE-1:0] data_in_scalar_cosh;
  wire [   DATA_SIZE-1:0] data_out_scalar_cosh;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if (RST == 1'b0) begin
      // Data Outputs
      DATA_OUT   <= ZERO_DATA;

      // Control Outputs
      READY      <= 1'b0;

      // Assignations
      index_loop <= ZERO_DATA;
    end else begin
      case (cosh_ctrl_fsm_int)
        STARTER_STATE: begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if (START == 1'b1) begin
            // Assignations
            index_loop        <= ZERO_DATA;

            // FSM Control
            cosh_ctrl_fsm_int <= INPUT_STATE;
          end
        end
        INPUT_STATE: begin  // STEP 1
          if (DATA_IN_ENABLE == 1'b1) begin
            // Data Inputs
            data_in_scalar_cosh <= DATA_IN;

            if (index_loop == ZERO_DATA) begin
              // Control Internal
              start_scalar_cosh <= 1'b1;
            end

            // FSM Control
            cosh_ctrl_fsm_int <= ENDER_STATE;
          end

          // Control Outputs
          DATA_OUT_ENABLE <= 1'b0;
        end
        ENDER_STATE: begin  // STEP 2
          if (ready_scalar_cosh == 1'b1) begin
            if (index_loop == (SIZE_IN - ONE_CONTROL)) begin
              // Control Outputs
              READY             <= 1'b1;

              // FSM Control
              cosh_ctrl_fsm_int <= STARTER_STATE;
            end else begin
              // Control Internal
              index_loop        <= (index_loop + ONE_CONTROL);

              // FSM Control
              cosh_ctrl_fsm_int <= INPUT_STATE;
            end

            // Data Outputs
            DATA_OUT        <= data_out_scalar_cosh;

            // Control Outputs
            DATA_OUT_ENABLE <= 1'b1;
          end else begin
            // Control Internal
            start_scalar_cosh <= 1'b0;
          end
        end
        default: begin
          // FSM Control
          cosh_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // COSH
  accelerator_scalar_cosh_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_cosh_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_cosh),
    .READY(ready_scalar_cosh),

    // DATA
    .DATA_IN (data_in_scalar_cosh),
    .DATA_OUT(data_out_scalar_cosh)
  );

endmodule
