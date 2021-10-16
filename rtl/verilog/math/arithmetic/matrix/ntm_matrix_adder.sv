// File vhdl/math/arithmetic/matrix/ntm_matrix_adder.vhd translated with vhd2vl v2.5 VHDL to Verilog RTL translator
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

module ntm_matrix_adder(
CLK,
RST,
START,
READY,
OPERATION,
DATA_A_IN_I_ENABLE,
DATA_A_IN_J_ENABLE,
DATA_B_IN_I_ENABLE,
DATA_B_IN_J_ENABLE,
DATA_OUT_I_ENABLE,
DATA_OUT_J_ENABLE,
MODULO_IN,
SIZE_I_IN,
SIZE_J_IN,
DATA_A_IN,
DATA_B_IN,
DATA_OUT
);

parameter [31:0] DATA_SIZE=512;
// GLOBAL
input CLK;
input RST;
// CONTROL
input START;
output READY;
input OPERATION;
input DATA_A_IN_I_ENABLE;
input DATA_A_IN_J_ENABLE;
input DATA_B_IN_I_ENABLE;
input DATA_B_IN_J_ENABLE;
output DATA_OUT_I_ENABLE;
output DATA_OUT_J_ENABLE;
// DATA
input [DATA_SIZE - 1:0] MODULO_IN;
input [DATA_SIZE - 1:0] SIZE_I_IN;
input [DATA_SIZE - 1:0] SIZE_J_IN;
input [DATA_SIZE - 1:0] DATA_A_IN;
input [DATA_SIZE - 1:0] DATA_B_IN;
output [DATA_SIZE - 1:0] DATA_OUT;

wire CLK;
wire RST;
wire START;
reg READY;
wire OPERATION;
wire DATA_A_IN_I_ENABLE;
wire DATA_A_IN_J_ENABLE;
wire DATA_B_IN_I_ENABLE;
wire DATA_B_IN_J_ENABLE;
reg DATA_OUT_I_ENABLE;
reg DATA_OUT_J_ENABLE;
wire [DATA_SIZE - 1:0] MODULO_IN;
wire [DATA_SIZE - 1:0] SIZE_I_IN;
wire [DATA_SIZE - 1:0] SIZE_J_IN;
wire [DATA_SIZE - 1:0] DATA_A_IN;
wire [DATA_SIZE - 1:0] DATA_B_IN;
reg [DATA_SIZE - 1:0] DATA_OUT;


//---------------------------------------------------------------------
// Types
//---------------------------------------------------------------------
parameter [1:0]
  STARTER_STATE = 0,
  INPUT_I_STATE = 1,
  INPUT_J_STATE = 2,
  ENDER_STATE = 3;
  //---------------------------------------------------------------------
