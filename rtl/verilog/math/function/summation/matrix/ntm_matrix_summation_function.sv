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

module ntm_matrix_summation_function(
  CLK,
  RST,
  START,
  READY,
  DATA_IN_MATRIX_ENABLE,
  DATA_IN_VECTOR_ENABLE,
  DATA_IN_SCALAR_ENABLE,
  DATA_OUT_MATRIX_ENABLE,
  DATA_OUT_VECTOR_ENABLE,
  DATA_OUT_SCALAR_ENABLE,
  MODULO_IN,
  SIZE_I_IN,
  SIZE_J_IN,
  LENGTH_IN,
  DATA_IN,
  DATA_OUT
);

  parameter DATA_SIZE=512;

  // GLOBAL
  input CLK;
  input RST;

  // CONTROL
  input START;
  output READY;

  input DATA_IN_MATRIX_ENABLE;
  input DATA_IN_VECTOR_ENABLE;
  input DATA_IN_SCALAR_ENABLE;
  output DATA_OUT_MATRIX_ENABLE;
  output DATA_OUT_VECTOR_ENABLE;
  output DATA_OUT_SCALAR_ENABLE;

  // DATA
  input [DATA_SIZE-1:0] MODULO_IN;
  input [DATA_SIZE-1:0] SIZE_I_IN;
  input [DATA_SIZE-1:0] SIZE_J_IN;
  input [DATA_SIZE-1:0] LENGTH_IN;
  input [DATA_SIZE-1:0] DATA_IN;
  output [DATA_SIZE-1:0] DATA_OUT;

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  parameter [2:0] STARTER_STATE = 0;
  parameter [2:0] INPUT_MATRIX_STATE = 1;
  parameter [2:0] INPUT_VECTOR_STATE = 2;
  parameter [2:0] INPUT_SCALAR_STATE = 3;
  parameter [2:0] ENDER_STATE = 4;

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  parameter ZERO = 0;
  parameter ONE = 1;

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

  // Finite State Machine
  reg [2:0] summation_ctrl_fsm_int;

  // Internal Signals
  reg [DATA_SIZE-1:0] index_matrix_loop;
  reg [DATA_SIZE-1:0] index_vector_loop;
  reg [DATA_SIZE-1:0] index_scalar_loop;

  // SOFTMAX
  // CONTROL
  reg start_vector_summation;
  wire ready_vector_summation;

  reg data_in_vector_enable_vector_summation;
  reg data_in_scalar_enable_vector_summation;
  wire data_out_vector_enable_vector_summation;
  wire data_out_scalar_enable_vector_summation;

  // DATA
  reg [DATA_SIZE-1:0] modulo_in_vector_summation;
  reg [DATA_SIZE-1:0] size_in_vector_summation;
  reg [DATA_SIZE-1:0] length_in_vector_summation;
  reg [DATA_SIZE-1:0] data_in_vector_summation;
  wire [DATA_SIZE-1:0] data_out_vector_summation;

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
      index_matrix_loop <= ZERO;
      index_vector_loop <= ZERO;
      index_scalar_loop <= ZERO;
    end else begin
      case(summation_ctrl_fsm_int)
        STARTER_STATE : begin
          // STEP 0
          // Control Outputs
          READY <= 1'b0;
          if(START == 1'b1) begin
            // Assignations
            index_matrix_loop <= ZERO;
            index_vector_loop <= ZERO;
            index_scalar_loop <= ZERO;
            // FSM Control
            summation_ctrl_fsm_int <= INPUT_MATRIX_STATE;
          end
        end
        INPUT_MATRIX_STATE : begin
          // STEP 1
          if((DATA_IN_MATRIX_ENABLE == 1'b1)) begin
            // Data Inputs
            modulo_in_vector_summation <= MODULO_IN;
            data_in_vector_summation <= DATA_IN;
            if((index_matrix_loop == ZERO)) begin
              // Control Internal
              start_vector_summation <= 1'b1;
            end
            data_in_vector_enable_vector_summation <= 1'b1;
            data_in_scalar_enable_vector_summation <= 1'b1;
            // FSM Control
            summation_ctrl_fsm_int <= ENDER_STATE;
          end
          else begin
            // Control Internal
            data_in_vector_enable_vector_summation <= 1'b0;
            data_in_scalar_enable_vector_summation <= 1'b0;
          end
          // Control Outputs
          DATA_OUT_MATRIX_ENABLE <= 1'b0;
          DATA_OUT_VECTOR_ENABLE <= 1'b0;
          DATA_OUT_SCALAR_ENABLE <= 1'b0;
        end
        INPUT_VECTOR_STATE : begin
          // STEP 1
          if((DATA_IN_VECTOR_ENABLE == 1'b1)) begin
            // Data Inputs
            modulo_in_vector_summation <= MODULO_IN;
            size_in_vector_summation <= SIZE_J_IN;
            data_in_vector_summation <= DATA_IN;
            if((index_vector_loop == ZERO)) begin
              // Control Internal
              start_vector_summation <= 1'b1;
            end
            data_in_vector_enable_vector_summation <= 1'b1;
            data_in_scalar_enable_vector_summation <= 1'b1;
            // FSM Control
            summation_ctrl_fsm_int <= ENDER_STATE;
          end
          else begin
            // Control Internal
            data_in_vector_enable_vector_summation <= 1'b0;
            data_in_scalar_enable_vector_summation <= 1'b0;
          end
          // Control Outputs
          DATA_OUT_VECTOR_ENABLE <= 1'b0;
          DATA_OUT_SCALAR_ENABLE <= 1'b0;
        end
        INPUT_SCALAR_STATE : begin
          // STEP 2
          if((DATA_IN_SCALAR_ENABLE == 1'b1)) begin
            // Data Inputs
            modulo_in_vector_summation <= MODULO_IN;
            length_in_vector_summation <= LENGTH_IN;
            data_in_vector_summation <= DATA_IN;
            if((index_scalar_loop == ZERO)) begin
              // Control Internal
              start_vector_summation <= 1'b1;
            end
            data_in_scalar_enable_vector_summation <= 1'b1;
            // FSM Control
            summation_ctrl_fsm_int <= ENDER_STATE;
          end
          else begin
            // Control Internal
            data_in_scalar_enable_vector_summation <= 1'b0;
          end
          // Control Outputs
          DATA_OUT_SCALAR_ENABLE <= 1'b0;
        end
        ENDER_STATE : begin
          // STEP 3
          if((ready_vector_summation == 1'b1)) begin
            if((index_matrix_loop == (SIZE_I_IN - ONE) && index_vector_loop == (SIZE_J_IN - ONE) && index_scalar_loop == (LENGTH_IN - ONE))) begin
              // Control Outputs
              READY <= 1'b1;
              DATA_OUT_VECTOR_ENABLE <= 1'b1;
              // FSM Control
              summation_ctrl_fsm_int <= STARTER_STATE;
            end
            else if((index_matrix_loop < (SIZE_I_IN - ONE) && index_vector_loop == (SIZE_J_IN - ONE) && index_scalar_loop == (LENGTH_IN - ONE))) begin
              // Control Internal
              index_matrix_loop <= (index_matrix_loop + ONE);
              index_vector_loop <= ZERO;
              // Control Outputs
              DATA_OUT_MATRIX_ENABLE <= 1'b1;
              DATA_OUT_VECTOR_ENABLE <= 1'b1;
              DATA_OUT_SCALAR_ENABLE <= 1'b1;
              // FSM Control
              summation_ctrl_fsm_int <= INPUT_MATRIX_STATE;
            end
            else if((index_matrix_loop < (SIZE_I_IN - ONE) && index_vector_loop < (SIZE_J_IN - ONE) && index_scalar_loop == (LENGTH_IN - ONE))) begin
              // Control Internal
              index_vector_loop <= (index_vector_loop + ONE);
              index_scalar_loop <= ZERO;
              // Control Outputs
              DATA_OUT_VECTOR_ENABLE <= 1'b1;
              DATA_OUT_SCALAR_ENABLE <= 1'b1;
              // FSM Control
              summation_ctrl_fsm_int <= INPUT_VECTOR_STATE;
            end
            else if((index_matrix_loop < (SIZE_I_IN - ONE) && index_vector_loop < (SIZE_J_IN - ONE) && index_scalar_loop < (LENGTH_IN - ONE))) begin
              // Control Internal
              index_scalar_loop <= (index_scalar_loop + ONE);
              // Control Outputs
              DATA_OUT_SCALAR_ENABLE <= 1'b1;
              // FSM Control
              summation_ctrl_fsm_int <= INPUT_SCALAR_STATE;
            end
            // Data Outputs
            DATA_OUT <= data_out_vector_summation;
          end
          else begin
            // Control Internal
            start_vector_summation <= 1'b0;
            data_in_vector_enable_vector_summation <= 1'b0;
            data_in_scalar_enable_vector_summation <= 1'b0;
          end
        end
        default : begin
          // FSM Control
          summation_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // SUMMATION
  ntm_vector_summation_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_summation_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_summation),
    .READY(ready_vector_summation),

    .DATA_IN_VECTOR_ENABLE(data_in_vector_enable_vector_summation),
    .DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_vector_summation),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_summation),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_summation),

    // DATA
    .MODULO_IN(modulo_in_vector_summation),
    .SIZE_IN(size_in_vector_summation),
    .LENGTH_IN(length_in_vector_summation),
    .DATA_IN(data_in_vector_summation),
    .DATA_OUT(data_out_vector_summation)
  );

endmodule
