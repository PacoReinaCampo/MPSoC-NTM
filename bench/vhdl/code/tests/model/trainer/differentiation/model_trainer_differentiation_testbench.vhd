--------------------------------------------------------------------------------
--                                            __ _      _     _               --
--                                           / _(_)    | |   | |              --
--                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              --
--               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              --
--              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              --
--               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              --
--                  | |                                                       --
--                  |_|                                                       --
--                                                                            --
--                                                                            --
--              Peripheral-NTM for MPSoC                                      --
--              Neural Turing Machine for MPSoC                               --
--                                                                            --
--------------------------------------------------------------------------------

-- Copyright (c) 2020-2021 by the author(s)
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.model_arithmetic_pkg.all;
use work.model_math_pkg.all;
use work.model_linear_controller_pkg.all;
use work.model_trainer_differentiation_pkg.all;

entity model_trainer_differentiation_testbench is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 4;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

    -- VECTOR-FUNCTIONALITY
    ENABLE_MODEL_VECTOR_TRAINER_DIFFERENTIATION_TEST : boolean := false;

    ENABLE_MODEL_VECTOR_TRAINER_DIFFERENTIATION_CASE_0 : boolean := false;

    ENABLE_MODEL_VECTOR_TRAINER_DIFFERENTIATION_CASE_1 : boolean := false;

    -- MATRIX-FUNCTIONALITY
    ENABLE_MODEL_MATRIX_TRAINER_DIFFERENTIATION_TEST : boolean := false;

    ENABLE_MODEL_MATRIX_TRAINER_DIFFERENTIATION_CASE_0 : boolean := false;

    ENABLE_MODEL_MATRIX_TRAINER_DIFFERENTIATION_CASE_1 : boolean := false
    );
end model_trainer_differentiation_testbench;

