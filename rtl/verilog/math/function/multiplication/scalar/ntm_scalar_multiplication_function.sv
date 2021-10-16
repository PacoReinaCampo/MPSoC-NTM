// File vhdl/math/function/multiplication/scalar/ntm_scalar_multiplication_function.vhd translated with vhd2vl v2.5 VHDL to Verilog RTL translator
// vhd2vl settings:
//  * Verilog Module Declaration Style: 1995

// vhd2vl is Free (libre) Software:
//   Copyright (C) 2001 Vincenzo Liguori - Ocean Logic Pty Ltd
//     http://www.ocean-logic.com
//   Modifications Copyright (C) 2006 Mark Gonzales - PMC Sierra Inc
//   Modifications (C) 2010 Shankar Giri
//   Modifications Copyright (C) 2002, 2005, 2008-2010, 2015 Larry Doolittle - LBNL
//     http://doolittle.icarus.com/~larry/vhd2vl/
//
//   vhd2vl comes with ABSOLUTELY NO WARRANTY.  Always check the resulting
//   Verilog for correctness, ideally with a formal verification tool.
//
//   You are welcome to redistribute vhd2vl under certain conditions.
//   See the license (GPLv2) file included with the source for details.

// The result of translation follows.  Its copyright status should be
// considered unchanged from the original VHDL.

//------------------------------------------------------------------------------
//                                            __ _      _     _               --
//                                           / _(_)    | |   | |              --
//                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              --
//               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              --
//              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              --
//               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              --
//                  | |                                                       --
//                  |_|                                                       --
//                                                                            --
//                                                                            --
//              Peripheral-NTM for MPSoC                                      --
//              Neural Turing Machine for MPSoC                               --
//                                                                            --
//------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------
// Author(s):
//   Paco Reina Campo <pacoreinacampo@queenfield.tech>
// no timescale needed

module ntm_scalar_multiplication_function(
CLK,
RST,
START,
READY,
DATA_IN_ENABLE,
DATA_OUT_ENABLE,
MODULO_IN,
LENGTH_IN,
DATA_IN,
DATA_OUT
);

parameter [31:0] DATA_SIZE=512;
// GLOBAL
input CLK;
input RST;
// CONTROL
input START;
output READY;
input DATA_IN_ENABLE;
output DATA_OUT_ENABLE;
// DATA
input [DATA_SIZE - 1:0] MODULO_IN;
input [DATA_SIZE - 1:0] LENGTH_IN;
input [DATA_SIZE - 1:0] DATA_IN;
output [DATA_SIZE - 1:0] DATA_OUT;

wire CLK;
wire RST;
wire START;
reg READY;
wire DATA_IN_ENABLE;
reg DATA_OUT_ENABLE;
wire [DATA_SIZE - 1:0] MODULO_IN;
wire [DATA_SIZE - 1:0] LENGTH_IN;
wire [DATA_SIZE - 1:0] DATA_IN;
reg [DATA_SIZE - 1:0] DATA_OUT;


//---------------------------------------------------------------------
// Types
//---------------------------------------------------------------------
parameter [0:0]
  STARTER_STATE = 0,
  ENDER_STATE = 1;
  //---------------------------------------------------------------------
// Constants
//---------------------------------------------------------------------
parameter ZERO = ((0));
parameter ONE = ((1));  //---------------------------------------------------------------------
// Signals
//---------------------------------------------------------------------
// Finite State Machine
reg multiplication_ctrl_fsm_int;  // Internal Signals
reg [DATA_SIZE - 1:0] index_loop;  // SCALAR MULTIPLIER
// CONTROL
wire start_scalar_multiplier;
wire ready_scalar_multiplier;  // DATA
reg [DATA_SIZE - 1:0] modulo_in_scalar_multiplier;
reg [DATA_SIZE - 1:0] data_a_in_scalar_multiplier;
reg [DATA_SIZE - 1:0] data_b_in_scalar_multiplier;
wire [DATA_SIZE - 1:0] data_out_scalar_multiplier;

  //---------------------------------------------------------------------
  // Body
  //--------------------------------------------------------------------------------------------------------------------------------------------
  always @(posedge CLK or posedge RST) begin
    if((RST == 1'b 0)) begin
      // Data Outputs
      DATA_OUT <= ZERO;
      // Control Outputs
      READY <= 1'b 0;
      DATA_OUT_ENABLE <= 1'b 0;
      // Assignations
      index_loop <= ZERO;
    end else begin
      case(multiplication_ctrl_fsm_int)
      STARTER_STATE : begin
        // STEP 0
        // Control Outputs
        READY <= 1'b 0;
        DATA_OUT_ENABLE <= 1'b 0;
        if((START == 1'b 1)) begin
          // Assignations
          index_loop <= ZERO;
          // Data Outputs
          modulo_in_scalar_multiplier <= MODULO_IN;
          // FSM Control
          multiplication_ctrl_fsm_int <= ENDER_STATE;
        end
      end
      ENDER_STATE : begin
        // STEP 1
        if((DATA_IN_ENABLE == 1'b 1)) begin
          if((((index_loop)) == (((LENGTH_IN)) - ((ONE))))) begin
            // Control Outputs
            READY <= 1'b 1;
            DATA_OUT_ENABLE <= 1'b 1;
            // Data Outputs
            DATA_OUT <= data_out_scalar_multiplier;
            // FSM Control
            multiplication_ctrl_fsm_int <= STARTER_STATE;
          end
          else begin
            // Control Internal
            index_loop <= (((index_loop)) + ((ONE)));
          end
          // Data Outputs
          data_a_in_scalar_multiplier <= DATA_IN;
          data_b_in_scalar_multiplier <= data_out_scalar_multiplier;
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
  ntm_scalar_multiplier #(
      .DATA_SIZE(DATA_SIZE))
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
    .DATA_OUT(data_out_scalar_multiplier));


endmodule
