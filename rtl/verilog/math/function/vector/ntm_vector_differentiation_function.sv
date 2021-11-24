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

module ntm_vector_differentiation_function #(
  parameter DATA_SIZE=512
)
  (
    // GLOBAL
    input CLK,
    input RST,

    // CONTROL
    input START,
    output reg READY,

    input DATA_IN_VECTOR_ENABLE,
    input DATA_IN_SCALAR_ENABLE,

    output reg DATA_OUT_VECTOR_ENABLE,
    output reg DATA_OUT_SCALAR_ENABLE,

    // DATA
    input [DATA_SIZE-1:0] MODULO_IN,
    input [DATA_SIZE-1:0] SIZE_IN,
    input [DATA_SIZE-1:0] PERIOD_IN,
    input [DATA_SIZE-1:0] LENGTH_IN,
    input [DATA_SIZE-1:0] DATA_IN,
    output reg [DATA_SIZE-1:0] DATA_OUT
  );

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  parameter [1:0] STARTER_STATE = 0;
  parameter [1:0] INPUT_VECTOR_STATE = 1;
  parameter [1:0] INPUT_SCALAR_STATE = 2;
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
  reg [1:0] differentiation_ctrl_fsm_int;

  // Internal Signals
  reg [DATA_SIZE-1:0] index_vector_loop;
  reg [DATA_SIZE-1:0] index_scalar_loop;

  // MULTIPLICATION
  // CONTROL
  reg start_scalar_differentiation;
  wire ready_scalar_differentiation;
  reg data_in_enable_scalar_differentiation;
  wire data_out_enable_scalar_differentiation;

  // DATA
  reg [DATA_SIZE-1:0] modulo_in_scalar_differentiation;
  reg [DATA_SIZE-1:0] size_in_scalar_differentiation;
  reg [DATA_SIZE-1:0] period_in_scalar_differentiation;
  reg [DATA_SIZE-1:0] length_in_scalar_differentiation;
  reg [DATA_SIZE-1:0] data_in_scalar_differentiation;
  wire [DATA_SIZE-1:0] data_out_scalar_differentiation;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if(RST == 1'b0) begin
      // Data Outputs
      DATA_OUT <= ZERO;

      // Control Outputs
      READY <= 1'b0;

      // Assignations
      index_vector_loop <= ZERO;
      index_scalar_loop <= ZERO;
    end
    else begin
      case(differentiation_ctrl_fsm_int)
        STARTER_STATE : begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if(START == 1'b1) begin
            // Assignations
            index_vector_loop <= ZERO;
            index_scalar_loop <= ZERO;

            // FSM Control
            differentiation_ctrl_fsm_int <= INPUT_VECTOR_STATE;
          end
        end
        INPUT_VECTOR_STATE : begin  // STEP 1
          if(DATA_IN_VECTOR_ENABLE == 1'b1) begin
            // Data Inputs
            modulo_in_scalar_differentiation <= MODULO_IN;
            data_in_scalar_differentiation <= DATA_IN;

            if(index_vector_loop == ZERO) begin
              // Control Internal
              start_scalar_differentiation <= 1'b1;
            end

            data_in_enable_scalar_differentiation <= 1'b1;

            // FSM Control
            differentiation_ctrl_fsm_int <= ENDER_STATE;
          end
          else begin
            // Control Internal
            data_in_enable_scalar_differentiation <= 1'b0;
          end

          // Control Outputs
          DATA_OUT_VECTOR_ENABLE <= 1'b0;
          DATA_OUT_SCALAR_ENABLE <= 1'b0;
        end
        INPUT_SCALAR_STATE : begin  // STEP 2
          if(DATA_IN_SCALAR_ENABLE == 1'b1) begin
            // Data Inputs
            modulo_in_scalar_differentiation <= MODULO_IN;
            length_in_scalar_differentiation <= LENGTH_IN;
            data_in_scalar_differentiation <= DATA_IN;

            if(index_scalar_loop == ZERO) begin
              // Control Internal
              start_scalar_differentiation <= 1'b1;
            end

            data_in_enable_scalar_differentiation <= 1'b1;

            // FSM Control
            differentiation_ctrl_fsm_int <= ENDER_STATE;
          end
          else begin
            // Control Internal
            data_in_enable_scalar_differentiation <= 1'b0;
          end

          // Control Outputs
          DATA_OUT_SCALAR_ENABLE <= 1'b0;
        end
        ENDER_STATE : begin // STEP 3
          if(ready_scalar_differentiation == 1'b1) begin
            if(index_vector_loop == (SIZE_IN - ONE) && index_scalar_loop == (LENGTH_IN - ONE)) begin
              // Control Outputs
              READY <= 1'b1;
              DATA_OUT_SCALAR_ENABLE <= 1'b1;

              // FSM Control
              differentiation_ctrl_fsm_int <= STARTER_STATE;
            end
            else if(index_vector_loop < (SIZE_IN - ONE) && index_scalar_loop == (LENGTH_IN - ONE)) begin
              // Control Internal
              index_vector_loop <= (index_vector_loop + ONE);
              index_scalar_loop <= ZERO;

              // Control Outputs
              DATA_OUT_VECTOR_ENABLE <= 1'b1;
              DATA_OUT_SCALAR_ENABLE <= 1'b1;

              // FSM Control
              differentiation_ctrl_fsm_int <= INPUT_VECTOR_STATE;
            end
            else if(index_vector_loop < (SIZE_IN - ONE) && index_scalar_loop < (LENGTH_IN - ONE)) begin
              // Control Internal
              index_scalar_loop <= (index_scalar_loop + ONE);

              // Control Outputs
              DATA_OUT_SCALAR_ENABLE <= 1'b1;

              // FSM Control
              differentiation_ctrl_fsm_int <= INPUT_SCALAR_STATE;
            end
            // Data Outputs
            DATA_OUT <= data_out_scalar_differentiation;
          end
          else begin
            // Control Internal
            start_scalar_differentiation <= 1'b0;
          end
        end
        default : begin
          // FSM Control
          differentiation_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // SCALAR DIFFERENTIATION
  ntm_scalar_differentiation_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  scalar_differentiation_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_differentiation),
    .READY(ready_scalar_differentiation),

    .DATA_IN_ENABLE(data_in_enable_scalar_differentiation),

    .DATA_OUT_ENABLE(data_out_enable_scalar_differentiation),

    // DATA
    .MODULO_IN(modulo_in_scalar_differentiation),
    .PERIOD_IN(period_in_scalar_differentiation),
    .LENGTH_IN(length_in_scalar_differentiation),
    .DATA_IN(data_in_scalar_differentiation),
    .DATA_OUT(data_out_scalar_differentiation)
  );

endmodule
