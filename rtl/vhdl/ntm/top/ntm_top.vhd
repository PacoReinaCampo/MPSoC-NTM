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

use work.ntm_math_pkg.all;
use work.ntm_core_pkg.all;
use work.ntm_lstm_controller_pkg.all;

entity ntm_top is
  generic (
    DATA_SIZE : integer := 512
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    W_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    W_IN_X_ENABLE : in std_logic;       -- for x in 0 to X-1

    K_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    K_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    K_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    B_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    X_IN_ENABLE  : in  std_logic;       -- for x in 0 to X-1
    Y_OUT_ENABLE : out std_logic;       -- for y in 0 to Y-1

    -- DATA
    SIZE_X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_Y_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    X_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
    Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_top_architecture of ntm_top is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- CONTROLLER
  -----------------------------------------------------------------------

  -- CONTROLLER
  -- CONTROL
  signal start_controller : std_logic;
  signal ready_controller : std_logic;

  signal w_in_l_enable_controller : std_logic;
  signal w_in_x_enable_controller : std_logic;

  signal k_in_i_enable_controller : std_logic;
  signal k_in_l_enable_controller : std_logic;
  signal k_in_k_enable_controller : std_logic;

  signal b_in_enable_controller : std_logic;

  signal x_in_enable_controller : std_logic;

  signal r_in_i_enable_controller : std_logic;
  signal r_in_k_enable_controller : std_logic;

  signal h_out_enable_controller : std_logic;

  -- DATA
  signal size_x_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_l_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_r_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
      
  signal w_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);

  signal x_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);

  signal h_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);

  -- CONTROLLER OUTPUT VECTOR
  -- CONTROL
  signal start_controller_output_vector : std_logic;
  signal ready_controller_output_vector : std_logic;

  signal u_in_j_enable_controller_output_vector : std_logic;
  signal u_in_l_enable_controller_output_vector : std_logic;

  signal h_in_enable_controller_output_vector : std_logic;

  signal nu_out_enable_controller_output_vector : std_logic;

  -- DATA
  signal size_y_in_controller_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_l_in_controller_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal u_in_controller_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_controller_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal nu_out_controller_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- OUTPUT VECTOR
  -- CONTROL
  signal start_output_vector : std_logic;
  signal ready_output_vector : std_logic;

  signal k_in_i_enable_output_vector : std_logic;
  signal k_in_y_enable_output_vector : std_logic;
  signal k_in_k_enable_output_vector : std_logic;

  signal r_in_i_enable_output_vector : std_logic;
  signal r_in_k_enable_output_vector : std_logic;

  signal nu_in_enable_output_vector : std_logic;

  signal y_in_enable_output_vector : std_logic;

  -- DATA
  signal size_y_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_l_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_r_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal nu_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal y_out_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- INTERFACE VECTOR
  -- CONTROL
  signal start_interface_vector : std_logic;
  signal ready_interface_vector : std_logic;

  -- Key Vector
  signal wk_in_l_enable_interface_vector : std_logic;
  signal wk_in_k_enable_interface_vector : std_logic;

  signal k_out_enable_interface_vector : std_logic;

  -- Key Strength
  signal wbeta_enable_interface_vector : std_logic;

  -- Interpolation Gate
  signal wg_in_enable_interface_vector : std_logic;

  -- Shift Weighting
  signal ws_in_l_enable_interface_vector : std_logic;
  signal ws_in_j_enable_interface_vector : std_logic;

  signal s_out_enable_interface_vector : std_logic;

  -- Sharpening
  signal wgamma_in_enable_interface_vector : std_logic;

  -- Hidden State
  signal h_in_enable_interface_vector : std_logic;

  -- DATA
  signal size_n_in_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_l_in_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal wk_in_interface_vector     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal wbeta_in_interface_vector  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal wg_in_interface_vector     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal ws_in_interface_vector     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal wgamma_in_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal h_in_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_out_interface_vector     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_out_interface_vector  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal g_out_interface_vector     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal s_out_interface_vector     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gamma_out_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- READ HEADS
  -----------------------------------------------------------------------

  -- CONTROL
  signal start_reading : std_logic;
  signal ready_reading : std_logic;

  signal m_in_enable_reading  : std_logic;
  signal r_out_enable_reading : std_logic;

  -- DATA
  signal size_n_in_reading : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_reading : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_in_reading  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal m_in_reading  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_out_reading : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- WRITE HEADS
  -----------------------------------------------------------------------

  -- WRITING
  -- CONTROL
  signal start_writing : std_logic;
  signal ready_writing : std_logic;

  signal m_in_enable_writing  : std_logic;
  signal a_in_enable_writing  : std_logic;
  signal m_out_enable_writing : std_logic;

  -- DATA
  signal size_n_in_writing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_writing : std_logic_vector(DATA_SIZE-1 downto 0);

  signal m_in_writing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal a_in_writing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_in_writing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal m_out_writing : std_logic_vector(DATA_SIZE-1 downto 0);

  -- ERASING
  -- CONTROL
  signal start_erasing : std_logic;
  signal ready_erasing : std_logic;

  signal m_in_enable_erasing  : std_logic;
  signal e_in_enable_erasing  : std_logic;
  signal m_out_enable_erasing : std_logic;

  -- DATA
  signal size_n_in_erasing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_erasing : std_logic_vector(DATA_SIZE-1 downto 0);

  signal m_in_erasing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal e_in_erasing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_in_erasing : std_logic_vector(DATA_SIZE-1 downto 0);

  signal m_out_erasing : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  -- CONTROL
  signal start_addressing : std_logic;
  signal ready_addressing : std_logic;

  signal k_in_enable_addressing : std_logic;
  signal s_in_enable_addressing : std_logic;

  signal m_in_j_enable_addressing : std_logic;
  signal m_in_k_enable_addressing : std_logic;

  signal w_in_enable_addressing  : std_logic;
  signal w_out_enable_addressing : std_logic;

  -- DATA
  signal size_n_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_in_addressing     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_in_addressing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal g_in_addressing     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal s_in_addressing     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gamma_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

  signal m_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_in_addressing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_out_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- CONTROLLER
  -----------------------------------------------------------------------

  ntm_controller_i : ntm_controller
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_controller,
      READY => ready_controller,

      W_IN_L_ENABLE => w_in_l_enable_controller,
      W_IN_X_ENABLE => w_in_x_enable_controller,

      K_IN_I_ENABLE => k_in_i_enable_controller,
      K_IN_L_ENABLE => k_in_l_enable_controller,
      K_IN_K_ENABLE => k_in_k_enable_controller,

      B_IN_ENABLE => b_in_enable_controller,

      X_IN_ENABLE => x_in_enable_controller,

      R_IN_I_ENABLE => r_in_i_enable_controller,
      R_IN_K_ENABLE => r_in_k_enable_controller,

      H_OUT_ENABLE => h_out_enable_controller,

      -- DATA
      SIZE_X_IN => size_x_in_controller,
      SIZE_W_IN => size_w_in_controller,
      SIZE_L_IN => size_l_in_controller,
      SIZE_R_IN => size_r_in_controller,

      W_IN => w_in_controller,
      K_IN => k_in_controller,
      B_IN => b_in_controller,

      X_IN => x_in_controller,
      R_IN => r_in_controller,

      H_OUT => h_out_controller
      );

  -- CONTROLLER OUTPUT VECTOR
  controller_output_vector : ntm_controller_output_vector
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_controller_output_vector,
      READY => ready_controller_output_vector,

      U_IN_Y_ENABLE => u_in_j_enable_controller_output_vector,
      U_IN_L_ENABLE => u_in_l_enable_controller_output_vector,

      H_IN_ENABLE => h_in_enable_controller_output_vector,

      NU_ENABLE_OUT => nu_out_enable_controller_output_vector,

      -- DATA
      SIZE_Y_IN => size_y_in_controller_output_vector,
      SIZE_L_IN => size_l_in_controller_output_vector,

      U_IN => u_in_controller_output_vector,
      H_IN => h_in_controller_output_vector,

      NU_OUT => nu_out_controller_output_vector
      );

  -- OUTPUT VECTOR
  output_vector_i : ntm_output_vector
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_output_vector,
      READY => ready_output_vector,

      K_IN_I_ENABLE => k_in_i_enable_output_vector,
      K_IN_Y_ENABLE => k_in_y_enable_output_vector,
      K_IN_K_ENABLE => k_in_k_enable_output_vector,

      R_IN_I_ENABLE => r_in_i_enable_output_vector,
      R_IN_K_ENABLE => r_in_k_enable_output_vector,

      NU_IN_ENABLE => nu_in_enable_output_vector,

      Y_OUT_ENABLE => y_in_enable_output_vector,

      -- DATA
      SIZE_Y_IN => size_y_in_output_vector,
      SIZE_W_IN => size_w_in_output_vector,
      SIZE_L_IN => size_l_in_output_vector,
      SIZE_R_IN => size_r_in_output_vector,

      K_IN => k_in_output_vector,
      R_IN => r_in_output_vector,

      NU_IN => nu_in_output_vector,

      Y_OUT => y_out_output_vector
      );

  -- INTERFACE VECTOR
  ntm_interface_vector_i : ntm_interface_vector
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_interface_vector,
      READY => ready_interface_vector,

      -- Key Vector
      WK_IN_L_ENABLE => wk_in_l_enable_interface_vector,
      WK_IN_K_ENABLE => wk_in_k_enable_interface_vector,

      K_OUT_ENABLE => k_out_enable_interface_vector,

      -- Key Strength
      WBETA_IN_ENABLE => wbeta_enable_interface_vector,

      -- Interpolation Gate
      WG_IN_ENABLE => wg_in_enable_interface_vector,

      -- Shift Weighting
      WS_IN_L_ENABLE => ws_in_l_enable_interface_vector,
      WS_IN_J_ENABLE => ws_in_j_enable_interface_vector,

      S_OUT_ENABLE => s_out_enable_interface_vector,

      -- Sharpening
      WGAMMA_IN_ENABLE => wgamma_in_enable_interface_vector,

      -- Hidden State
      H_IN_ENABLE => h_in_enable_interface_vector,

      -- DATA
      SIZE_N_IN => size_n_in_interface_vector,
      SIZE_W_IN => size_w_in_interface_vector,
      SIZE_L_IN => size_l_in_interface_vector,

      WK_IN     => wk_in_interface_vector,
      WBETA_IN  => wbeta_in_interface_vector,
      WG_IN     => wg_in_interface_vector,
      WS_IN     => ws_in_interface_vector,
      WGAMMA_IN => wgamma_in_interface_vector,

      H_IN => h_in_interface_vector,

      K_OUT     => k_out_interface_vector,
      BETA_OUT  => beta_out_interface_vector,
      G_OUT     => g_out_interface_vector,
      S_OUT     => s_out_interface_vector,
      GAMMA_OUT => gamma_out_interface_vector
      );

  -----------------------------------------------------------------------
  -- READ HEADS
  -----------------------------------------------------------------------

  reading : ntm_reading
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      M_IN_ENABLE  => m_in_enable_reading,
      R_OUT_ENABLE => r_out_enable_reading,

      -- CONTROL
      START => start_reading,
      READY => ready_reading,

      -- DATA
      SIZE_N_IN => size_n_in_reading,
      SIZE_W_IN => size_w_in_reading,

      W_IN  => w_in_reading,
      M_IN  => m_in_reading,
      R_OUT => r_out_reading
      );

  -----------------------------------------------------------------------
  -- WRITE HEADS
  -----------------------------------------------------------------------

  writing : ntm_writing
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_writing,
      READY => ready_writing,

      M_IN_ENABLE  => m_in_enable_writing,
      A_IN_ENABLE  => a_in_enable_writing,
      M_OUT_ENABLE => m_out_enable_writing,

      -- DATA
      SIZE_N_IN => size_n_in_writing,
      SIZE_W_IN => size_w_in_writing,

      M_IN  => m_in_writing,
      A_IN  => a_in_writing,
      W_IN  => w_in_writing,
      M_OUT => m_out_writing
      );

  erasing : ntm_erasing
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_erasing,
      READY => ready_erasing,

      M_IN_ENABLE  => m_in_enable_erasing,
      E_IN_ENABLE  => e_in_enable_erasing,
      M_OUT_ENABLE => m_out_enable_erasing,

      -- DATA
      SIZE_N_IN => size_n_in_erasing,
      SIZE_W_IN => size_w_in_erasing,

      M_IN => m_in_erasing,
      E_IN => e_in_erasing,
      W_IN => w_in_erasing,

      M_OUT => m_out_erasing
      );

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  ntm_addressing_i : ntm_addressing
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_addressing,
      READY => ready_addressing,

      K_IN_ENABLE => k_in_enable_addressing,
      S_IN_ENABLE => s_in_enable_addressing,

      M_IN_J_ENABLE => m_in_j_enable_addressing,
      M_IN_K_ENABLE => m_in_k_enable_addressing,

      W_IN_ENABLE  => w_in_enable_addressing,
      W_OUT_ENABLE => w_out_enable_addressing,

      -- DATA
      SIZE_N_IN => size_n_in_addressing,
      SIZE_W_IN => size_w_in_addressing,

      K_IN     => k_in_addressing,
      BETA_IN  => beta_in_addressing,
      G_IN     => g_in_addressing,
      S_IN     => s_in_addressing,
      GAMMA_IN => gamma_in_addressing,

      M_IN => m_in_addressing,

      W_IN  => w_in_addressing,
      W_OUT => w_out_addressing
      );

end architecture;
