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
-- Author(s):
--   Paco Reina Campo <pacoreinacampo@queenfield.tech>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity accelerator_mpsoc is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 64;

    -- FUNCTIONALITY
    ENABLE_ACCELERATOR_TOP : boolean := false
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic
    );
end entity;

architecture accelerator_mpsoc_architecture of accelerator_mpsoc is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine

  -- TOP
  -- CONTROL
  signal start_top : std_logic;
  signal ready_top : std_logic;

  signal w_in_l_enable_top : std_logic;
  signal w_in_x_enable_top : std_logic;

  signal w_out_l_enable_top : std_logic;
  signal w_out_x_enable_top : std_logic;

  signal k_in_i_enable_top : std_logic;
  signal k_in_l_enable_top : std_logic;
  signal k_in_k_enable_top : std_logic;

  signal k_out_i_enable_top : std_logic;
  signal k_out_l_enable_top : std_logic;
  signal k_out_k_enable_top : std_logic;

  signal u_in_l_enable_top : std_logic;
  signal u_in_p_enable_top : std_logic;

  signal u_out_l_enable_top : std_logic;
  signal u_out_p_enable_top : std_logic;

  signal v_in_l_enable_top : std_logic;
  signal v_in_s_enable_top : std_logic;

  signal v_out_l_enable_top : std_logic;
  signal v_out_s_enable_top : std_logic;

  signal d_in_i_enable_top : std_logic;
  signal d_in_l_enable_top : std_logic;
  signal d_in_m_enable_top : std_logic;

  signal d_out_i_enable_top : std_logic;
  signal d_out_l_enable_top : std_logic;
  signal d_out_m_enable_top : std_logic;

  signal b_in_enable_top : std_logic;

  signal b_out_enable_top : std_logic;

  signal x_in_enable_top : std_logic;

  signal x_out_enable_top : std_logic;

  signal p_in_i_enable_top : std_logic;
  signal p_in_y_enable_top : std_logic;
  signal p_in_l_enable_top : std_logic;

  signal p_out_i_enable_top : std_logic;
  signal p_out_y_enable_top : std_logic;
  signal p_out_k_enable_top : std_logic;

  signal q_in_y_enable_top : std_logic;
  signal q_in_l_enable_top : std_logic;

  signal q_out_y_enable_top : std_logic;
  signal q_out_l_enable_top : std_logic;

  signal y_out_enable_top : std_logic;

  -- DATA
  signal size_x_in_top : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_y_in_top : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_n_in_top : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_top : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_top : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_top : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal w_in_top : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_in_top : std_logic_vector(DATA_SIZE-1 downto 0);
  signal u_in_top : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_in_top : std_logic_vector(DATA_SIZE-1 downto 0);
  signal d_in_top : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_in_top : std_logic_vector(DATA_SIZE-1 downto 0);

  signal x_in_top : std_logic_vector(DATA_SIZE-1 downto 0);

  signal p_in_top : std_logic_vector(DATA_SIZE-1 downto 0);
  signal q_in_top : std_logic_vector(DATA_SIZE-1 downto 0);

  signal y_out_top : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- INPUT

  -- TOP
  accelerator_top_i : if (ENABLE_ACCELERATOR_TOP) generate
    top : accelerator_top
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_top,
        READY => ready_top,

        W_IN_L_ENABLE => w_in_l_enable_top,
        W_IN_X_ENABLE => w_in_x_enable_top,

        W_OUT_L_ENABLE => w_out_l_enable_top,
        W_OUT_X_ENABLE => w_out_x_enable_top,

        K_IN_I_ENABLE => k_in_i_enable_top,
        K_IN_L_ENABLE => k_in_l_enable_top,
        K_IN_K_ENABLE => k_in_k_enable_top,

        K_OUT_I_ENABLE => k_out_i_enable_top,
        K_OUT_L_ENABLE => k_out_l_enable_top,
        K_OUT_K_ENABLE => k_out_k_enable_top,

        U_IN_L_ENABLE => u_in_l_enable_top,
        U_IN_P_ENABLE => u_in_p_enable_top,

        U_OUT_L_ENABLE => u_out_l_enable_top,
        U_OUT_P_ENABLE => u_out_p_enable_top,

        V_IN_L_ENABLE => v_in_l_enable_top,
        V_IN_S_ENABLE => v_in_s_enable_top,

        V_OUT_L_ENABLE => v_out_l_enable_top,
        V_OUT_S_ENABLE => v_out_s_enable_top,

        D_IN_I_ENABLE => d_in_i_enable_top,
        D_IN_L_ENABLE => d_in_l_enable_top,
        D_IN_M_ENABLE => d_in_m_enable_top,

        D_OUT_I_ENABLE => d_out_i_enable_top,
        D_OUT_L_ENABLE => d_out_l_enable_top,
        D_OUT_M_ENABLE => d_out_m_enable_top,

        B_IN_ENABLE => b_in_enable_top,

        B_OUT_ENABLE => b_out_enable_top,

        X_IN_ENABLE => x_in_enable_top,

        X_OUT_ENABLE => x_out_enable_top,

        P_IN_I_ENABLE => p_in_i_enable_top,
        P_IN_Y_ENABLE => p_in_y_enable_top,
        P_IN_K_ENABLE => p_in_l_enable_top,

        P_OUT_I_ENABLE => p_out_i_enable_top,
        P_OUT_Y_ENABLE => p_out_y_enable_top,
        P_OUT_K_ENABLE => p_out_k_enable_top,

        Q_IN_Y_ENABLE => q_in_y_enable_top,
        Q_IN_L_ENABLE => q_in_l_enable_top,

        Q_OUT_Y_ENABLE => q_out_y_enable_top,
        Q_OUT_L_ENABLE => q_out_l_enable_top,

        Y_OUT_ENABLE => y_out_enable_top,

        -- DATA
        SIZE_X_IN => size_x_in_top,
        SIZE_Y_IN => size_y_in_top,
        SIZE_N_IN => size_n_in_top,
        SIZE_W_IN => size_w_in_top,
        SIZE_L_IN => size_l_in_top,
        SIZE_R_IN => size_r_in_top,

        W_IN => w_in_top,
        K_IN => k_in_top,
        U_IN => u_in_top,
        V_IN => v_in_top,
        D_IN => d_in_top,
        B_IN => b_in_top,

        X_IN => x_in_top,

        P_IN => p_in_top,
        Q_IN => q_in_top,

        Y_OUT => y_out_top
        );
  end generate accelerator_top_i;

end architecture;
