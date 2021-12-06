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

module ntm_content_based_addressing #(
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

    input K_IN_ENABLE,  // for j in 0 to J-1

    output reg K_OUT_ENABLE,  // for j in 0 to J-1

    input M_IN_I_ENABLE,  // for i in 0 to I-1
    input M_IN_J_ENABLE,  // for j in 0 to J-1

    output reg M_OUT_I_ENABLE,  // for i in 0 to I-1
    output reg M_OUT_J_ENABLE,  // for j in 0 to J-1

    output reg C_OUT_ENABLE,  // for i in 0 to I-1

    // DATA
    input [DATA_SIZE-1:0] SIZE_I_IN,
    input [DATA_SIZE-1:0] SIZE_J_IN,

    input [DATA_SIZE-1:0] K_IN,
    input [DATA_SIZE-1:0] BETA_IN,
    input [DATA_SIZE-1:0] M_IN,

    output reg [DATA_SIZE-1:0] C_OUT
  );

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  parameter [2:0] STARTER_STATE = 0;
  parameter [2:0] VECTOR_COSINE_SIMILARITY_STATE = 1;
  parameter [2:0] VECTOR_EXPONENTIATOR_STATE = 2;
  parameter [2:0] VECTOR_SOFTMAX_STATE = 3;

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
  reg [2:0] controller_ctrl_fsm_int;

  // VECTOR MULTIPLIER
  // CONTROL
  wire start_vector_multiplier;
  wire ready_vector_multiplier;

  wire data_a_in_enable_vector_multiplier;
  wire data_b_in_enable_vector_multiplier;
  wire data_out_enable_vector_multiplier;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_multiplier;
  wire [DATA_SIZE-1:0] size_in_vector_multiplier;
  wire [DATA_SIZE-1:0] data_a_in_vector_multiplier;
  wire [DATA_SIZE-1:0] data_b_in_vector_multiplier;
  wire [DATA_SIZE-1:0] data_out_vector_multiplier;

  // VECTOR EXPONENTIATOR
  // CONTROL
  wire start_vector_exponentiator;
  wire ready_vector_exponentiator;

  wire data_a_in_enable_vector_exponentiator;
  wire data_b_in_enable_vector_exponentiator;
  wire data_out_enable_vector_exponentiator;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_exponentiator;
  wire [DATA_SIZE-1:0] size_in_vector_exponentiator;
  wire [DATA_SIZE-1:0] data_a_in_vector_exponentiator;
  wire [DATA_SIZE-1:0] data_b_in_vector_exponentiator;
  wire [DATA_SIZE-1:0] data_out_vector_exponentiator;

  // VECTOR COSINE SIMILARITY
  // CONTROL
  wire start_vector_cosine;
  wire ready_vector_cosine;

  wire data_a_in_vector_enable_vector_cosine;
  wire data_a_in_scalar_enable_vector_cosine;
  wire data_b_in_vector_enable_vector_cosine;
  wire data_b_in_scalar_enable_vector_cosine;
  wire data_out_vector_enable_vector_cosine;
  wire data_out_scalar_enable_vector_cosine;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_cosine;
  wire [DATA_SIZE-1:0] size_in_vector_cosine;
  wire [DATA_SIZE-1:0] length_in_vector_cosine;
  wire [DATA_SIZE-1:0] data_a_in_vector_cosine;
  wire [DATA_SIZE-1:0] data_b_in_vector_cosine;
  wire [DATA_SIZE-1:0] data_out_vector_cosine;

  // VECTOR SOFTMAX
  // CONTROL
  wire start_vector_softmax;
  wire ready_vector_softmax;

  wire data_in_vector_enable_vector_softmax;
  wire data_in_scalar_enable_vector_softmax;
  wire data_out_vector_enable_vector_softmax;
  wire data_out_scalar_enable_vector_softmax;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_softmax;
  wire [DATA_SIZE-1:0] length_in_vector_softmax;
  wire [DATA_SIZE-1:0] size_in_vector_softmax;
  wire [DATA_SIZE-1:0] data_in_vector_softmax;
  wire [DATA_SIZE-1:0] data_out_vector_softmax;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  // C(M,k,beta)[i] = softmax(exponentiation(EULER,cosine(k,M)·beta))[i]

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if(RST == 1'b0) begin
      // Data Outputs
      C_OUT <= ZERO;

      // Control Outputs
      READY <= 1'b0;
    end
    else begin
      case(controller_ctrl_fsm_int)
        STARTER_STATE : begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if(START == 1'b1) begin
            // FSM Control
            controller_ctrl_fsm_int <= VECTOR_COSINE_SIMILARITY_STATE;
          end
        end

        VECTOR_COSINE_SIMILARITY_STATE : begin  // STEP 1
        end

        VECTOR_EXPONENTIATOR_STATE : begin  // STEP 2
        end

        VECTOR_SOFTMAX_STATE : begin  // STEP 3

          // Data Outputs
          C_OUT <= data_out_vector_softmax;
        end
        default : begin
          // FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // DATA
  // VECTOR COSINE SIMILARITY
  assign modulo_in_vector_cosine = FULL;
  assign size_in_vector_cosine   = SIZE_I_IN;
  assign length_in_vector_cosine = SIZE_J_IN;
  assign data_a_in_vector_cosine = K_IN;
  assign data_b_in_vector_cosine = M_IN;

  // VECTOR MULTIPLIER
  assign modulo_in_vector_multiplier = FULL;
  assign size_in_vector_multiplier   = SIZE_I_IN;
  assign data_a_in_vector_multiplier = data_out_vector_cosine;
  assign data_b_in_vector_multiplier = BETA_IN;

  // VECTOR EXPONENTIATOR
  assign modulo_in_vector_exponentiator = FULL;
  assign size_in_vector_exponentiator   = SIZE_I_IN;
  assign data_a_in_vector_exponentiator = FULL;
  assign data_b_in_vector_exponentiator = data_out_vector_multiplier;

  // VECTOR SOFTMAX
  assign modulo_in_vector_softmax = FULL;
  assign size_in_vector_softmax   = SIZE_I_IN;
  assign length_in_vector_softmax = SIZE_J_IN;
  assign data_in_vector_softmax   = data_out_vector_exponentiator;

  // VECTOR MULTIPLIER
  ntm_vector_multiplier #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
  vector_multiplier(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_multiplier),
    .READY(ready_vector_multiplier),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_multiplier),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_multiplier),
    .DATA_OUT_ENABLE(data_out_enable_vector_multiplier),

    // DATA
    .MODULO_IN(modulo_in_vector_multiplier),
    .SIZE_IN(size_in_vector_multiplier),
    .DATA_A_IN(data_a_in_vector_multiplier),
    .DATA_B_IN(data_b_in_vector_multiplier),
    .DATA_OUT(data_out_vector_multiplier)
  );

  // VECTOR EXPONENTIATOR
  ntm_vector_exponentiator #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
  vector_exponentiator(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_exponentiator),
    .READY(ready_vector_exponentiator),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_exponentiator),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_exponentiator),
    .DATA_OUT_ENABLE(data_out_enable_vector_exponentiator),

    // DATA
    .MODULO_IN(modulo_in_vector_exponentiator),
    .SIZE_IN(size_in_vector_exponentiator),
    .DATA_A_IN(data_a_in_vector_exponentiator),
    .DATA_B_IN(data_b_in_vector_exponentiator),
    .DATA_OUT(data_out_vector_exponentiator)
  );

  // VECTOR COSINE SIMILARITY
  ntm_vector_cosine_similarity_function #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
  vector_cosine_similarity_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_cosine),
    .READY(ready_vector_cosine),

    .DATA_A_IN_VECTOR_ENABLE(data_a_in_vector_enable_vector_cosine),
    .DATA_A_IN_SCALAR_ENABLE(data_a_in_scalar_enable_vector_cosine),
    .DATA_B_IN_VECTOR_ENABLE(data_b_in_vector_enable_vector_cosine),
    .DATA_B_IN_SCALAR_ENABLE(data_b_in_scalar_enable_vector_cosine),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_cosine),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_cosine),

    // DATA
    .MODULO_IN(modulo_in_vector_cosine),
    .SIZE_IN(size_in_vector_cosine),
    .LENGTH_IN(length_in_vector_cosine),
    .DATA_A_IN(data_a_in_vector_cosine),
    .DATA_B_IN(data_b_in_vector_cosine),
    .DATA_OUT(data_out_vector_cosine)
  );

  // VECTOR SOFTMAX
  ntm_vector_softmax_function #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
  vector_softmax_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_softmax),
    .READY(ready_vector_softmax),

    .DATA_IN_VECTOR_ENABLE(data_in_vector_enable_vector_softmax),
    .DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_vector_softmax),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_softmax),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_softmax),

    // DATA
    .MODULO_IN(modulo_in_vector_softmax),
    .SIZE_IN(size_in_vector_softmax),
    .LENGTH_IN(length_in_vector_softmax),
    .DATA_IN(data_in_vector_softmax),
    .DATA_OUT(data_out_vector_softmax)
  );

endmodule
