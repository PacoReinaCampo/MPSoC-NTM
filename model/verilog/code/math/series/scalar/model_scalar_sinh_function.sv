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

import model_arithmetic_verilog_pkg::*;
import model_math_verilog_pkg::*;

module model_scalar_sinh_function #(
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
  input [DATA_SIZE-1:0] DATA_IN,

  output reg [DATA_SIZE-1:0] DATA_OUT,
  output reg                 OVERFLOW_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  parameter STARTER_STATE = 1'b0;
  parameter ENDER_STATE = 1'b1;

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  // Signals
  //////////////////////////////////////////////////////////////////////////////

  // Finite State Machine
  reg  sinh_ctrl_fsm_int;

  // Data Internal
  real data_int;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if (RST == 1'b0) begin
      // Data Outputs
      DATA_OUT         <= ZERO_DATA;

      OVERFLOW_OUT     <= 1'b0;

      // Control Outputs
      READY            <= 1'b0;

      // Data Internal
      data_int         <= 0.0;

      // FSM Control
      sinh_ctrl_fsm_int <= STARTER_STATE;

    end else begin
      case (sinh_ctrl_fsm_int)
        STARTER_STATE: begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if (START == 1'b1) begin
            // Data Internal
            data_int         <= $bitstoreal(DATA_IN);

            // FSM Control
            sinh_ctrl_fsm_int <= ENDER_STATE;
          end
        end
        ENDER_STATE: begin  // STEP 1

          // Data Outputs
          DATA_OUT         <= $realtobits($sinh(data_int));

          OVERFLOW_OUT     <= 1'b0;

          // Control Outputs
          READY            <= 1'b1;

          // FSM Control
          sinh_ctrl_fsm_int <= STARTER_STATE;
        end
        default: begin
          // FSM Control
          sinh_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

endmodule
