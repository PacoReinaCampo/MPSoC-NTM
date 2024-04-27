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

module ntm_template #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 64
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input      START,
  output reg READY,

  // DATA
  input      [DATA_SIZE-1:0] DATA_A_IN,
  input      [DATA_SIZE-1:0] DATA_B_IN,
  input      [DATA_SIZE-1:0] DATA_X_IN,
  output reg [DATA_SIZE-1:0] DATA_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  parameter [2:0] STARTER_STATE = 0;
  parameter [2:0] FIRST_STATE = 1;
  parameter [2:0] SECOND_STATE = 2;
  parameter [2:0] THIRD_STATE = 3;
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

  //////////////////////////////////////////////////////////////////////////////
  // Signals
  //////////////////////////////////////////////////////////////////////////////

  // Finite State Machine
  reg [        2:0] template_ctrl_fsm_int;

  // Data Internal
  reg [DATA_SIZE:0] variable_u_int;
  reg [DATA_SIZE:0] variable_v_int;

  reg [DATA_SIZE:0] template_int;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // DATA_OUT = DATA_A_IN · DATA_B_IN mod DATA_X_IN

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if (RST == 1'b0) begin
      // Data Outputs
      DATA_OUT       <= ZERO_DATA;

      // Control Outputs
      READY          <= 1'b0;

      // Assignation
      variable_u_int <= ZERO_DATA;
      variable_v_int <= ZERO_DATA;

      template_int   <= ZERO_DATA;
    end else begin
      case (template_ctrl_fsm_int)
        STARTER_STATE: begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if (START == 1'b1) begin
            // Assignation
            variable_u_int <= {1'b0, DATA_A_IN};
            variable_v_int <= {1'b0, DATA_B_IN};

            if (DATA_A_IN[0] == 1'b1) begin
              template_int <= {1'b0, DATA_B_IN};
            end else begin
              template_int <= ZERO_DATA;
            end

            // FSM Control
            template_ctrl_fsm_int <= FIRST_STATE;
          end
        end
        FIRST_STATE: begin  // STEP 1
          // Assignation
          variable_u_int <= variable_u_int;
          variable_v_int <= variable_v_int;

          // FSM Control
          if (variable_v_int < {1'b0, DATA_X_IN}) begin
            template_ctrl_fsm_int <= THIRD_STATE;
          end else begin
            template_ctrl_fsm_int <= SECOND_STATE;
          end
        end
        SECOND_STATE: begin  // STEP 2
          if (variable_v_int < {1'b0, DATA_X_IN}) begin
            // FSM Control
            template_ctrl_fsm_int <= THIRD_STATE;
          end else begin
            // Assignation
            variable_v_int <= (variable_v_int - {1'b0, DATA_X_IN});
          end
        end
        THIRD_STATE: begin  // STEP 3
          // Assignation
          if (variable_u_int[0] == 1'b1) begin
            if ((template_int + variable_v_int) < {1'b0, DATA_X_IN}) begin
              template_int <= (template_int + variable_v_int);
            end else begin
              template_int <= (template_int + variable_v_int - {1'b0, DATA_X_IN});
            end
          end else begin
            if (template_int >= {1'b0, DATA_X_IN}) begin
              template_int <= (template_int - DATA_X_IN);
            end
          end
          // FSM Control
          template_ctrl_fsm_int <= ENDER_STATE;
        end
        ENDER_STATE: begin  // STEP 4
          if (variable_u_int == {1'b0, ONE_CONTROL}) begin
            // Data Outputs
            DATA_OUT              <= template_int[DATA_SIZE-1:0];

            // Control Outputs
            READY                 <= 1'b1;

            // FSM Control
            template_ctrl_fsm_int <= STARTER_STATE;
          end else begin
            // FSM Control
            template_ctrl_fsm_int <= FIRST_STATE;
          end
        end
        default: begin
          // FSM Control
          template_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

endmodule