// Constants
//---------------------------------------------------------------------
parameter ZERO = ((0));
parameter ONE = ((1));  //---------------------------------------------------------------------
// Signals
//---------------------------------------------------------------------
// Finite State Machine
reg [1:0] adder_ctrl_fsm_int;  // Internal Signals
reg [DATA_SIZE - 1:0] index_i_loop;
reg [DATA_SIZE - 1:0] index_j_loop;
reg data_a_in_i_adder_int;
reg data_a_in_j_adder_int;
reg data_b_in_i_adder_int;
reg data_b_in_j_adder_int;  // ADDER
// CONTROL
reg start_vector_adder;
wire ready_vector_adder;
wire operation_vector_adder;
reg data_a_in_enable_vector_adder;
reg data_b_in_enable_vector_adder;
wire data_out_enable_vector_adder;  // DATA
reg [DATA_SIZE - 1:0] modulo_in_vector_adder;
reg [DATA_SIZE - 1:0] size_in_vector_adder;
reg [DATA_SIZE - 1:0] data_a_in_vector_adder;
reg [DATA_SIZE - 1:0] data_b_in_vector_adder;
wire [DATA_SIZE - 1:0] data_out_vector_adder;

  //---------------------------------------------------------------------
  // Body
  //---------------------------------------------------------------------
  // DATA_OUT = DATA_B_IN + DATA_A_IN mod MODULO_IN
  always @(posedge CLK or posedge RST) begin
    if((RST == 1'b 0)) begin
      // Data Outputs
      DATA_OUT <= ZERO;
      // Control Outputs
      READY <= 1'b 0;
      // Assignations
      index_i_loop <= ZERO;
      index_j_loop <= ZERO;
      data_a_in_i_adder_int <= 1'b 0;
      data_a_in_j_adder_int <= 1'b 0;
      data_b_in_i_adder_int <= 1'b 0;
      data_b_in_j_adder_int <= 1'b 0;
    end else begin
      case(adder_ctrl_fsm_int)
      STARTER_STATE : begin
        // STEP 0
        // Control Outputs
        READY <= 1'b 0;
        if((START == 1'b 1)) begin
          // Assignations
          index_i_loop <= ZERO;
          index_j_loop <= ZERO;
          // FSM Control
          adder_ctrl_fsm_int <= INPUT_I_STATE;
        end
      end
      INPUT_I_STATE : begin
        // STEP 1
        if((DATA_A_IN_I_ENABLE == 1'b 1)) begin
          // Data Inputs
          data_a_in_vector_adder <= DATA_A_IN;
          // Control Internal
          data_a_in_enable_vector_adder <= 1'b 1;
          data_a_in_i_adder_int <= 1'b 1;
        end
        else begin
          // Control Internal
          data_a_in_enable_vector_adder <= 1'b 0;
        end
        if((DATA_B_IN_I_ENABLE == 1'b 1)) begin
          // Data Inputs
          data_b_in_vector_adder <= DATA_B_IN;
          // Control Internal
          data_b_in_enable_vector_adder <= 1'b 1;
          data_b_in_i_adder_int <= 1'b 1;
        end
        else begin
          // Control Internal
          data_b_in_enable_vector_adder <= 1'b 0;
        end
        if((data_a_in_i_adder_int == 1'b 1 && data_b_in_i_adder_int == 1'b 1)) begin
          if((index_i_loop == ZERO)) begin
            // Control Internal
            start_vector_adder <= 1'b 1;
          end
          // Data Inputs
          modulo_in_vector_adder <= MODULO_IN;
          // FSM Control
          adder_ctrl_fsm_int <= ENDER_STATE;
        end
        // Control Outputs
        DATA_OUT_I_ENABLE <= 1'b 0;
        DATA_OUT_J_ENABLE <= 1'b 0;
      end
      INPUT_J_STATE : begin
        // STEP 2
        if((DATA_A_IN_J_ENABLE == 1'b 1)) begin
          // Data Inputs
          data_a_in_vector_adder <= DATA_A_IN;
          // Control Internal
          data_a_in_enable_vector_adder <= 1'b 1;
          data_a_in_j_adder_int <= 1'b 1;
        end
        else begin
          // Control Internal
          data_a_in_enable_vector_adder <= 1'b 0;
        end
        if((DATA_B_IN_J_ENABLE == 1'b 1)) begin
          // Data Inputs
          data_b_in_vector_adder <= DATA_B_IN;
          // Control Internal
          data_b_in_enable_vector_adder <= 1'b 1;
          data_b_in_j_adder_int <= 1'b 1;
        end
        else begin
          // Control Internal
          data_b_in_enable_vector_adder <= 1'b 0;
        end
        if((data_a_in_j_adder_int == 1'b 1 && data_b_in_j_adder_int == 1'b 1)) begin
          if((index_j_loop == ZERO)) begin
            // Control Internal
            start_vector_adder <= 1'b 1;
          end
          // Data Inputs
          modulo_in_vector_adder <= MODULO_IN;
          size_in_vector_adder <= SIZE_J_IN;
          // FSM Control
          adder_ctrl_fsm_int <= ENDER_STATE;
        end
        // Control Outputs
        DATA_OUT_J_ENABLE <= 1'b 0;
      end
      ENDER_STATE : begin
        // STEP 3
        if((ready_vector_adder == 1'b 1)) begin
          if(((((index_i_loop)) == (((SIZE_I_IN)) - ((ONE)))) && (((index_j_loop)) == ((((SIZE_J_IN)) - ((ONE))))))) begin
            // Control Outputs
            READY <= 1'b 1;
            DATA_OUT_J_ENABLE <= 1'b 1;
            // FSM Control
            adder_ctrl_fsm_int <= STARTER_STATE;
          end
          else if(((((index_i_loop)) < (((SIZE_I_IN)) - ((ONE)))) && (((index_j_loop)) == ((((SIZE_J_IN)) - ((ONE))))))) begin
            // Control Internal
            index_i_loop <= (((index_i_loop)) + ((ONE)));
            index_j_loop <= ZERO;
            // Control Outputs
            DATA_OUT_I_ENABLE <= 1'b 1;
            DATA_OUT_J_ENABLE <= 1'b 1;
            // FSM Control
            adder_ctrl_fsm_int <= INPUT_I_STATE;
          end
          else if(((((index_i_loop)) < (((SIZE_I_IN)) - ((ONE)))) && (((index_j_loop)) < ((((SIZE_J_IN)) - ((ONE))))))) begin
            // Control Internal
            index_j_loop <= (((index_j_loop)) + ((ONE)));
            // Control Outputs
            DATA_OUT_J_ENABLE <= 1'b 1;
            // FSM Control
            adder_ctrl_fsm_int <= INPUT_J_STATE;
          end
          // Data Outputs
          DATA_OUT <= data_out_vector_adder;
        end
        else begin
          // Control Internal
          start_vector_adder <= 1'b 0;
          data_a_in_i_adder_int <= 1'b 0;
          data_a_in_j_adder_int <= 1'b 0;
          data_b_in_i_adder_int <= 1'b 0;
          data_b_in_j_adder_int <= 1'b 0;
        end
      end
      default : begin
        // FSM Control
        adder_ctrl_fsm_int <= STARTER_STATE;
      end
      endcase
    end
  end

  // ADDER
  ntm_vector_adder #(
      .DATA_SIZE(DATA_SIZE))
  vector_adder(
      // GLOBAL
    .CLK(CLK),
    .RST(RST),
    // CONTROL
    .START(start_vector_adder),
    .READY(ready_vector_adder),
    .OPERATION(operation_vector_adder),
    .DATA_A_IN_ENABLE(data_a_in_enable_vector_adder),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_adder),
    .DATA_OUT_ENABLE(data_out_enable_vector_adder),
    // DATA
    .MODULO_IN(modulo_in_vector_adder),
    .SIZE_IN(size_in_vector_adder),
    .DATA_A_IN(data_a_in_vector_adder),
    .DATA_B_IN(data_b_in_vector_adder),
    .DATA_OUT(data_out_vector_adder));


endmodule
