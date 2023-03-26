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

use work.model_math_pkg.all;
use work.model_dnc_core_pkg.all;
use work.model_read_heads_pkg.all;

entity model_read_heads_testbench is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 64;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

    -- FUNCTIONALITY
    ENABLE_DNC_READ_HEADS_TEST   : boolean := false;
    ENABLE_DNC_READ_HEADS_CASE_0 : boolean := false;
    ENABLE_DNC_READ_HEADS_CASE_1 : boolean := false
    );
end model_read_heads_testbench;

architecture model_read_heads_testbench_architecture of model_read_heads_testbench is

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- READ HEADS
  -- CONTROL
  signal start_read_heads : std_logic;
  signal ready_read_heads : std_logic;

  signal rho_in_i_enable_read_heads : std_logic;
  signal rho_in_m_enable_read_heads : std_logic;

  signal rho_out_i_enable_read_heads : std_logic;
  signal rho_out_m_enable_read_heads : std_logic;

  signal k_out_i_enable_read_heads : std_logic;
  signal k_out_k_enable_read_heads : std_logic;

  signal beta_out_enable_read_heads : std_logic;

  signal f_out_enable_read_heads : std_logic;

  signal pi_out_i_enable_read_heads : std_logic;
  signal pi_out_p_enable_read_heads : std_logic;

  -- DATA
  signal size_m_in_read_heads : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_read_heads : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_read_heads : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal rho_in_read_heads : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_out_read_heads    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_out_read_heads : std_logic_vector(DATA_SIZE-1 downto 0);
  signal f_out_read_heads    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal pi_out_read_heads   : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- STIMULUS
  read_heads_stimulus : model_read_heads_stimulus
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

      -- READ HEADS
      -- CONTROL
      DNC_READ_HEADS_START => start_read_heads,
      DNC_READ_HEADS_READY => ready_read_heads,

      DNC_READ_HEADS_RHO_IN_I_ENABLE => rho_in_i_enable_read_heads,
      DNC_READ_HEADS_RHO_IN_M_ENABLE => rho_in_m_enable_read_heads,

      DNC_READ_HEADS_RHO_OUT_I_ENABLE => rho_out_i_enable_read_heads,
      DNC_READ_HEADS_RHO_OUT_M_ENABLE => rho_out_m_enable_read_heads,

      DNC_READ_HEADS_K_OUT_I_ENABLE => k_out_i_enable_read_heads,
      DNC_READ_HEADS_K_OUT_K_ENABLE => k_out_k_enable_read_heads,

      DNC_READ_HEADS_BETA_OUT_ENABLE => beta_out_enable_read_heads,

      DNC_READ_HEADS_F_OUT_ENABLE => f_out_enable_read_heads,

      DNC_READ_HEADS_PI_OUT_I_ENABLE => pi_out_i_enable_read_heads,
      DNC_READ_HEADS_PI_OUT_P_ENABLE => pi_out_p_enable_read_heads,

      -- DATA
      DNC_READ_HEADS_SIZE_M_IN => size_m_in_read_heads,
      DNC_READ_HEADS_SIZE_R_IN => size_r_in_read_heads,
      DNC_READ_HEADS_SIZE_W_IN => size_w_in_read_heads,

      DNC_READ_HEADS_RHO_IN => rho_in_read_heads,

      DNC_READ_HEADS_K_OUT    => k_out_read_heads,
      DNC_READ_HEADS_BETA_OUT => beta_out_read_heads,
      DNC_READ_HEADS_F_OUT    => f_out_read_heads,
      DNC_READ_HEADS_PI_OUT   => pi_out_read_heads
      );

  -- READ HEADS
  model_read_heads_test : if (ENABLE_DNC_READ_HEADS_TEST) generate
    read_heads : model_read_heads
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_read_heads,
        READY => ready_read_heads,

        RHO_IN_I_ENABLE => rho_in_i_enable_read_heads,
        RHO_IN_M_ENABLE => rho_in_m_enable_read_heads,

        RHO_OUT_I_ENABLE => rho_out_i_enable_read_heads,
        RHO_OUT_M_ENABLE => rho_out_m_enable_read_heads,

        K_OUT_I_ENABLE => k_out_i_enable_read_heads,
        K_OUT_K_ENABLE => k_out_k_enable_read_heads,

        BETA_OUT_ENABLE => beta_out_enable_read_heads,

        F_OUT_ENABLE => f_out_enable_read_heads,

        PI_OUT_I_ENABLE => pi_out_i_enable_read_heads,
        PI_OUT_P_ENABLE => pi_out_p_enable_read_heads,

        -- DATA
        SIZE_M_IN => size_m_in_read_heads,
        SIZE_R_IN => size_r_in_read_heads,
        SIZE_W_IN => size_w_in_read_heads,

        RHO_IN => rho_in_read_heads,

        K_OUT    => k_out_read_heads,
        BETA_OUT => beta_out_read_heads,
        F_OUT    => f_out_read_heads,
        PI_OUT   => pi_out_read_heads
        );
  end generate model_read_heads_test;

end model_read_heads_testbench_architecture;
