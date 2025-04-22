-----------------------------------------------------------------------------------
--                                            __ _      _     _                  --
--                                           / _(_)    | |   | |                 --
--                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 --
--               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 --
--              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 --
--               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 --
--                  | |                                                          --
--                  |_|                                                          --
--                                                                               --
--                                                                               --
--              Peripheral-NTM for MPSoC                                         --
--              Neural Turing Machine for MPSoC                                  --
--                                                                               --
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
--                                                                               --
-- Copyright (c) 2020-2024 by the author(s)                                      --
--                                                                               --
-- Permission is hereby granted, free of charge, to any person obtaining a copy  --
-- of this software and associated documentation files (the "Software"), to deal --
-- in the Software without restriction, including without limitation the rights  --
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     --
-- copies of the Software, and to permit persons to whom the Software is         --
-- furnished to do so, subject to the following conditions:                      --
--                                                                               --
-- The above copyright notice and this permission notice shall be included in    --
-- all copies or substantial portions of the Software.                           --
--                                                                               --
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    --
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      --
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   --
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        --
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, --
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     --
-- THE SOFTWARE.                                                                 --
--                                                                               --
-- ============================================================================= --
-- Author(s):                                                                    --
--   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           --
--                                                                               --
-----------------------------------------------------------------------------------

with Ada.Text_IO;
use Ada.Text_IO;

with Ada.Numerics;
use Ada.Numerics;

with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;

