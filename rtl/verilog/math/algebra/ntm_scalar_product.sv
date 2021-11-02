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

module ntm_scalar_product #(
  parameter DATA_SIZE=512
)
  (
    // GLOBAL
    input CLK,
    input RST,

    // CONTROL
    input START,
    output reg READY,

    input DATA_A_IN_ENABLE,
    input DATA_B_IN_ENABLE,
    output reg DATA_OUT_ENABLE,

    // DATA
    input [DATA_SIZE-1:0] MODULO_IN,
    input [DATA_SIZE-1:0] LENGTH_IN,
    input [DATA_SIZE-1:0] DATA_A_IN,
    input [DATA_SIZE-1:0] DATA_B_IN,
    output reg [DATA_SIZE-1:0] DATA_OUT
  );

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  parameter [1:0] STARTER_STATE = 0;
  parameter [1:0] SCALAR_MULTIPLIER_STATE = 1;
  parameter [1:0] SCALAR_ADDER_STATE = 2;
  parameter [1:0] ENDER_STATE = 3;

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  parameter ZERO = 0;
  parameter ONE = 1;

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

  // Finite State Machine
  reg [1:0] algebra_ctrl_fsm_int;

  // SCALAR ADDER
  // CONTROL
  wire start_scalar_adder;
  wire ready_scalar_adder;

  wire operation_scalar_adder;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_adder;
  wire [DATA_SIZE-1:0] data_a_in_scalar_adder;
  wire [DATA_SIZE-1:0] data_b_in_scalar_adder;
  wire [DATA_SIZE-1:0] data_out_scalar_adder;

  // SCALAR MULTIPLIER
  // CONTROL
  wire start_scalar_multiplier;
  wire ready_scalar_multiplier;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_multiplier;
  wire [DATA_SIZE-1:0] data_a_in_scalar_multiplier;
  wire [DATA_SIZE-1:0] data_b_in_scalar_multiplier;
  wire [DATA_SIZE-1:0] data_out_scalar_multiplier;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  // DATA_OUT = DATA_A_IN · DATA_B_IN

  always @(posedge CLK or posedge RST) begin
    if(RST == 1'b0) begin
      // Data Outputs
      DATA_OUT <= ZERO;

      // Control Outputs
      READY <= 1'b0;
    end
    else begin
      case(algebra_ctrl_fsm_int)
        STARTER_STATE : begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if(START == 1'b1) begin
            // FSM Control
            algebra_ctrl_fsm_int <= SCALAR_MULTIPLIER_STATE;
          end
        end

        SCALAR_MULTIPLIER_STATE : begin  // STEP 1
        end

        SCALAR_ADDER_STATE : begin  // STEP 2
        end

        ENDER_STATE : begin  // STEP 3
        end

        default : begin
          // FSM Control
          algebra_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // SCALAR ADDER
  ntm_scalar_adder #(
    .DATA_SIZE(DATA_SIZE)
  )
  ntm_scalar_adder_i(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_adder),
    .READY(ready_scalar_adder),

    .OPERATION(operation_scalar_adder),

    // DATA
    .MODULO_IN(modulo_in_scalar_adder),
    .DATA_A_IN(data_a_in_scalar_adder),
    .DATA_B_IN(data_b_in_scalar_adder),
    .DATA_OUT(data_out_scalar_adder)
  );

  ntm_scalar_multiplier #(
    .DATA_SIZE(DATA_SIZE)
  )
  ntm_scalar_multiplier_i(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_multiplier),
    .READY(ready_scalar_multiplier),

    // DATA
    .MODULO_IN(modulo_in_scalar_multiplier),
    .DATA_A_IN(data_a_in_scalar_multiplier),
    .DATA_B_IN(data_b_in_scalar_multiplier),
    .DATA_OUT(data_out_scalar_multiplier)
  );

endmodule
