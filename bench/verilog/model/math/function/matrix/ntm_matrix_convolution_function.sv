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

module ntm_matrix_convolution_function #(
  parameter DATA_SIZE=512,
  parameter INDEX_SIZE=512
)
  (
    // GLOBAL
    input CLK,
    input RST,

    // CONTROL
    input START,
    output reg READY,

    input DATA_A_IN_MATRIX_ENABLE,
    input DATA_A_IN_VECTOR_ENABLE,
    input DATA_A_IN_SCALAR_ENABLE,
    input DATA_B_IN_MATRIX_ENABLE,
    input DATA_B_IN_VECTOR_ENABLE,
    input DATA_B_IN_SCALAR_ENABLE,
    output reg DATA_OUT_MATRIX_ENABLE,
    output reg DATA_OUT_VECTOR_ENABLE,
    output reg DATA_OUT_SCALAR_ENABLE,

    // DATA
    input [DATA_SIZE-1:0] MODULO_IN,
    input [DATA_SIZE-1:0] SIZE_I_IN,
    input [DATA_SIZE-1:0] SIZE_J_IN,
    input [DATA_SIZE-1:0] LENGTH_IN,
    input [DATA_SIZE-1:0] DATA_A_IN,
    input [DATA_SIZE-1:0] DATA_B_IN,
    output reg [DATA_SIZE-1:0] DATA_OUT
  );

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

  parameter ZERO  = 0;
  parameter ONE   = 1;
  parameter TWO   = 2;
  parameter THREE = 3;

  parameter FULL  = 1;
  parameter EMPTY = 0;

  parameter EULER = 0;

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

  // Finite State Machine
  reg [2:0] convolution_ctrl_fsm_int;

  // Internal Signals
  reg [INDEX_SIZE-1:0] index_matrix_loop;
  reg [INDEX_SIZE-1:0] index_vector_loop;
  reg [INDEX_SIZE-1:0] index_scalar_loop;

  reg data_a_in_matrix_convolution_int;
  reg data_a_in_vector_convolution_int;
  reg data_a_in_scalar_convolution_int;
  reg data_b_in_matrix_convolution_int;
  reg data_b_in_vector_convolution_int;
  reg data_b_in_scalar_convolution_int;

  // COSINE SIMILARITY
  // CONTROL
  reg start_vector_convolution;

  wire ready_vector_convolution;
  reg data_a_in_vector_enable_vector_convolution;
  reg data_a_in_scalar_enable_vector_convolution;
  reg data_b_in_vector_enable_vector_convolution;
  reg data_b_in_scalar_enable_vector_convolution;
  wire data_out_vector_enable_vector_convolution;
  wire data_out_scalar_enable_vector_convolution;

  // DATA
  reg [DATA_SIZE-1:0] modulo_in_vector_convolution;
  reg [DATA_SIZE-1:0] size_in_vector_convolution;
  reg [DATA_SIZE-1:0] length_in_vector_convolution;
  reg [DATA_SIZE-1:0] data_a_in_vector_convolution;
  reg [DATA_SIZE-1:0] data_b_in_vector_convolution;
  wire [DATA_SIZE-1:0] data_out_vector_convolution;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  always @(posedge CLK or posedge RST) begin
    if(RST == 1'b0) begin
      // Data Outputs
      DATA_OUT <= ZERO;

      // Control Outputs
      READY <= 1'b0;

      // Assignations
      index_matrix_loop <= ZERO;
      index_vector_loop <= ZERO;
      index_scalar_loop <= ZERO;

      data_a_in_matrix_convolution_int <= 1'b0;
      data_a_in_vector_convolution_int <= 1'b0;
      data_a_in_scalar_convolution_int <= 1'b0;
      data_b_in_matrix_convolution_int <= 1'b0;
      data_b_in_vector_convolution_int <= 1'b0;
      data_b_in_scalar_convolution_int <= 1'b0;
    end
    else begin
      case(convolution_ctrl_fsm_int)
        STARTER_STATE : begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if(START == 1'b1) begin
            // Assignations
            index_matrix_loop <= ZERO;
            index_vector_loop <= ZERO;
            index_scalar_loop <= ZERO;

            // FSM Control
            convolution_ctrl_fsm_int <= INPUT_MATRIX_STATE;
          end
        end
        INPUT_MATRIX_STATE : begin  // STEP 1
          if(DATA_A_IN_MATRIX_ENABLE == 1'b1) begin
            // Data Inputs
            data_a_in_vector_convolution <= DATA_A_IN;

            // Control Internal
            data_a_in_vector_enable_vector_convolution <= 1'b1;
            data_a_in_matrix_convolution_int <= 1'b1;
          end
          else begin
            // Control Internal
            data_a_in_vector_enable_vector_convolution <= 1'b0;
          end

          if(DATA_B_IN_MATRIX_ENABLE == 1'b1) begin
            // Data Inputs
            data_b_in_vector_convolution <= DATA_B_IN;
            // Control Internal
            data_b_in_vector_enable_vector_convolution <= 1'b1;
            data_b_in_matrix_convolution_int <= 1'b1;
          end
          else begin
            // Control Internal
            data_b_in_vector_enable_vector_convolution <= 1'b0;
          end

          if((data_a_in_matrix_convolution_int == 1'b1 && data_b_in_matrix_convolution_int == 1'b1)) begin
            if((index_matrix_loop == ZERO)) begin
              // Control Internal
              start_vector_convolution <= 1'b1;
            end

            // Data Inputs
            modulo_in_vector_convolution <= MODULO_IN;

            // FSM Control
            convolution_ctrl_fsm_int <= ENDER_STATE;
          end

          // Control Outputs
          DATA_OUT_MATRIX_ENABLE <= 1'b0;
          DATA_OUT_VECTOR_ENABLE <= 1'b0;
          DATA_OUT_SCALAR_ENABLE <= 1'b0;
        end
        INPUT_VECTOR_STATE : begin  // STEP 2
          if(DATA_A_IN_VECTOR_ENABLE == 1'b1) begin
            // Data Inputs
            data_a_in_vector_convolution <= DATA_A_IN;

            // Control Internal
            data_a_in_vector_enable_vector_convolution <= 1'b1;
            data_a_in_vector_convolution_int <= 1'b1;
          end
          else begin
            // Control Internal
            data_a_in_vector_enable_vector_convolution <= 1'b0;
          end

          if(DATA_B_IN_VECTOR_ENABLE == 1'b1) begin
            // Data Inputs
            data_b_in_vector_convolution <= DATA_B_IN;

            // Control Internal
            data_b_in_vector_enable_vector_convolution <= 1'b1;
            data_b_in_vector_convolution_int <= 1'b1;
          end
          else begin
            // Control Internal
            data_b_in_vector_enable_vector_convolution <= 1'b0;
          end
          if((data_a_in_vector_convolution_int == 1'b1 && data_b_in_vector_convolution_int == 1'b1)) begin
            if(index_vector_loop == ZERO) begin
              // Control Internal
              start_vector_convolution <= 1'b1;
            end

            // Data Inputs
            modulo_in_vector_convolution <= MODULO_IN;
            size_in_vector_convolution <= SIZE_J_IN;

            // FSM Control
            convolution_ctrl_fsm_int <= ENDER_STATE;
          end

          // Control Outputs
          DATA_OUT_VECTOR_ENABLE <= 1'b0;
          DATA_OUT_SCALAR_ENABLE <= 1'b0;
        end
        INPUT_SCALAR_STATE : begin  // STEP 2
          if(DATA_A_IN_SCALAR_ENABLE == 1'b1) begin
            // Data Inputs
            data_a_in_vector_convolution <= DATA_A_IN;

            // Control Internal
            data_a_in_vector_enable_vector_convolution <= 1'b1;
            data_a_in_scalar_convolution_int <= 1'b1;
          end
          else begin
            // Control Internal
            data_a_in_vector_enable_vector_convolution <= 1'b0;
          end

          if(DATA_B_IN_SCALAR_ENABLE == 1'b1) begin
            // Data Inputs
            data_b_in_vector_convolution <= DATA_B_IN;

            // Control Internal
            data_b_in_vector_enable_vector_convolution <= 1'b1;
            data_b_in_scalar_convolution_int <= 1'b1;
          end
          else begin
            // Control Internal
            data_b_in_vector_enable_vector_convolution <= 1'b0;
          end

          if((data_a_in_scalar_convolution_int == 1'b1 && data_b_in_scalar_convolution_int == 1'b1)) begin
            if(index_vector_loop == ZERO) begin
              // Control Internal
              start_vector_convolution <= 1'b1;
            end

            // Data Inputs
            modulo_in_vector_convolution <= MODULO_IN;
            length_in_vector_convolution <= LENGTH_IN;

            // FSM Control
            convolution_ctrl_fsm_int <= ENDER_STATE;
          end

          // Control Outputs
          DATA_OUT_SCALAR_ENABLE <= 1'b0;
        end
        ENDER_STATE : begin  // STEP 4
          if(ready_vector_convolution == 1'b1) begin
            if((index_matrix_loop == (SIZE_I_IN - ONE) && index_vector_loop == (SIZE_J_IN - ONE) && index_scalar_loop == (LENGTH_IN - ONE))) begin
              // Control Outputs
              READY <= 1'b1;
              DATA_OUT_VECTOR_ENABLE <= 1'b1;

              // FSM Control
              convolution_ctrl_fsm_int <= STARTER_STATE;
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
              convolution_ctrl_fsm_int <= INPUT_MATRIX_STATE;
            end
            else if((index_matrix_loop < (SIZE_I_IN - ONE) && index_vector_loop < (SIZE_J_IN - ONE) && index_scalar_loop == (LENGTH_IN - ONE))) begin
              // Control Internal
              index_vector_loop <= (index_vector_loop + ONE);
              index_vector_loop <= ZERO;

              // Control Outputs
              DATA_OUT_VECTOR_ENABLE <= 1'b1;
              DATA_OUT_SCALAR_ENABLE <= 1'b1;

              // FSM Control
              convolution_ctrl_fsm_int <= INPUT_VECTOR_STATE;
            end
            else if((index_matrix_loop < (SIZE_I_IN - ONE) && index_vector_loop < (SIZE_J_IN - ONE) && index_scalar_loop < (LENGTH_IN - ONE))) begin
              // Control Internal
              index_scalar_loop <= (index_scalar_loop + ONE);

              // Control Outputs
              DATA_OUT_SCALAR_ENABLE <= 1'b1;

              // FSM Control
              convolution_ctrl_fsm_int <= INPUT_SCALAR_STATE;
            end

            // Data Outputs
            DATA_OUT <= data_out_vector_convolution;
          end
          else begin
            // Control Internal
            start_vector_convolution <= 1'b0;

            data_a_in_matrix_convolution_int <= 1'b0;
            data_a_in_vector_convolution_int <= 1'b0;
            data_a_in_scalar_convolution_int <= 1'b0;
            data_b_in_matrix_convolution_int <= 1'b0;
            data_b_in_vector_convolution_int <= 1'b0;
            data_b_in_scalar_convolution_int <= 1'b0;

            data_a_in_vector_enable_vector_convolution <= 1'b0;
            data_a_in_scalar_enable_vector_convolution <= 1'b0;
            data_b_in_vector_enable_vector_convolution <= 1'b0;
            data_b_in_scalar_enable_vector_convolution <= 1'b0;
          end
        end
        default : begin
          // FSM Control
          convolution_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // CONVOLUTION
  ntm_vector_convolution_function #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
  vector_convolution_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_convolution),
    .READY(ready_vector_convolution),

    .DATA_A_IN_VECTOR_ENABLE(data_a_in_vector_enable_vector_convolution),
    .DATA_A_IN_SCALAR_ENABLE(data_a_in_scalar_enable_vector_convolution),
    .DATA_B_IN_VECTOR_ENABLE(data_b_in_vector_enable_vector_convolution),
    .DATA_B_IN_SCALAR_ENABLE(data_b_in_scalar_enable_vector_convolution),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_convolution),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_convolution),

    // DATA
    .MODULO_IN(modulo_in_vector_convolution),
    .SIZE_IN(size_in_vector_convolution),
    .LENGTH_IN(length_in_vector_convolution),
    .DATA_A_IN(data_a_in_vector_convolution),
    .DATA_B_IN(data_b_in_vector_convolution),
    .DATA_OUT(data_out_vector_convolution)
  );

endmodule
