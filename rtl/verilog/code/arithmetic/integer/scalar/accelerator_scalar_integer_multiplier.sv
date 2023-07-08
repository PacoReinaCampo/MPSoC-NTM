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

module accelerator_scalar_integer_multiplier #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 4
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input      START,
  output reg READY,

  // DATA
  input [DATA_SIZE-1:0] DATA_A_IN,
  input [DATA_SIZE-1:0] DATA_B_IN,

  output reg [DATA_SIZE-1:0] DATA_OUT,
  output reg [DATA_SIZE-1:0] OVERFLOW_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  parameter [2:0] STARTER_STATE = 0;
  parameter [2:0] SET_DATA_B_STATE = 1;
  parameter [2:0] REDUCE_DATA_B_STATE = 2;
  parameter [2:0] SET_PRODUCT_OUT_STATE = 3;
  parameter [2:0] ENDER_STATE = 4;

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
  reg [        2:0] multiplier_ctrl_fsm_int;

  // Data Internal
  reg [DATA_SIZE:0] u_int;
  reg [DATA_SIZE:0] v_int;

  reg [DATA_SIZE:0] multiplier_int;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // DATA_OUT = DATA_A_IN · DATA_B_IN

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if (RST == 1'b0) begin
      // Data Outputs
      DATA_OUT       <= ZERO_DATA;

      // Control Outputs
      READY          <= 1'b0;

      // Assignation
      u_int          <= ZERO_DATA;
      v_int          <= ZERO_DATA;

      multiplier_int <= ZERO_DATA;
    end else begin
      case (multiplier_ctrl_fsm_int)
        STARTER_STATE: begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if (START == 1'b1) begin
            // Assignation
            u_int <= {1'b0, DATA_A_IN};
            v_int <= {1'b0, DATA_B_IN};

            if (DATA_A_IN[0] == 1'b1) begin
              multiplier_int <= {1'b0, DATA_B_IN};
            end else begin
              multiplier_int <= ZERO_DATA;
            end

            // FSM Control
            multiplier_ctrl_fsm_int <= SET_DATA_B_STATE;
          end
        end
        SET_DATA_B_STATE: begin  // STEP 1
          // Assignation
          u_int <= u_int;
          v_int <= v_int;

          // FSM Control
          if (v_int < {1'b0, OVERFLOW_OUT}) begin
            multiplier_ctrl_fsm_int <= SET_PRODUCT_OUT_STATE;
          end else begin
            multiplier_ctrl_fsm_int <= REDUCE_DATA_B_STATE;
          end
        end
        REDUCE_DATA_B_STATE: begin  // STEP 2
          if (v_int < {1'b0, OVERFLOW_OUT}) begin
            // FSM Control
            multiplier_ctrl_fsm_int <= SET_PRODUCT_OUT_STATE;
          end else begin
            // Assignation
            v_int <= (v_int - {1'b0, OVERFLOW_OUT});
          end
        end
        SET_PRODUCT_OUT_STATE: begin  // STEP 3
          // Assignation
          if (u_int[0] == 1'b1) begin
            if ((multiplier_int + v_int) < {1'b0, OVERFLOW_OUT}) begin
              multiplier_int <= (multiplier_int + v_int);
            end else begin
              multiplier_int <= (multiplier_int + v_int - {1'b0, OVERFLOW_OUT});
            end
          end else begin
            if (multiplier_int >= {1'b0, OVERFLOW_OUT}) begin
              multiplier_int <= (multiplier_int - OVERFLOW_OUT);
            end
          end
          // FSM Control
          multiplier_ctrl_fsm_int <= ENDER_STATE;
        end
        ENDER_STATE: begin  // STEP 4
          if (u_int == {1'b0, ONE_CONTROL}) begin
            // Data Outputs
            DATA_OUT                <= multiplier_int[DATA_SIZE-1:0];

            // Control Outputs
            READY                   <= 1'b1;

            // FSM Control
            multiplier_ctrl_fsm_int <= STARTER_STATE;
          end else begin
            // FSM Control
            multiplier_ctrl_fsm_int <= SET_DATA_B_STATE;
          end
        end
        default: begin
          // FSM Control
          multiplier_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

endmodule
