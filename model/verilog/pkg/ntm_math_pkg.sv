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

package ntm_math_pkg;

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  parameter DATA_SIZE=64;
  parameter CONTROL_SIZE=64;

  parameter ZERO_CONTROL=0;
  parameter ONE_CONTROL=1;
  parameter TWO_CONTROL=2;
  parameter THREE_CONTROL=3;

  parameter ZERO_DATA=0.0;
  parameter ONE_DATA=1.0;
  parameter TWO_DATA=2.0;
  parameter THREE_DATA=3.0;

  parameter LENGTH_IN=0.001;

  ///////////////////////////////////////////////////////////////////////
  // Functions
  ///////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////
  // MATH - SERIES
  ///////////////////////////////////////////////////////////////////////

  // SCALAR
  function [DATA_SIZE-1:0] function_scalar_cosh;
    input [DATA_SIZE-1:0] scalar_input;

    begin
      function_scalar_cosh = $cosh(scalar_input);
    end
  endfunction

  function [DATA_SIZE-1:0] function_scalar_exponentiator;
    input [DATA_SIZE-1:0] scalar_input;

    begin
      function_scalar_exponentiator = $exp(scalar_input);
    end
  endfunction

  function [DATA_SIZE-1:0] function_scalar_logarithm;
    input [DATA_SIZE-1:0] scalar_input;

    begin
      function_scalar_logarithm = $ln(scalar_input);
    end
  endfunction

  function [DATA_SIZE-1:0] function_scalar_sinh;
    input [DATA_SIZE-1:0] scalar_input;

    begin
      function_scalar_sinh = $sinh(scalar_input);
    end
  endfunction

  function [DATA_SIZE-1:0] function_scalar_tanh;
    input [DATA_SIZE-1:0] scalar_input;

    begin
      function_scalar_tanh = $tanh(scalar_input);
    end
  endfunction

  // VECTOR
  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_vector_cosh;
    input [DATA_SIZE-1:0] SIZE_IN;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_input;

    reg [CONTROL_SIZE-1:0] i;

    begin
      for(i = 0; i < SIZE_IN; i = i + 1) begin
        function_vector_cosh[i] = $cosh(vector_input[i]);
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_vector_exponentiator;
    input [DATA_SIZE-1:0] SIZE_IN;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_input;

    reg [CONTROL_SIZE-1:0] i;

    begin
      for(i = 0; i < SIZE_IN; i = i + 1) begin
        function_vector_exponentiator[i] = $exp(vector_input[i]);
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_vector_logarithm;
    input [DATA_SIZE-1:0] SIZE_IN;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_input;

    reg [CONTROL_SIZE-1:0] i;

    begin
      for(i = 0; i < SIZE_IN; i = i + 1) begin
        function_vector_logarithm[i] = $ln(vector_input[i]);
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_vector_sinh;
    input [DATA_SIZE-1:0] SIZE_IN;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_input;

    reg [CONTROL_SIZE-1:0] i;

    begin
      for(i = 0; i < SIZE_IN; i = i + 1) begin
        function_vector_sinh[i] = $sinh(vector_input[i]);
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_vector_tanh;
    input [DATA_SIZE-1:0] SIZE_IN;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_input;

    reg [CONTROL_SIZE-1:0] i;

    begin
      for(i = 0; i < SIZE_IN; i = i + 1) begin
        function_vector_tanh[i] = $tanh(vector_input[i]);
      end
    end
  endfunction

  // MATRIX
  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_matrix_cosh;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          function_matrix_cosh[i][j] = $cosh(matrix_input[i][j]);
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_matrix_exponentiator;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          function_matrix_exponentiator[i][j] = $exp(matrix_input[i][j]);
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_matrix_logarithm;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          function_matrix_logarithm[i][j] = $ln(matrix_input[i][j]);
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_matrix_sinh;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          function_matrix_sinh[i][j] = $sinh(matrix_input[i][j]);
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_matrix_tanh;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          function_matrix_tanh[i][j] = $tanh(matrix_input[i][j]);
        end
      end
    end
  endfunction

  ///////////////////////////////////////////////////////////////////////
  // MATH - FUNCTION
  ///////////////////////////////////////////////////////////////////////

  // SCALAR
  function [DATA_SIZE-1:0] function_scalar_logistic;
    input [DATA_SIZE-1:0] scalar_input;

    begin
      function_scalar_logistic = 1.0/(1.0+1.0/$exp(scalar_input));
    end
  endfunction

  function [DATA_SIZE-1:0] function_scalar_oneplus;
    input [DATA_SIZE-1:0] scalar_input;

    begin
      function_scalar_oneplus = 1.0+$ln(1.0+$exp(scalar_input));
    end
  endfunction

  // VECTOR
  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_vector_logistic;
    input [DATA_SIZE-1:0] SIZE_IN;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_input;

    reg [CONTROL_SIZE-1:0] i;

    begin
      for(i = 0; i < SIZE_IN; i = i + 1) begin
        function_vector_logistic[i] = 1.0/(1.0+1.0/$exp(vector_input[i]));
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_vector_oneplus;
    input [DATA_SIZE-1:0] SIZE_IN;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_input;

    reg [CONTROL_SIZE-1:0] i;

    begin
      for(i = 0; i < SIZE_IN; i = i + 1) begin
        function_vector_oneplus[i] = 1.0+$ln(1.0+$exp(vector_input[i]));
      end
    end
  endfunction

  // MATRIX
  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_matrix_logistic;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          function_matrix_logistic[i][j] = 1.0/(1.0+1.0/$exp(matrix_input[i][j]));
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_matrix_oneplus;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          function_matrix_oneplus[i][j] = 1.0+$ln(1.0+$exp(matrix_input[i][j]));
        end
      end
    end
  endfunction

endpackage