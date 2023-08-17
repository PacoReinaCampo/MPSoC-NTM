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

use work.accelerator_arithmetic_pkg.all;
use work.accelerator_math_pkg.all;
use work.accelerator_linear_controller_pkg.all;
use work.accelerator_trainer_differentiation_pkg.all;

entity accelerator_trainer_differentiation_testbench is
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
    ENABLE_ACCELERATOR_TRAINER_VECTOR_DIFFERENTIATION_TEST : boolean := false;

    ENABLE_ACCELERATOR_TRAINER_VECTOR_DIFFERENTIATION_CASE_0 : boolean := false;

    ENABLE_ACCELERATOR_TRAINER_VECTOR_DIFFERENTIATION_CASE_1 : boolean := false;

    -- MATRIX-FUNCTIONALITY
    ENABLE_ACCELERATOR_TRAINER_MATRIX_DIFFERENTIATION_TEST : boolean := false;

    ENABLE_ACCELERATOR_TRAINER_MATRIX_DIFFERENTIATION_CASE_0 : boolean := false;

    ENABLE_ACCELERATOR_TRAINER_MATRIX_DIFFERENTIATION_CASE_1 : boolean := false
    );
end accelerator_trainer_differentiation_testbench;

architecture accelerator_trainer_differentiation_testbench_architecture of accelerator_trainer_differentiation_testbench is

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- TRAINER VECTOR DIFFERENTIATION
  -- CONTROL
  signal start_trainer_vector_differentiation : std_logic;
  signal ready_trainer_vector_differentiation : std_logic;

  signal x_in_t_enable_trainer_vector_differentiation : std_logic;
  signal x_in_l_enable_trainer_vector_differentiation : std_logic;

  signal x_out_t_enable_trainer_vector_differentiation : std_logic;
  signal x_out_l_enable_trainer_vector_differentiation : std_logic;

  signal y_out_t_enable_trainer_vector_differentiation : std_logic;
  signal y_out_l_enable_trainer_vector_differentiation : std_logic;

  -- DATA
  signal size_t_in_trainer_vector_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_trainer_vector_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal length_in_trainer_vector_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);

  signal x_in_trainer_vector_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);

  signal y_out_trainer_vector_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TRAINER MATRIX DIFFERENTIATION
  -- CONTROL
  signal start_trainer_matrix_differentiation : std_logic;
  signal ready_trainer_matrix_differentiation : std_logic;

  signal x_in_t_enable_trainer_matrix_differentiation : std_logic;
  signal x_in_i_enable_trainer_matrix_differentiation : std_logic;
  signal x_in_l_enable_trainer_matrix_differentiation : std_logic;

  signal x_out_t_enable_trainer_matrix_differentiation : std_logic;
  signal x_out_i_enable_trainer_matrix_differentiation : std_logic;
  signal x_out_l_enable_trainer_matrix_differentiation : std_logic;

  signal y_out_t_enable_trainer_matrix_differentiation : std_logic;
  signal y_out_i_enable_trainer_matrix_differentiation : std_logic;
  signal y_out_l_enable_trainer_matrix_differentiation : std_logic;

  -- DATA
  signal size_t_in_trainer_matrix_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_trainer_matrix_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_trainer_matrix_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal length_in_trainer_matrix_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);

  signal x_in_trainer_matrix_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);

  signal y_out_trainer_matrix_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- STIMULUS
  accelerator_trainer_differentiation_stimulus_i : accelerator_trainer_differentiation_stimulus
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

      -- TRAINER VECTOR DIFFERENTIATION
      -- CONTROL
      TRAINER_VECTOR_DIFFERENTIATION_START => start_trainer_vector_differentiation,
      TRAINER_VECTOR_DIFFERENTIATION_READY => ready_trainer_vector_differentiation,

      TRAINER_VECTOR_DIFFERENTIATION_X_IN_T_ENABLE => x_in_t_enable_trainer_vector_differentiation,
      TRAINER_VECTOR_DIFFERENTIATION_X_IN_L_ENABLE => x_in_l_enable_trainer_vector_differentiation,

      TRAINER_VECTOR_DIFFERENTIATION_X_OUT_T_ENABLE => x_out_t_enable_trainer_vector_differentiation,
      TRAINER_VECTOR_DIFFERENTIATION_X_OUT_L_ENABLE => x_out_l_enable_trainer_vector_differentiation,

      TRAINER_VECTOR_DIFFERENTIATION_Y_OUT_T_ENABLE => y_out_t_enable_trainer_vector_differentiation,
      TRAINER_VECTOR_DIFFERENTIATION_Y_OUT_L_ENABLE => y_out_l_enable_trainer_vector_differentiation,

      -- DATA
      TRAINER_VECTOR_DIFFERENTIATION_SIZE_T_IN => size_t_in_trainer_vector_differentiation,
      TRAINER_VECTOR_DIFFERENTIATION_SIZE_L_IN => size_l_in_trainer_vector_differentiation,

      TRAINER_VECTOR_DIFFERENTIATION_LENGTH_IN => length_in_trainer_vector_differentiation,

      TRAINER_VECTOR_DIFFERENTIATION_X_IN => x_in_trainer_vector_differentiation,

      TRAINER_VECTOR_DIFFERENTIATION_Y_OUT => y_out_trainer_vector_differentiation,

      -- TRAINER MATRIX DIFFERENTIATION
      -- CONTROL
      TRAINER_MATRIX_DIFFERENTIATION_START => start_trainer_matrix_differentiation,
      TRAINER_MATRIX_DIFFERENTIATION_READY => ready_trainer_matrix_differentiation,

      TRAINER_MATRIX_DIFFERENTIATION_X_IN_T_ENABLE => x_in_t_enable_trainer_matrix_differentiation,
      TRAINER_MATRIX_DIFFERENTIATION_X_IN_I_ENABLE => x_in_i_enable_trainer_matrix_differentiation,
      TRAINER_MATRIX_DIFFERENTIATION_X_IN_L_ENABLE => x_in_l_enable_trainer_matrix_differentiation,

      TRAINER_MATRIX_DIFFERENTIATION_X_OUT_T_ENABLE => x_out_t_enable_trainer_matrix_differentiation,
      TRAINER_MATRIX_DIFFERENTIATION_X_OUT_I_ENABLE => x_out_i_enable_trainer_matrix_differentiation,
      TRAINER_MATRIX_DIFFERENTIATION_X_OUT_L_ENABLE => x_out_l_enable_trainer_matrix_differentiation,

      TRAINER_MATRIX_DIFFERENTIATION_Y_OUT_T_ENABLE => y_out_t_enable_trainer_matrix_differentiation,
      TRAINER_MATRIX_DIFFERENTIATION_Y_OUT_I_ENABLE => y_out_i_enable_trainer_matrix_differentiation,
      TRAINER_MATRIX_DIFFERENTIATION_Y_OUT_L_ENABLE => y_out_l_enable_trainer_matrix_differentiation,

      -- DATA
      TRAINER_MATRIX_DIFFERENTIATION_SIZE_T_IN => size_t_in_trainer_matrix_differentiation,
      TRAINER_MATRIX_DIFFERENTIATION_SIZE_R_IN => size_r_in_trainer_matrix_differentiation,
      TRAINER_MATRIX_DIFFERENTIATION_SIZE_L_IN => size_l_in_trainer_matrix_differentiation,

      TRAINER_MATRIX_DIFFERENTIATION_LENGTH_IN => length_in_trainer_matrix_differentiation,

      TRAINER_MATRIX_DIFFERENTIATION_X_IN => x_in_trainer_matrix_differentiation,

      TRAINER_MATRIX_DIFFERENTIATION_Y_OUT => y_out_trainer_matrix_differentiation
      );

  -- TRAINER VECTOR DIFFERENTIATION
  accelerator_trainer_vector_differentiation_test : if (ENABLE_ACCELERATOR_TRAINER_VECTOR_DIFFERENTIATION_TEST) generate
    trainer_vector_differentiation : accelerator_trainer_vector_differentiation
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_trainer_vector_differentiation,
        READY => ready_trainer_vector_differentiation,

        X_IN_T_ENABLE => x_in_t_enable_trainer_vector_differentiation,
        X_IN_L_ENABLE => x_in_l_enable_trainer_vector_differentiation,

        X_OUT_T_ENABLE => x_out_t_enable_trainer_vector_differentiation,
        X_OUT_L_ENABLE => x_out_l_enable_trainer_vector_differentiation,

        Y_OUT_T_ENABLE => y_out_t_enable_trainer_vector_differentiation,
        Y_OUT_L_ENABLE => y_out_l_enable_trainer_vector_differentiation,

        -- DATA
        SIZE_T_IN => size_t_in_trainer_vector_differentiation,
        SIZE_L_IN => size_l_in_trainer_vector_differentiation,

        LENGTH_IN => length_in_trainer_vector_differentiation,

        X_IN => x_in_trainer_vector_differentiation,

        Y_OUT => y_out_trainer_vector_differentiation
        );
  end generate accelerator_trainer_vector_differentiation_test;

  -- TRAINER MATRIX DIFFERENTIATION
  accelerator_trainer_matrix_differentiation_test : if (ENABLE_ACCELERATOR_TRAINER_MATRIX_DIFFERENTIATION_TEST) generate
    trainer_matrix_differentiation : accelerator_trainer_matrix_differentiation
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_trainer_matrix_differentiation,
        READY => ready_trainer_matrix_differentiation,

        X_IN_T_ENABLE => x_in_t_enable_trainer_matrix_differentiation,
        X_IN_I_ENABLE => x_in_i_enable_trainer_matrix_differentiation,
        X_IN_L_ENABLE => x_in_l_enable_trainer_matrix_differentiation,

        X_OUT_T_ENABLE => x_out_t_enable_trainer_matrix_differentiation,
        X_OUT_I_ENABLE => x_out_i_enable_trainer_matrix_differentiation,
        X_OUT_L_ENABLE => x_out_l_enable_trainer_matrix_differentiation,

        Y_OUT_T_ENABLE => y_out_t_enable_trainer_matrix_differentiation,
        Y_OUT_I_ENABLE => y_out_i_enable_trainer_matrix_differentiation,
        Y_OUT_L_ENABLE => y_out_l_enable_trainer_matrix_differentiation,

        -- DATA
        SIZE_T_IN => size_t_in_trainer_matrix_differentiation,
        SIZE_R_IN => size_r_in_trainer_matrix_differentiation,
        SIZE_L_IN => size_l_in_trainer_matrix_differentiation,

        LENGTH_IN => length_in_trainer_matrix_differentiation,

        X_IN => x_in_trainer_matrix_differentiation,

        Y_OUT => y_out_trainer_matrix_differentiation
        );
  end generate accelerator_trainer_matrix_differentiation_test;

end accelerator_trainer_differentiation_testbench_architecture;
