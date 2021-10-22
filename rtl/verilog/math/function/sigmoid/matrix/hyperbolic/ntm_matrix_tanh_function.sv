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

module ntm_matrix_tanh_function(
  CLK,
  RST,
  START,
  READY,
  DATA_IN_I_ENABLE,
  DATA_IN_J_ENABLE,
  DATA_OUT_I_ENABLE,
  DATA_OUT_J_ENABLE,
  MODULO_IN,
  SIZE_I_IN,
  SIZE_J_IN,
  DATA_IN,
  DATA_OUT
);

  parameter DATA_SIZE=512;

  // GLOBAL
  input CLK;
  input RST;

  // CONTROL
  input START;
  output reg READY;

  input DATA_IN_I_ENABLE;
  input DATA_IN_J_ENABLE;
  output reg DATA_OUT_I_ENABLE;
  output reg DATA_OUT_J_ENABLE;

  // DATA
  input [DATA_SIZE-1:0] MODULO_IN;
  input [DATA_SIZE-1:0] SIZE_I_IN;
  input [DATA_SIZE-1:0] SIZE_J_IN;
  input [DATA_SIZE-1:0] DATA_IN;
  output reg [DATA_SIZE-1:0] DATA_OUT;

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  parameter [2:0] STARTER_STATE = 0;
  parameter [2:0] INPUT_I_STATE = 1;
  parameter [2:0] INPUT_J_STATE = 2;
  parameter [2:0] ENDER_STATE = 3;

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////
  parameter ZERO = 0;
  parameter ONE = 1;

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

  // Finite State Machine
  reg [1:0] tanh_ctrl_fsm_int;

  // Internal Signals
  reg [DATA_SIZE-1:0] index_i_loop;
  reg [DATA_SIZE-1:0] index_j_loop;

  // TANH
  // CONTROL
  reg start_vector_tanh;
  wire ready_vector_tanh;
  reg data_in_enable_vector_tanh;
  wire data_out_enable_vector_tanh;

  // DATA
  reg [DATA_SIZE-1:0] modulo_in_vector_tanh;
  reg [DATA_SIZE-1:0] size_in_vector_tanh;
  reg [DATA_SIZE-1:0] data_in_vector_tanh;
  wire [DATA_SIZE-1:0] data_out_vector_tanh;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  always @(posedge CLK or posedge RST) begin
    if((RST == 1'b0)) begin
      // Data Outputs
      DATA_OUT <= ZERO;
      // Control Outputs
      READY <= 1'b0;
      // Assignations
      index_i_loop <= ZERO;
      index_j_loop <= ZERO;
    end
    else begin
      case(tanh_ctrl_fsm_int)
        STARTER_STATE : begin
          // STEP 0
          // Control Outputs
          READY <= 1'b0;
          if(START == 1'b1) begin
            // Assignations
            index_i_loop <= ZERO;
            index_j_loop <= ZERO;
            // FSM Control
            tanh_ctrl_fsm_int <= INPUT_I_STATE;
          end
        end
        INPUT_I_STATE : begin
          // STEP 1
          if((DATA_IN_I_ENABLE == 1'b1)) begin
            // Data Inputs
            modulo_in_vector_tanh <= MODULO_IN;
            data_in_vector_tanh <= DATA_IN;
            if((index_i_loop == ZERO)) begin
              // Control Internal
              start_vector_tanh <= 1'b1;
            end
            data_in_enable_vector_tanh <= 1'b1;
            // FSM Control
            tanh_ctrl_fsm_int <= ENDER_STATE;
          end
          else begin
            // Control Internal
            data_in_enable_vector_tanh <= 1'b0;
          end
          // Control Outputs
          DATA_OUT_I_ENABLE <= 1'b0;
          DATA_OUT_J_ENABLE <= 1'b0;
        end
        INPUT_J_STATE : begin
          // STEP 2
          if((DATA_IN_J_ENABLE == 1'b1)) begin
            // Data Inputs
            modulo_in_vector_tanh <= MODULO_IN;
            size_in_vector_tanh <= SIZE_J_IN;
            data_in_vector_tanh <= DATA_IN;
            if((index_j_loop == ZERO)) begin
              // Control Internal
              start_vector_tanh <= 1'b1;
            end
            data_in_enable_vector_tanh <= 1'b1;
            // FSM Control
            tanh_ctrl_fsm_int <= ENDER_STATE;
          end
          else begin
            // Control Internal
            data_in_enable_vector_tanh <= 1'b0;
          end
          // Control Outputs
          DATA_OUT_J_ENABLE <= 1'b0;
        end
        ENDER_STATE : begin
          // STEP 3
          if((ready_vector_tanh == 1'b1)) begin
            if((index_i_loop == (SIZE_I_IN - ONE)) && index_j_loop == (SIZE_J_IN - ONE)) begin
              // Control Outputs
              READY <= 1'b1;
              DATA_OUT_J_ENABLE <= 1'b1;
              // FSM Control
              tanh_ctrl_fsm_int <= STARTER_STATE;
            end
            else if((index_i_loop < (SIZE_I_IN - ONE)) && index_j_loop == (SIZE_J_IN - ONE)) begin
              // Control Internal
              index_i_loop <= (index_i_loop + ONE);
              index_j_loop <= ZERO;
              // Control Outputs
              DATA_OUT_I_ENABLE <= 1'b1;
              DATA_OUT_J_ENABLE <= 1'b1;
              // FSM Control
              tanh_ctrl_fsm_int <= INPUT_I_STATE;
            end
            else if((index_i_loop < (SIZE_I_IN - ONE)) && index_j_loop < (SIZE_J_IN - ONE)) begin
              // Control Internal
              index_j_loop <= (index_j_loop + ONE);
              // Control Outputs
              DATA_OUT_J_ENABLE <= 1'b1;
              // FSM Control
              tanh_ctrl_fsm_int <= INPUT_J_STATE;
            end
            // Data Outputs
            DATA_OUT <= data_out_vector_tanh;
          end
          else begin
            // Control Internal
            start_vector_tanh <= 1'b0;
          end
        end
        default : begin
          // FSM Control
          tanh_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // TANH
  ntm_vector_tanh_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_tanh_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_tanh),
    .READY(ready_vector_tanh),

    .DATA_IN_ENABLE(data_in_enable_vector_tanh),
    .DATA_OUT_ENABLE(data_out_enable_vector_tanh),

    // DATA
    .MODULO_IN(modulo_in_vector_tanh),
    .SIZE_IN(size_in_vector_tanh),
    .DATA_IN(data_in_vector_tanh),
    .DATA_OUT(data_out_vector_tanh)
  );

endmodule
