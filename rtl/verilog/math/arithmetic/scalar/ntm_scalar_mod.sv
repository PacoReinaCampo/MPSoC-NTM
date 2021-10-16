// File vhdl/math/arithmetic/scalar/ntm_scalar_mod.vhd translated with vhd2vl v2.5 VHDL to Verilog RTL translator
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

module ntm_scalar_mod(
CLK,
RST,
START,
READY,
MODULO_IN,
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
// DATA
input [DATA_SIZE - 1:0] MODULO_IN;
input [DATA_SIZE - 1:0] DATA_IN;
output [DATA_SIZE - 1:0] DATA_OUT;

wire CLK;
wire RST;
wire START;
reg READY;
wire [DATA_SIZE - 1:0] MODULO_IN;
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
parameter ZERO = ((0));  //---------------------------------------------------------------------
// Signals
//---------------------------------------------------------------------
// Finite State Machine
reg mod_ctrl_fsm_int;  // Internal Signals
reg [DATA_SIZE - 1:0] mod_int;

  //---------------------------------------------------------------------
  // Body
  //---------------------------------------------------------------------
  // DATA_OUT = DATA_IN mod MODULO_IN
  always @(posedge CLK or posedge RST) begin
    if((RST == 1'b 0)) begin
      // Data Outputs
      DATA_OUT <= ZERO;
      // Control Outputs
      READY <= 1'b 0;
      // Assignations
      mod_int <= ZERO;
    end else begin
      case(mod_ctrl_fsm_int)
      STARTER_STATE : begin
        // STEP 0
        // Control Outputs
        READY <= 1'b 0;
        if((START == 1'b 1)) begin
          // Assignations
          mod_int <= DATA_IN;
          // FSM Control
          mod_ctrl_fsm_int <= ENDER_STATE;
        end
      end
      ENDER_STATE : begin
        // STEP 1
        if((((MODULO_IN)) > ((ZERO)))) begin
          if((((mod_int)) > ((ZERO)))) begin
            if((((mod_int)) == ((MODULO_IN)))) begin
              // Data Outputs
              DATA_OUT <= ZERO;
              // Control Outputs
              READY <= 1'b 1;
              // FSM Control
              mod_ctrl_fsm_int <= STARTER_STATE;
            end
            else if((((mod_int)) < ((MODULO_IN)))) begin
              // Data Outputs
              DATA_OUT <= mod_int;
              // Control Outputs
              READY <= 1'b 1;
              // FSM Control
              mod_ctrl_fsm_int <= STARTER_STATE;
            end
            else begin
              // Assignations
              mod_int <= (((mod_int)) - ((MODULO_IN)));
            end
          end
          else if((((mod_int)) == ((ZERO)))) begin
            // Data Outputs
            DATA_OUT <= ZERO;
            // Control Outputs
            READY <= 1'b 1;
            // FSM Control
            mod_ctrl_fsm_int <= STARTER_STATE;
          end
        end
        else if((((MODULO_IN)) == ((ZERO)))) begin
          // Data Outputs
          DATA_OUT <= mod_int;
          // Control Outputs
          READY <= 1'b 1;
          // FSM Control
          mod_ctrl_fsm_int <= STARTER_STATE;
        end
      end
      default : begin
        // FSM Control
        mod_ctrl_fsm_int <= STARTER_STATE;
      end
      endcase
    end
  end


endmodule