package body ntm_state_feedback is

  procedure ntm_eye_matrix (
    -- Inputs
    SIZE_I_IN : in integer;
    SIZE_J_IN : in integer;

    -- Outputs
    data_out : out matrix
  ) is
    ZERO : constant float := 0.0;

    ONE : constant float := 1.0;
  begin
    for i in 1 .. SIZE_I_IN loop
      for j in 1 .. SIZE_J_IN loop
        if i = j then
          data_out(i, j) := ONE;
        else
          data_out(i, j) := ZERO;
        end if;
      end loop;
    end loop;

  end ntm_eye_matrix;

  procedure ntm_state_matrix_feedforward (
    -- Inputs
    data_d_in : in matrix;
    data_k_in : in matrix;

    -- Variables
    matrix_operation_int : out matrix;
    matrix_eye_int       : out matrix;

    -- Outputs
    data_d_out : out matrix
  ) is
    -- Constants
    -- SIZE: A[N,N]; B[N,P]; C[Q,N]; D[Q,P];
    -- SIZE: K[P,P]; x[N,1]; y[Q,1]; u[P,1];

    -- [SIZE_D_I_IN, SIZE_D_J_IN] = size(data_d_in);
    SIZE_D_I_IN : integer := data_d_in'Length(1);
    SIZE_D_J_IN : integer := data_d_in'Length(2);

  begin

    ntm_eye_matrix (
      -- Inputs
      SIZE_I_IN => SIZE_D_I_IN,
      SIZE_J_IN => SIZE_D_J_IN,

      -- Outputs
      data_out => matrix_eye_int
    );

    -- Body
    -- d = inv(I + D·K)·D
    ntm_matrix_algebra.ntm_matrix_product (
      -- Inputs
      data_a_in => data_d_in,
      data_b_in => data_k_in,

      -- Outputs
      data_out => matrix_operation_int
    );

    ntm_matrix_arithmetic.ntm_matrix_adder (
      -- Inputs
      data_a_in => matrix_eye_int,
      data_b_in => matrix_operation_int,

      -- Outputs
      data_out => matrix_operation_int
    );

    ntm_matrix_algebra.ntm_matrix_inverse (
      -- Inputs
      data_in => matrix_operation_int,

      -- Outputs
      data_out => matrix_operation_int
    );

    ntm_matrix_algebra.ntm_matrix_product (
      -- Inputs
      data_a_in => matrix_operation_int,
      data_b_in => data_d_in,

      -- Outputs
      data_out => data_d_out
    );

  end ntm_state_matrix_feedforward;

  procedure ntm_state_matrix_input (
    -- Inputs
    data_b_in : in matrix;
    data_d_in : in matrix;
    data_k_in : in matrix;

    -- Variables
    matrix_operation_int : out matrix;
    matrix_eye_int       : out matrix;

    -- Outputs
    data_b_out : out matrix
  ) is
    -- Constants
    -- SIZE: A[N,N]; B[N,P]; C[Q,N]; D[Q,P];
    -- SIZE: K[P,P]; x[N,1]; y[Q,1]; u[P,1];

    -- [SIZE_D_I_IN, SIZE_D_J_IN] = size(data_d_in);
    SIZE_D_I_IN : integer := data_d_in'Length(1);
    SIZE_D_J_IN : integer := data_d_in'Length(2);

  begin

    ntm_eye_matrix (
      -- Inputs
      SIZE_I_IN => SIZE_D_I_IN,
      SIZE_J_IN => SIZE_D_J_IN,

      -- Outputs
      data_out => matrix_eye_int
    );

    -- Body
    -- b = B·(I-K·inv(I + D·K)·D)
    ntm_matrix_algebra.ntm_matrix_product (
      -- Inputs
      data_a_in => data_d_in,
      data_b_in => data_k_in,

      -- Outputs
      data_out => matrix_operation_int
    );

    ntm_matrix_arithmetic.ntm_matrix_adder (
      -- Inputs
      data_a_in => matrix_eye_int,
      data_b_in => matrix_operation_int,

      -- Outputs
      data_out => matrix_operation_int
    );

    ntm_matrix_algebra.ntm_matrix_inverse (
      -- Inputs
      data_in => matrix_operation_int,

      -- Outputs
      data_out => matrix_operation_int
    );

    ntm_matrix_algebra.ntm_matrix_product (
      -- Inputs
      data_a_in => matrix_operation_int,
      data_b_in => data_d_in,

      -- Outputs
      data_out => matrix_operation_int
    );

    ntm_matrix_algebra.ntm_matrix_product (
      -- Inputs
      data_a_in => data_k_in,
      data_b_in => matrix_operation_int,

      -- Outputs
      data_out => matrix_operation_int
    );

    ntm_matrix_substractor (
      -- Inputs
      data_a_in => matrix_eye_int,
      data_b_in => matrix_operation_int,

      -- Outputs
      data_out => matrix_operation_int
    );

    ntm_matrix_algebra.ntm_matrix_product (
      -- Inputs
      data_a_in => data_b_in,
      data_b_in => matrix_operation_int,

      -- Outputs
      data_out => data_b_out
    );

  end ntm_state_matrix_input;

  procedure ntm_state_matrix_output (
    -- Inputs
    data_a_in : in matrix;
    data_b_in : in matrix;
    data_c_in : in matrix;
    data_d_in : in matrix;
    data_k_in : in matrix;

    -- Variables
    matrix_operation_int : out matrix;
    matrix_eye_int       : out matrix;

    -- Outputs
    data_c_out : out matrix
  ) is
    -- Constants
    -- SIZE: A[N,N]; B[N,P]; C[Q,N]; D[Q,P];
    -- SIZE: K[P,P]; x[N,1]; y[Q,1]; u[P,1];

    -- [SIZE_D_I_IN, SIZE_D_J_IN] = size(data_d_in);
    SIZE_D_I_IN : integer := data_d_in'Length(1);
    SIZE_D_J_IN : integer := data_d_in'Length(2);

  begin

    ntm_eye_matrix (
      -- Inputs
      SIZE_I_IN => SIZE_D_I_IN,
      SIZE_J_IN => SIZE_D_J_IN,

      -- Outputs
      data_out => matrix_eye_int
    );

    -- Body
    -- c = inv(I + D·K)·C
    ntm_matrix_algebra.ntm_matrix_product (
      -- Inputs
      data_a_in => data_d_in,
      data_b_in => data_k_in,

      -- Outputs
      data_out => matrix_operation_int
    );

    ntm_matrix_arithmetic.ntm_matrix_adder (
      -- Inputs
      data_a_in => matrix_eye_int,
      data_b_in => matrix_operation_int,

      -- Outputs
      data_out => matrix_operation_int
    );

    ntm_matrix_algebra.ntm_matrix_inverse (
      -- Inputs
      data_in => matrix_operation_int,

      -- Outputs
      data_out => matrix_operation_int
    );

    ntm_matrix_algebra.ntm_matrix_product (
      -- Inputs
      data_a_in => matrix_operation_int,
      data_b_in => data_c_in,

      -- Outputs
      data_out => data_c_out
    );

  end ntm_state_matrix_output;

  procedure ntm_state_matrix_state (
    -- Inputs
    data_a_in : in matrix;
    data_b_in : in matrix;
    data_c_in : in matrix;
    data_d_in : in matrix;
    data_k_in : in matrix;

    -- Variables
    matrix_operation_int : out matrix;
    matrix_eye_int       : out matrix;

    -- Outputs
    data_a_out : out matrix
  ) is
    -- Constants
    -- SIZE: A[N,N]; B[N,P]; C[Q,N]; D[Q,P];
    -- SIZE: K[P,P]; x[N,1]; y[Q,1]; u[P,1];

    -- [SIZE_D_I_IN, SIZE_D_J_IN] = size(data_d_in);
    SIZE_D_I_IN : integer := data_d_in'Length(1);
    SIZE_D_J_IN : integer := data_d_in'Length(2);

  begin

    ntm_eye_matrix (
      -- Inputs
      SIZE_I_IN => SIZE_D_I_IN,
      SIZE_J_IN => SIZE_D_J_IN,

      -- Outputs
      data_out => matrix_eye_int
    );

    -- Body
    -- a = A-B·K·inv(I + D·K)·C
    ntm_matrix_algebra.ntm_matrix_product (
      -- Inputs
      data_a_in => data_d_in,
      data_b_in => data_k_in,

      -- Outputs
      data_out => matrix_operation_int
    );

    ntm_matrix_arithmetic.ntm_matrix_adder (
      -- Inputs
      data_a_in => matrix_eye_int,
      data_b_in => matrix_operation_int,

      -- Outputs
      data_out => matrix_operation_int
    );

    ntm_matrix_algebra.ntm_matrix_inverse (
      -- Inputs
      data_in => matrix_operation_int,

      -- Outputs
      data_out => matrix_operation_int
    );

    ntm_matrix_algebra.ntm_matrix_product (
      -- Inputs
      data_a_in => matrix_operation_int,
      data_b_in => data_c_in,

      -- Outputs
      data_out => matrix_operation_int
    );

    ntm_matrix_algebra.ntm_matrix_product (
      -- Inputs
      data_a_in => data_k_in,
      data_b_in => matrix_operation_int,

      -- Outputs
      data_out => matrix_operation_int
    );

    ntm_matrix_algebra.ntm_matrix_product (
      -- Inputs
      data_a_in => data_b_in,
      data_b_in => matrix_operation_int,

      -- Outputs
      data_out => matrix_operation_int
    );

    ntm_matrix_arithmetic.ntm_matrix_adder (
      -- Inputs
      data_a_in => data_a_in,
      data_b_in => matrix_operation_int,

      -- Outputs
      data_out => data_a_out
    );

  end ntm_state_matrix_state;

end ntm_state_feedback;
