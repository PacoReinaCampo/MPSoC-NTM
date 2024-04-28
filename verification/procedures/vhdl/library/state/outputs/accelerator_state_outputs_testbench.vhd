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

use work.accelerator_state_vhdl_pkg.all;
use work.accelerator_state_outputs_pkg.all;

entity accelerator_state_outputs_testbench is
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

    -- FUNCTIONALITY
    ENABLE_ACCELERATOR_VECTOR_STATE_TEST   : boolean := false;
    ENABLE_ACCELERATOR_VECTOR_STATE_CASE_0 : boolean := false;
    ENABLE_ACCELERATOR_VECTOR_STATE_CASE_1 : boolean := false;

    ENABLE_ACCELERATOR_VECTOR_OUTPUT_TEST   : boolean := false;
    ENABLE_ACCELERATOR_VECTOR_OUTPUT_CASE_0 : boolean := false;
    ENABLE_ACCELERATOR_VECTOR_OUTPUT_CASE_1 : boolean := false
    );
end accelerator_state_outputs_testbench;

architecture accelerator_state_outputs_testbench_architecture of accelerator_state_outputs_testbench is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  constant EMPTY : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- STATE INTERNAL
  -- CONTROL
  signal start_vector_state : std_logic;
  signal ready_vector_state : std_logic;

  signal data_a_in_i_enable_vector_state : std_logic;
  signal data_a_in_j_enable_vector_state : std_logic;
  signal data_b_in_i_enable_vector_state : std_logic;
  signal data_b_in_j_enable_vector_state : std_logic;
  signal data_c_in_i_enable_vector_state : std_logic;
  signal data_c_in_j_enable_vector_state : std_logic;
  signal data_d_in_i_enable_vector_state : std_logic;
  signal data_d_in_j_enable_vector_state : std_logic;

  signal data_a_i_enable_vector_state : std_logic;
  signal data_a_j_enable_vector_state : std_logic;
  signal data_b_i_enable_vector_state : std_logic;
  signal data_b_j_enable_vector_state : std_logic;
  signal data_c_i_enable_vector_state : std_logic;
  signal data_c_j_enable_vector_state : std_logic;
  signal data_d_i_enable_vector_state : std_logic;
  signal data_d_j_enable_vector_state : std_logic;

  signal data_k_in_i_enable_vector_state : std_logic;
  signal data_k_in_j_enable_vector_state : std_logic;

  signal data_k_i_enable_vector_state : std_logic;
  signal data_k_j_enable_vector_state : std_logic;

  signal data_u_in_enable_vector_state : std_logic;

  signal data_u_enable_vector_state : std_logic;

  signal data_x_out_enable_vector_state : std_logic;

  -- DATA
  signal length_k_in_vector_state : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal size_a_i_in_vector_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_vector_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_vector_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_vector_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_c_in_i_vector_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_c_in_j_vector_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_d_in_i_vector_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_d_in_j_vector_state : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_a_in_vector_state : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_state : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_c_in_vector_state : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_d_in_vector_state : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_k_in_vector_state : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_u_in_vector_state : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_x_out_state_vector_state : std_logic_vector(DATA_SIZE-1 downto 0);

  -- STATE OUTPUT
  -- CONTROL
  signal start_vector_output : std_logic;
  signal ready_vector_output : std_logic;

  signal data_a_in_i_enable_vector_output : std_logic;
  signal data_a_in_j_enable_vector_output : std_logic;
  signal data_b_in_i_enable_vector_output : std_logic;
  signal data_b_in_j_enable_vector_output : std_logic;
  signal data_c_in_i_enable_vector_output : std_logic;
  signal data_c_in_j_enable_vector_output : std_logic;
  signal data_d_in_i_enable_vector_output : std_logic;
  signal data_d_in_j_enable_vector_output : std_logic;

  signal data_a_i_enable_vector_output : std_logic;
  signal data_a_j_enable_vector_output : std_logic;
  signal data_b_i_enable_vector_output : std_logic;
  signal data_b_j_enable_vector_output : std_logic;
  signal data_c_i_enable_vector_output : std_logic;
  signal data_c_j_enable_vector_output : std_logic;
  signal data_d_i_enable_vector_output : std_logic;
  signal data_d_j_enable_vector_output : std_logic;

  signal data_k_in_i_enable_vector_output : std_logic;
  signal data_k_in_j_enable_vector_output : std_logic;

  signal data_k_i_enable_vector_output : std_logic;
  signal data_k_j_enable_vector_output : std_logic;

  signal data_u_in_enable_vector_output : std_logic;

  signal data_u_enable_vector_output : std_logic;

  signal data_y_out_enable_vector_output : std_logic;

  -- DATA
  signal length_k_in_vector_output : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal size_a_in_i_vector_output : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_in_j_vector_output : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_in_i_vector_output : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_in_j_vector_output : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_c_in_i_vector_output : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_c_in_j_vector_output : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_d_in_i_vector_output : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_d_in_j_vector_output : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_a_in_vector_output : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_output : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_c_in_vector_output : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_d_in_vector_output : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_k_in_vector_output : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_u_in_state_vector_output : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_u_state_vector_output : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_y_out_state_vector_output : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- STIMULUS
  state_outputs_stimulus : accelerator_state_outputs_stimulus
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

      -- VECTOR STATE
      -- CONTROL
      ACCELERATOR_VECTOR_STATE_START => start_vector_state,
      ACCELERATOR_VECTOR_STATE_READY => ready_vector_state,

      ACCELERATOR_VECTOR_STATE_DATA_A_IN_I_ENABLE => data_a_in_i_enable_vector_state,
      ACCELERATOR_VECTOR_STATE_DATA_A_IN_J_ENABLE => data_a_in_j_enable_vector_state,
      ACCELERATOR_VECTOR_STATE_DATA_B_IN_I_ENABLE => data_b_in_i_enable_vector_state,
      ACCELERATOR_VECTOR_STATE_DATA_B_IN_J_ENABLE => data_b_in_j_enable_vector_state,
      ACCELERATOR_VECTOR_STATE_DATA_C_IN_I_ENABLE => data_c_in_i_enable_vector_state,
      ACCELERATOR_VECTOR_STATE_DATA_C_IN_J_ENABLE => data_c_in_j_enable_vector_state,
      ACCELERATOR_VECTOR_STATE_DATA_D_IN_I_ENABLE => data_d_in_i_enable_vector_state,
      ACCELERATOR_VECTOR_STATE_DATA_D_IN_J_ENABLE => data_d_in_j_enable_vector_state,

      ACCELERATOR_VECTOR_STATE_DATA_A_I_ENABLE => data_a_i_enable_vector_state,
      ACCELERATOR_VECTOR_STATE_DATA_A_J_ENABLE => data_a_j_enable_vector_state,
      ACCELERATOR_VECTOR_STATE_DATA_B_I_ENABLE => data_b_i_enable_vector_state,
      ACCELERATOR_VECTOR_STATE_DATA_B_J_ENABLE => data_b_j_enable_vector_state,
      ACCELERATOR_VECTOR_STATE_DATA_C_I_ENABLE => data_c_i_enable_vector_state,
      ACCELERATOR_VECTOR_STATE_DATA_C_J_ENABLE => data_c_j_enable_vector_state,
      ACCELERATOR_VECTOR_STATE_DATA_D_I_ENABLE => data_d_i_enable_vector_state,
      ACCELERATOR_VECTOR_STATE_DATA_D_J_ENABLE => data_d_j_enable_vector_state,

      ACCELERATOR_VECTOR_STATE_DATA_K_IN_I_ENABLE => data_k_in_i_enable_vector_state,
      ACCELERATOR_VECTOR_STATE_DATA_K_IN_J_ENABLE => data_k_in_j_enable_vector_state,

      ACCELERATOR_VECTOR_STATE_DATA_K_I_ENABLE => data_k_i_enable_vector_state,
      ACCELERATOR_VECTOR_STATE_DATA_K_J_ENABLE => data_k_j_enable_vector_state,

      ACCELERATOR_VECTOR_STATE_DATA_U_IN_ENABLE => data_u_in_enable_vector_state,

      ACCELERATOR_VECTOR_STATE_DATA_U_ENABLE => data_u_enable_vector_state,

      ACCELERATOR_VECTOR_STATE_DATA_X_OUT_ENABLE => data_x_out_enable_vector_state,

      -- DATA
      ACCELERATOR_VECTOR_STATE_LENGTH_K_IN => length_k_in_vector_state,

      ACCELERATOR_VECTOR_STATE_SIZE_A_I_IN => size_a_i_in_vector_state,
      ACCELERATOR_VECTOR_STATE_SIZE_A_J_IN => size_a_j_in_vector_state,
      ACCELERATOR_VECTOR_STATE_SIZE_B_I_IN => size_b_i_in_vector_state,
      ACCELERATOR_VECTOR_STATE_SIZE_B_J_IN => size_b_j_in_vector_state,
      ACCELERATOR_VECTOR_STATE_SIZE_C_I_IN => size_c_in_i_vector_state,
      ACCELERATOR_VECTOR_STATE_SIZE_C_J_IN => size_c_in_j_vector_state,
      ACCELERATOR_VECTOR_STATE_SIZE_D_I_IN => size_d_in_i_vector_state,
      ACCELERATOR_VECTOR_STATE_SIZE_D_J_IN => size_d_in_j_vector_state,

      ACCELERATOR_VECTOR_STATE_DATA_A_IN => data_a_in_vector_state,
      ACCELERATOR_VECTOR_STATE_DATA_B_IN => data_b_in_vector_state,
      ACCELERATOR_VECTOR_STATE_DATA_C_IN => data_c_in_vector_state,
      ACCELERATOR_VECTOR_STATE_DATA_D_IN => data_d_in_vector_state,

      ACCELERATOR_VECTOR_STATE_DATA_K_IN => data_k_in_vector_state,

      ACCELERATOR_VECTOR_STATE_DATA_U_IN => data_u_in_vector_state,

      ACCELERATOR_VECTOR_STATE_DATA_X_OUT => data_x_out_state_vector_state,

      -- VECTOR OUTPUT
      -- CONTROL
      ACCELERATOR_VECTOR_OUTPUT_START => start_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_READY => ready_vector_output,

      ACCELERATOR_VECTOR_OUTPUT_DATA_A_IN_I_ENABLE => data_a_in_i_enable_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_DATA_A_IN_J_ENABLE => data_a_in_j_enable_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_DATA_B_IN_I_ENABLE => data_b_in_i_enable_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_DATA_B_IN_J_ENABLE => data_b_in_j_enable_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_DATA_C_IN_I_ENABLE => data_c_in_i_enable_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_DATA_C_IN_J_ENABLE => data_c_in_j_enable_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_DATA_D_IN_I_ENABLE => data_d_in_i_enable_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_DATA_D_IN_J_ENABLE => data_d_in_j_enable_vector_output,

      ACCELERATOR_VECTOR_OUTPUT_DATA_A_I_ENABLE => data_a_i_enable_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_DATA_A_J_ENABLE => data_a_j_enable_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_DATA_B_I_ENABLE => data_b_i_enable_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_DATA_B_J_ENABLE => data_b_j_enable_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_DATA_C_I_ENABLE => data_c_i_enable_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_DATA_C_J_ENABLE => data_c_j_enable_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_DATA_D_I_ENABLE => data_d_i_enable_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_DATA_D_J_ENABLE => data_d_j_enable_vector_output,

      ACCELERATOR_VECTOR_OUTPUT_DATA_K_IN_I_ENABLE => data_k_in_i_enable_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_DATA_K_IN_J_ENABLE => data_k_in_j_enable_vector_output,

      ACCELERATOR_VECTOR_OUTPUT_DATA_K_I_ENABLE => data_k_i_enable_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_DATA_K_J_ENABLE => data_k_j_enable_vector_output,

      ACCELERATOR_VECTOR_OUTPUT_DATA_U_IN_ENABLE => data_u_in_enable_vector_output,

      ACCELERATOR_VECTOR_OUTPUT_DATA_U_ENABLE => data_u_enable_vector_output,

      ACCELERATOR_VECTOR_OUTPUT_DATA_Y_OUT_ENABLE => data_y_out_enable_vector_output,

      -- DATA
      ACCELERATOR_VECTOR_OUTPUT_LENGTH_K_IN => length_k_in_vector_output,

      ACCELERATOR_VECTOR_OUTPUT_SIZE_A_I_IN => size_a_in_i_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_SIZE_A_J_IN => size_a_in_j_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_SIZE_B_I_IN => size_b_in_i_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_SIZE_B_J_IN => size_b_in_j_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_SIZE_C_I_IN => size_c_in_i_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_SIZE_C_J_IN => size_c_in_j_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_SIZE_D_I_IN => size_d_in_i_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_SIZE_D_J_IN => size_d_in_j_vector_output,

      ACCELERATOR_VECTOR_OUTPUT_DATA_A_IN => data_a_in_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_DATA_B_IN => data_b_in_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_DATA_C_IN => data_c_in_vector_output,
      ACCELERATOR_VECTOR_OUTPUT_DATA_D_IN => data_d_in_vector_output,

      ACCELERATOR_VECTOR_OUTPUT_DATA_K_IN => data_k_in_vector_output,

      ACCELERATOR_VECTOR_OUTPUT_DATA_U_IN => data_u_in_state_vector_output,

      ACCELERATOR_VECTOR_OUTPUT_DATA_Y_OUT => data_y_out_state_vector_output
      );

  -- VECTOR STATE
  accelerator_state_vector_state_test : if (ENABLE_ACCELERATOR_VECTOR_STATE_TEST) generate
    state_vector_state : accelerator_state_vector_state
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_state,
        READY => ready_vector_state,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_vector_state,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_vector_state,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_vector_state,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_vector_state,
        DATA_C_IN_I_ENABLE => data_c_in_i_enable_vector_state,
        DATA_C_IN_J_ENABLE => data_c_in_j_enable_vector_state,
        DATA_D_IN_I_ENABLE => data_d_in_i_enable_vector_state,
        DATA_D_IN_J_ENABLE => data_d_in_j_enable_vector_state,

        DATA_A_I_ENABLE => data_a_i_enable_vector_state,
        DATA_A_J_ENABLE => data_a_j_enable_vector_state,
        DATA_B_I_ENABLE => data_b_i_enable_vector_state,
        DATA_B_J_ENABLE => data_b_j_enable_vector_state,
        DATA_C_I_ENABLE => data_c_i_enable_vector_state,
        DATA_C_J_ENABLE => data_c_j_enable_vector_state,
        DATA_D_I_ENABLE => data_d_i_enable_vector_state,
        DATA_D_J_ENABLE => data_d_j_enable_vector_state,

        DATA_K_IN_I_ENABLE => data_k_in_i_enable_vector_state,
        DATA_K_IN_J_ENABLE => data_k_in_j_enable_vector_state,

        DATA_K_I_ENABLE => data_k_i_enable_vector_state,
        DATA_K_J_ENABLE => data_k_j_enable_vector_state,

        DATA_U_IN_ENABLE => data_u_in_enable_vector_state,

        DATA_U_ENABLE => data_u_enable_vector_state,

        DATA_X_OUT_ENABLE => data_x_out_enable_vector_state,

        -- DATA
        LENGTH_K_IN => length_k_in_vector_state,

        SIZE_A_I_IN => size_a_i_in_vector_state,
        SIZE_A_J_IN => size_a_j_in_vector_state,
        SIZE_B_I_IN => size_b_i_in_vector_state,
        SIZE_B_J_IN => size_b_j_in_vector_state,
        SIZE_C_I_IN => size_c_in_i_vector_state,
        SIZE_C_J_IN => size_c_in_j_vector_state,
        SIZE_D_I_IN => size_d_in_i_vector_state,
        SIZE_D_J_IN => size_d_in_j_vector_state,

        DATA_A_IN => data_a_in_vector_state,
        DATA_B_IN => data_b_in_vector_state,
        DATA_C_IN => data_c_in_vector_state,
        DATA_D_IN => data_d_in_vector_state,

        DATA_K_IN => data_k_in_vector_state,

        DATA_U_IN => data_u_in_vector_state,

        DATA_X_OUT => data_x_out_state_vector_state
        );
  end generate accelerator_state_vector_state_test;

  -- VECTOR OUTPUT
  accelerator_state_vector_output_test : if (ENABLE_ACCELERATOR_VECTOR_OUTPUT_TEST) generate
    state_vector_output : accelerator_state_vector_output
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_output,
        READY => ready_vector_output,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_vector_output,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_vector_output,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_vector_output,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_vector_output,
        DATA_C_IN_I_ENABLE => data_c_in_i_enable_vector_output,
        DATA_C_IN_J_ENABLE => data_c_in_j_enable_vector_output,
        DATA_D_IN_I_ENABLE => data_d_in_i_enable_vector_output,
        DATA_D_IN_J_ENABLE => data_d_in_j_enable_vector_output,

        DATA_A_I_ENABLE => data_a_i_enable_vector_output,
        DATA_A_J_ENABLE => data_a_j_enable_vector_output,
        DATA_B_I_ENABLE => data_b_i_enable_vector_output,
        DATA_B_J_ENABLE => data_b_j_enable_vector_output,
        DATA_C_I_ENABLE => data_c_i_enable_vector_output,
        DATA_C_J_ENABLE => data_c_j_enable_vector_output,
        DATA_D_I_ENABLE => data_d_i_enable_vector_output,
        DATA_D_J_ENABLE => data_d_j_enable_vector_output,

        DATA_K_IN_I_ENABLE => data_k_in_i_enable_vector_output,
        DATA_K_IN_J_ENABLE => data_k_in_j_enable_vector_output,

        DATA_K_I_ENABLE => data_k_i_enable_vector_output,
        DATA_K_J_ENABLE => data_k_j_enable_vector_output,

        DATA_U_IN_ENABLE => data_u_in_enable_vector_output,

        DATA_U_ENABLE => data_u_enable_vector_output,

        DATA_Y_OUT_ENABLE => data_y_out_enable_vector_output,

        -- DATA
        LENGTH_K_IN => length_k_in_vector_output,

        SIZE_A_I_IN => size_a_in_i_vector_output,
        SIZE_A_J_IN => size_a_in_j_vector_output,
        SIZE_B_I_IN => size_b_in_i_vector_output,
        SIZE_B_J_IN => size_b_in_j_vector_output,
        SIZE_C_I_IN => size_c_in_i_vector_output,
        SIZE_C_J_IN => size_c_in_j_vector_output,
        SIZE_D_I_IN => size_d_in_i_vector_output,
        SIZE_D_J_IN => size_d_in_j_vector_output,

        DATA_A_IN => data_a_in_vector_output,
        DATA_B_IN => data_b_in_vector_output,
        DATA_C_IN => data_c_in_vector_output,
        DATA_D_IN => data_d_in_vector_output,

        DATA_K_IN => data_k_in_vector_output,

        DATA_U_IN => data_u_in_state_vector_output,

        DATA_Y_OUT => data_y_out_state_vector_output
        );
  end generate accelerator_state_vector_output_test;

end accelerator_state_outputs_testbench_architecture;
