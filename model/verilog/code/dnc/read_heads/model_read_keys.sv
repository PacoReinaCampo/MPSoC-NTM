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

module model_read_keys #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 64
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input      START,
  output reg READY,

  input      K_IN_I_ENABLE,   // for i in 0 to R-1
  input      K_IN_K_ENABLE,   // for k in 0 to W-1
  output reg K_OUT_I_ENABLE,  // for i in 0 to R-1
  output reg K_OUT_K_ENABLE,  // for k in 0 to W-1

  // DATA
  input      [DATA_SIZE-1:0] SIZE_R_IN,
  input      [DATA_SIZE-1:0] SIZE_W_IN,
  input      [DATA_SIZE-1:0] K_IN,
  output reg [DATA_SIZE-1:0] K_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  parameter STARTER_STATE = 0;
  parameter ENDER_STATE = 1;

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
  reg                    read_keys_ctrl_fsm_int;

  // Internal Signals
  reg [CONTROL_SIZE-1:0] index_i_loop;
  reg [CONTROL_SIZE-1:0] index_j_loop;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // k(t;i;k) = k^(t;i;k)

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if (RST == 1'b0) begin
      // Data Outputs
      K_OUT        <= ZERO_DATA;

      // Control Outputs
      READY        <= 1'b0;

      // Assignations
      index_i_loop <= ZERO_DATA;
      index_j_loop <= ZERO_DATA;
    end else begin
      case (read_keys_ctrl_fsm_int)
        STARTER_STATE: begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;
          if (START == 1'b1) begin
            // Assignations
            index_i_loop           <= ZERO_DATA;
            index_j_loop           <= ZERO_DATA;

            // FSM Control
            read_keys_ctrl_fsm_int <= ENDER_STATE;
          end
        end
        ENDER_STATE: begin  // STEP 1
          if (K_IN_I_ENABLE == 1'b1) begin
            // Control Internal
            if ((index_i_loop < (SIZE_R_IN - ONE_CONTROL) && index_j_loop == (SIZE_W_IN - ONE_CONTROL))) begin
              index_i_loop <= (index_i_loop + ONE_CONTROL);
              index_j_loop <= ZERO_DATA;
            end

            // Data Outputs
            K_OUT          <= K_IN;

            // Control Outputs
            K_OUT_I_ENABLE <= 1'b1;
            K_OUT_K_ENABLE <= 1'b1;
          end else begin
            // Control Outputs
            K_OUT_I_ENABLE <= 1'b0;
            K_OUT_K_ENABLE <= 1'b0;
          end
          if ((K_IN_K_ENABLE == 1'b1)) begin
            if (index_i_loop == (SIZE_R_IN - ONE_CONTROL) && index_j_loop == (SIZE_W_IN - ONE_CONTROL)) begin
              // Control Outputs
              READY                  <= 1'b1;

              // FSM Control
              read_keys_ctrl_fsm_int <= STARTER_STATE;
            end else if (index_i_loop < (SIZE_R_IN - ONE_CONTROL) && index_j_loop < (SIZE_W_IN - ONE_CONTROL)) begin
              // Control Internal
              index_j_loop <= (index_j_loop + ONE_CONTROL);
            end
            // Data Outputs
            K_OUT          <= K_IN;

            // Control Outputs
            K_OUT_K_ENABLE <= 1'b1;
          end else begin
            // Control Outputs
            K_OUT_K_ENABLE <= 1'b0;
          end
        end
        default: begin
          // FSM Control
          read_keys_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

endmodule
