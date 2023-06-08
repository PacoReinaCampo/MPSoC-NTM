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

module model_vector_summation #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 64
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input      START,
  output reg READY,
  input      DATA_IN_VECTOR_ENABLE,
  input      DATA_IN_SCALAR_ENABLE,
  output reg DATA_OUT_VECTOR_ENABLE,
  output reg DATA_OUT_SCALAR_ENABLE,

  // DATA
  input      [CONTROL_SIZE-1:0] SIZE_IN,
  input      [CONTROL_SIZE-1:0] LENGTH_IN,
  input      [   DATA_SIZE-1:0] DATA_IN,
  output reg [   DATA_SIZE-1:0] DATA_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  parameter [1:0] STARTER_STATE = 0;
  parameter [1:0] INPUT_VECTOR_STATE = 1;
  parameter [1:0] INPUT_SCALAR_STATE = 2;
  parameter [1:0] ENDER_STATE = 3;

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
  reg  [             1:0] summation_ctrl_fsm_int;

  // Data Internal
  reg  [CONTROL_SIZE-1:0] index_vector_loop;
  reg  [CONTROL_SIZE-1:0] index_scalar_loop;

  // SCALAR ADDER
  // CONTROL
  reg                     start_scalar_float_adder;
  wire                    ready_scalar_float_adder;
  reg                     data_in_enable_scalar_float_adder;
  wire                    data_out_enable_scalar_float_adder;

  // DATA
  wire [CONTROL_SIZE-1:0] size_in_scalar_float_adder;
  reg  [CONTROL_SIZE-1:0] length_in_scalar_float_adder;
  reg  [   DATA_SIZE-1:0] data_in_scalar_float_adder;
  wire [   DATA_SIZE-1:0] data_out_scalar_float_adder;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if (RST == 1'b0) begin
      // Data Outputs
      DATA_OUT          <= ZERO_DATA;

      // Control Outputs
      READY             <= 1'b0;

      // Assignations
      index_vector_loop <= ZERO_DATA;
      index_scalar_loop <= ZERO_DATA;
    end else begin
      case (summation_ctrl_fsm_int)
        STARTER_STATE: begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if (START == 1'b1) begin
            // Assignations
            index_vector_loop      <= ZERO_DATA;
            index_scalar_loop      <= ZERO_DATA;

            // FSM Control
            summation_ctrl_fsm_int <= INPUT_VECTOR_STATE;
          end
        end
        INPUT_VECTOR_STATE: begin  // STEP 1
          if (DATA_IN_VECTOR_ENABLE == 1'b1) begin
            // Data Inputs
            data_in_scalar_float_adder <= DATA_IN;

            if (index_vector_loop == ZERO_DATA) begin
              // Control Internal
              start_scalar_float_adder <= 1'b1;
            end

            data_in_enable_scalar_float_adder <= 1'b1;

            // FSM Control
            summation_ctrl_fsm_int            <= ENDER_STATE;
          end else begin
            // Control Internal
            data_in_enable_scalar_float_adder <= 1'b0;
          end

          // Control Outputs
          DATA_OUT_VECTOR_ENABLE <= 1'b0;
          DATA_OUT_SCALAR_ENABLE <= 1'b0;
        end
        INPUT_SCALAR_STATE: begin  // STEP 2
          if (DATA_IN_SCALAR_ENABLE == 1'b1) begin
            // Data Inputs
            length_in_scalar_float_adder <= LENGTH_IN;
            data_in_scalar_float_adder   <= DATA_IN;

            if (index_scalar_loop == ZERO_DATA) begin
              // Control Internal
              start_scalar_float_adder <= 1'b1;
            end

            data_in_enable_scalar_float_adder <= 1'b1;

            // FSM Control
            summation_ctrl_fsm_int            <= ENDER_STATE;
          end else begin
            // Control Internal
            data_in_enable_scalar_float_adder <= 1'b0;
          end

          // Control Outputs
          DATA_OUT_SCALAR_ENABLE <= 1'b0;
        end
        ENDER_STATE: begin  // STEP 3
          if (ready_scalar_float_adder == 1'b1) begin
            if (index_vector_loop == (SIZE_IN - ONE_CONTROL) && index_scalar_loop == (LENGTH_IN - ONE_CONTROL)) begin
              // Control Outputs
              READY                  <= 1'b1;
              DATA_OUT_SCALAR_ENABLE <= 1'b1;

              // FSM Control
              summation_ctrl_fsm_int <= STARTER_STATE;
            end else if (index_vector_loop < (SIZE_IN - ONE_CONTROL) && index_scalar_loop == (LENGTH_IN - ONE_CONTROL)) begin
              // Control Internal
              index_vector_loop      <= (index_vector_loop + ONE_CONTROL);
              index_scalar_loop      <= ZERO_DATA;

              // Control Outputs
              DATA_OUT_VECTOR_ENABLE <= 1'b1;
              DATA_OUT_SCALAR_ENABLE <= 1'b1;

              // FSM Control
              summation_ctrl_fsm_int <= INPUT_VECTOR_STATE;
            end else if (index_vector_loop < (SIZE_IN - ONE_CONTROL) && index_scalar_loop < (LENGTH_IN - ONE_CONTROL)) begin
              // Control Internal
              index_scalar_loop      <= (index_scalar_loop + ONE_CONTROL);

              // Control Outputs
              DATA_OUT_SCALAR_ENABLE <= 1'b1;

              // FSM Control
              summation_ctrl_fsm_int <= INPUT_SCALAR_STATE;
            end
            // Data Outputs
            DATA_OUT <= data_out_scalar_float_adder;
          end else begin
            // Control Internal
            start_scalar_float_adder <= 1'b0;
          end
        end
        default: begin
          // FSM Control
          summation_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // SCALAR ADDER
  model_scalar_float_adder #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_float_adder (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START          (start_scalar_float_adder),
    .READY          (ready_scalar_float_adder),
    .DATA_IN_ENABLE (data_in_enable_scalar_float_adder),
    .DATA_OUT_ENABLE(data_out_enable_scalar_float_adder),

    // DATA
    .LENGTH_IN(length_in_scalar_float_adder),
    .DATA_IN  (data_in_scalar_float_adder),
    .DATA_OUT (data_out_scalar_float_adder)
  );

endmodule