architecture model_trainer_differentiation_testbench_architecture of model_trainer_differentiation_testbench is

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- VECTOR TRAINER DIFFERENTIATION
  -- CONTROL
  signal start_vector_trainer_differentiation : std_logic;
  signal ready_vector_trainer_differentiation : std_logic;

  signal x_in_t_enable_vector_trainer_differentiation : std_logic;
  signal x_in_l_enable_vector_trainer_differentiation : std_logic;

  signal x_out_t_enable_vector_trainer_differentiation : std_logic;
  signal x_out_l_enable_vector_trainer_differentiation : std_logic;

  signal y_out_t_enable_vector_trainer_differentiation : std_logic;
  signal y_out_l_enable_vector_trainer_differentiation : std_logic;

  -- DATA
  signal size_t_in_vector_trainer_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_vector_trainer_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal length_in_vector_trainer_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);

  signal x_in_vector_trainer_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);

  signal y_out_vector_trainer_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX TRAINER DIFFERENTIATION
  -- CONTROL
  signal start_matrix_trainer_differentiation : std_logic;
  signal ready_matrix_trainer_differentiation : std_logic;

  signal x_in_t_enable_matrix_trainer_differentiation : std_logic;
  signal x_in_i_enable_matrix_trainer_differentiation : std_logic;
  signal x_in_l_enable_matrix_trainer_differentiation : std_logic;

  signal x_out_t_enable_matrix_trainer_differentiation : std_logic;
  signal x_out_i_enable_matrix_trainer_differentiation : std_logic;
  signal x_out_l_enable_matrix_trainer_differentiation : std_logic;

  signal y_out_t_enable_matrix_trainer_differentiation : std_logic;
  signal y_out_i_enable_matrix_trainer_differentiation : std_logic;
  signal y_out_l_enable_matrix_trainer_differentiation : std_logic;

  -- DATA
  signal size_t_in_matrix_trainer_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_matrix_trainer_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_matrix_trainer_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal length_in_matrix_trainer_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);

  signal x_in_matrix_trainer_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);

  signal y_out_matrix_trainer_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- STIMULUS
  model_trainer_differentiation_stimulus_i : model_trainer_differentiation_stimulus
    generic map (
      -- SYSTEM-SIZE
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE,

      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- VECTOR TRAINER DIFFERENTIATION
      -- CONTROL
      VECTOR_TRAINER_DIFFERENTIATION_START => start_vector_trainer_differentiation,
      VECTOR_TRAINER_DIFFERENTIATION_READY => ready_vector_trainer_differentiation,

      VECTOR_TRAINER_DIFFERENTIATION_X_IN_T_ENABLE => x_in_t_enable_vector_trainer_differentiation,
      VECTOR_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE => x_in_l_enable_vector_trainer_differentiation,

      VECTOR_TRAINER_DIFFERENTIATION_X_OUT_T_ENABLE => x_out_t_enable_vector_trainer_differentiation,
      VECTOR_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE => x_out_l_enable_vector_trainer_differentiation,

      VECTOR_TRAINER_DIFFERENTIATION_Y_OUT_T_ENABLE => y_out_t_enable_vector_trainer_differentiation,
      VECTOR_TRAINER_DIFFERENTIATION_Y_OUT_L_ENABLE => y_out_l_enable_vector_trainer_differentiation,

      -- DATA
      VECTOR_TRAINER_DIFFERENTIATION_SIZE_T_IN => size_t_in_vector_trainer_differentiation,
      VECTOR_TRAINER_DIFFERENTIATION_SIZE_L_IN => size_l_in_vector_trainer_differentiation,

      VECTOR_TRAINER_DIFFERENTIATION_LENGTH_IN => length_in_vector_trainer_differentiation,

      VECTOR_TRAINER_DIFFERENTIATION_X_IN => x_in_vector_trainer_differentiation,

      VECTOR_TRAINER_DIFFERENTIATION_Y_OUT => y_out_vector_trainer_differentiation,

      -- MATRIX TRAINER DIFFERENTIATION
      -- CONTROL
      MATRIX_TRAINER_DIFFERENTIATION_START => start_matrix_trainer_differentiation,
      MATRIX_TRAINER_DIFFERENTIATION_READY => ready_matrix_trainer_differentiation,

      MATRIX_TRAINER_DIFFERENTIATION_X_IN_T_ENABLE => x_in_t_enable_matrix_trainer_differentiation,
      MATRIX_TRAINER_DIFFERENTIATION_X_IN_I_ENABLE => x_in_i_enable_matrix_trainer_differentiation,
      MATRIX_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE => x_in_l_enable_matrix_trainer_differentiation,

      MATRIX_TRAINER_DIFFERENTIATION_X_OUT_T_ENABLE => x_out_t_enable_matrix_trainer_differentiation,
      MATRIX_TRAINER_DIFFERENTIATION_X_OUT_I_ENABLE => x_out_i_enable_matrix_trainer_differentiation,
      MATRIX_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE => x_out_l_enable_matrix_trainer_differentiation,

      MATRIX_TRAINER_DIFFERENTIATION_Y_OUT_T_ENABLE => y_out_t_enable_matrix_trainer_differentiation,
      MATRIX_TRAINER_DIFFERENTIATION_Y_OUT_I_ENABLE => y_out_i_enable_matrix_trainer_differentiation,
      MATRIX_TRAINER_DIFFERENTIATION_Y_OUT_L_ENABLE => y_out_l_enable_matrix_trainer_differentiation,

      -- DATA
      MATRIX_TRAINER_DIFFERENTIATION_SIZE_T_IN => size_t_in_matrix_trainer_differentiation,
      MATRIX_TRAINER_DIFFERENTIATION_SIZE_R_IN => size_r_in_matrix_trainer_differentiation,
      MATRIX_TRAINER_DIFFERENTIATION_SIZE_L_IN => size_l_in_matrix_trainer_differentiation,

      MATRIX_TRAINER_DIFFERENTIATION_LENGTH_IN => length_in_matrix_trainer_differentiation,

      MATRIX_TRAINER_DIFFERENTIATION_X_IN => x_in_matrix_trainer_differentiation,

      MATRIX_TRAINER_DIFFERENTIATION_Y_OUT => y_out_matrix_trainer_differentiation
      );

  -- VECTOR TRAINER DIFFERENTIATION
  model_vector_trainer_differentiation_test : if (ENABLE_MODEL_VECTOR_TRAINER_DIFFERENTIATION_TEST) generate
    vector_controller_differentiation : model_vector_controller_differentiation
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_trainer_differentiation,
        READY => ready_vector_trainer_differentiation,

        X_IN_T_ENABLE => x_in_t_enable_vector_trainer_differentiation,
        X_IN_L_ENABLE => x_in_l_enable_vector_trainer_differentiation,

        X_OUT_T_ENABLE => x_out_t_enable_vector_trainer_differentiation,
        X_OUT_L_ENABLE => x_out_l_enable_vector_trainer_differentiation,

        Y_OUT_T_ENABLE => y_out_t_enable_vector_trainer_differentiation,
        Y_OUT_L_ENABLE => y_out_l_enable_vector_trainer_differentiation,

        -- DATA
        SIZE_T_IN => size_t_in_vector_trainer_differentiation,
        SIZE_L_IN => size_l_in_vector_trainer_differentiation,

        LENGTH_IN => length_in_vector_trainer_differentiation,

        X_IN => x_in_vector_trainer_differentiation,

        Y_OUT => y_out_vector_trainer_differentiation
        );
  end generate model_vector_trainer_differentiation_test;

  -- MATRIX TRAINER DIFFERENTIATION
  model_matrix_trainer_differentiation_test : if (ENABLE_MODEL_MATRIX_TRAINER_DIFFERENTIATION_TEST) generate
    matrix_controller_differentiation : model_matrix_controller_differentiation
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_trainer_differentiation,
        READY => ready_matrix_trainer_differentiation,

        X_IN_T_ENABLE => x_in_t_enable_matrix_trainer_differentiation,
        X_IN_I_ENABLE => x_in_i_enable_matrix_trainer_differentiation,
        X_IN_L_ENABLE => x_in_l_enable_matrix_trainer_differentiation,

        X_OUT_T_ENABLE => x_out_t_enable_matrix_trainer_differentiation,
        X_OUT_I_ENABLE => x_out_i_enable_matrix_trainer_differentiation,
        X_OUT_L_ENABLE => x_out_l_enable_matrix_trainer_differentiation,

        Y_OUT_T_ENABLE => y_out_t_enable_matrix_trainer_differentiation,
        Y_OUT_I_ENABLE => y_out_i_enable_matrix_trainer_differentiation,
        Y_OUT_L_ENABLE => y_out_l_enable_matrix_trainer_differentiation,

        -- DATA
        SIZE_T_IN => size_t_in_matrix_trainer_differentiation,
        SIZE_R_IN => size_r_in_matrix_trainer_differentiation,
        SIZE_L_IN => size_l_in_matrix_trainer_differentiation,

        LENGTH_IN => length_in_matrix_trainer_differentiation,

        X_IN => x_in_matrix_trainer_differentiation,

        Y_OUT => y_out_matrix_trainer_differentiation
        );
  end generate model_matrix_trainer_differentiation_test;

end model_trainer_differentiation_testbench_architecture;
