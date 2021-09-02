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
use work.dnc_core_pkg.all;
use work.ntm_lstm_controller_pkg.all;

entity dnc_top is
  generic (
    X : integer := 64;
    Y : integer := 64;
    N : integer := 64;
    W : integer := 64;
    L : integer := 64;
    R : integer := 64;

    DATA_SIZE : integer := 512
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    X_IN_ENABLE : in std_logic;         -- for x in 0 to X-1

    Y_OUT_ENABLE : out std_logic;       -- for y in 0 to Y-1

    -- DATA
    X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_top_architecture of dnc_top is

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

  -- CONTROL
  signal start_controller : std_logic;
  signal ready_controller : std_logic;

  signal x_in_enable_controller : std_logic;

  signal r_in_i_enable_controller : std_logic;
  signal r_in_k_enable_controller : std_logic;

  signal h_out_enable_controller : std_logic;

  -- DATA
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
  signal k_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal nu_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal y_out_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- READ HEADS
  -----------------------------------------------------------------------

  -- FREE GATES
  -- CONTROL
  signal f_in_enable_free_gates  : std_logic;
  signal f_out_enable_free_gates : std_logic;

  signal start_free_gates : std_logic;
  signal ready_free_gates : std_logic;

  -- DATA
  signal f_in_free_gates  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal f_out_free_gates : std_logic;

  -- READ KEYS
  -- CONTROL
  signal k_in_i_enable_read_keys : std_logic;
  signal k_in_j_enable_read_keys : std_logic;

  signal k_out_i_enable_read_keys : std_logic;
  signal k_out_j_enable_read_keys : std_logic;

  signal start_read_keys : std_logic;
  signal ready_read_keys : std_logic;

  -- DATA
  signal k_in_read_keys  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_out_read_keys : std_logic_vector(DATA_SIZE-1 downto 0);

  -- READ MODES
  -- CONTROL
  signal pi_in_i_enable_read_modes : std_logic;
  signal pi_in_p_enable_read_modes : std_logic;

  signal pi_out_i_enable_read_modes : std_logic;
  signal pi_out_p_enable_read_modes : std_logic;

  signal start_read_modes : std_logic;
  signal ready_read_modes : std_logic;

  -- DATA
  signal pi_in_read_modes  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal pi_out_read_modes : std_logic_vector(DATA_SIZE-1 downto 0);

  -- READ STRENGTHS
  -- CONTROL
  signal beta_in_enable_read_strengths  : std_logic;
  signal beta_out_enable_read_strengths : std_logic;

  signal start_read_strengths : std_logic;
  signal ready_read_strengths : std_logic;

  -- DATA
  signal beta_in_read_strengths  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_out_read_strengths : std_logic_vector(DATA_SIZE-1 downto 0);

  -- READ INTERFACE VECTOR
  -- CONTROL
  signal start_read_interface_vector : std_logic;
  signal ready_read_interface_vector : std_logic;

  -- Read Key
  signal wk_in_i_enable_read_interface_vector : std_logic;
  signal wk_in_l_enable_read_interface_vector : std_logic;
  signal wk_in_k_enable_read_interface_vector : std_logic;

  signal k_out_i_enable_read_interface_vector : std_logic;
  signal k_out_k_enable_read_interface_vector : std_logic;

  -- Read Strength
  signal wbeta_in_i_enable_read_interface_vector : std_logic;
  signal wbeta_in_l_enable_read_interface_vector : std_logic;

  signal beta_out_enable_read_interface_vector : std_logic;

  -- Free Gate
  signal wf_in_i_enable_read_interface_vector : std_logic;
  signal wf_in_l_enable_read_interface_vector : std_logic;

  signal f_out_enable_read_interface_vector : std_logic;

  -- Read Mode
  signal wpi_in_i_enable_read_interface_vector : std_logic;
  signal wpi_in_l_enable_read_interface_vector : std_logic;
  signal wpi_in_p_enable_read_interface_vector : std_logic;

  signal pi_out_i_enable_read_interface_vector : std_logic;
  signal pi_out_p_enable_read_interface_vector : std_logic;

  -- Hidden State
  signal h_in_enable_read_interface_vector : std_logic;

  -- DATA
  signal wk_in_read_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal wbeta_in_read_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal wf_in_read_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal wpi_in_read_interface_vector   : std_logic_vector(DATA_SIZE-1 downto 0);

  signal h_in_read_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_out_read_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_out_read_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal f_out_read_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal pi_out_read_interface_vector   : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- WRITE HEADS
  -----------------------------------------------------------------------

  -- ALLOCATION GATE
  -- CONTROL
  signal start_allocation_gate : std_logic;
  signal ready_allocation_gate : std_logic;

  -- DATA
  signal ga_in_allocation_gate  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal ga_out_allocation_gate : std_logic;

  -- ERASE VECTOR
  -- CONTROL
  signal start_erase_vector : std_logic;
  signal ready_erase_vector : std_logic;

  signal e_in_enable_erase_vector : std_logic;

  signal e_out_enable_erase_vector : std_logic;

  -- DATA
  signal e_in_erase_vector  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal e_out_erase_vector : std_logic;

  -- WRITE GATE
  -- CONTROL
  signal start_write_gate : std_logic;
  signal ready_write_gate : std_logic;

  -- DATA
  signal gw_in_write_gate  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gw_out_write_gate : std_logic;

  -- WRITE KEY
  -- CONTROL
  signal start_write_key : std_logic;
  signal ready_write_key : std_logic;

  signal k_in_enable_write_key : std_logic;

  signal k_out_enable_write_key : std_logic;

  -- DATA
  signal k_in_write_key  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_out_write_key : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE STRENGHT
  -- CONTROL
  signal start_write_strength : std_logic;
  signal ready_write_strength : std_logic;

  -- DATA
  signal beta_in_write_strength  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_out_write_strength : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE VECTOR
  -- CONTROL
  signal start_write_vector : std_logic;
  signal ready_write_vector : std_logic;

  signal v_in_enable_write_vector : std_logic;

  signal v_out_enable_write_vector : std_logic;

  -- DATA
  signal v_in_write_vector  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_out_write_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE INTERFACE VECTOR
  -- CONTROL
  signal start_write_interface_vector : std_logic;
  signal ready_write_interface_vector : std_logic;

  -- Write Key
  signal wk_in_l_enable_write_interface_vector : std_logic;
  signal wk_in_k_enable_write_interface_vector : std_logic;

  signal k_out_enable_write_interface_vector : std_logic;

  -- Write Strength
  signal wbeta_in_enable_write_interface_vector : std_logic;

  -- Erase Vector
  signal we_in_l_enable_write_interface_vector : std_logic;
  signal we_in_k_enable_write_interface_vector : std_logic;

  signal e_out_enable_write_interface_vector : std_logic;

  -- Write Vector
  signal wv_in_l_enable_write_interface_vector : std_logic;
  signal wv_in_k_enable_write_interface_vector : std_logic;

  signal v_out_enable_write_interface_vector : std_logic;

  -- Allocation Gate
  signal wga_in_enable_write_interface_vector : std_logic;

  -- Write Gate
  signal wgw_in_enable_write_interface_vector : std_logic;

  -- Hidden State
  signal h_in_enable_write_interface_vector : std_logic;

  -- DATA
  signal wk_in_write_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal wbeta_in_write_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal we_in_write_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal wv_in_write_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal wga_in_write_interface_vector   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal wgw_in_write_interface_vector   : std_logic_vector(DATA_SIZE-1 downto 0);

  signal h_in_write_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_out_write_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_out_write_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal e_out_write_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_out_write_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal ga_out_write_interface_vector   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gw_out_write_interface_vector   : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  -- CONTROL
  signal start_addressing : std_logic;
  signal ready_addressing : std_logic;

  signal k_read_in_i_enable_addressing : std_logic;
  signal k_read_in_k_enable_addressing : std_logic;

  signal beta_read_in_enable_addressing : std_logic;

  signal f_read_in_enable_addressing : std_logic;

  signal pi_read_in_i_enable_addressing : std_logic;
  signal pi_read_in_p_enable_addressing : std_logic;

  signal k_write_in_k_enable_addressing : std_logic;
  signal e_write_in_k_enable_addressing : std_logic;
  signal v_write_in_k_enable_addressing : std_logic;

  -- DATA
  signal k_read_in_addressing    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_read_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal f_read_in_addressing    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal pi_read_in_addressing   : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_write_in_addressing    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_write_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal e_write_in_addressing    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_write_in_addressing    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal ga_write_in_addressing   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gw_write_in_addressing   : std_logic_vector(DATA_SIZE-1 downto 0);

  signal r_out_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- CONTROLLER
  -----------------------------------------------------------------------

  ntm_controller_i : ntm_controller
    generic map (
      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R,

      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_controller,
      READY => ready_controller,

      X_IN_ENABLE => x_in_enable_controller,

      R_IN_I_ENABLE => r_in_i_enable_controller,
      R_IN_K_ENABLE => r_in_k_enable_controller,

      H_OUT_ENABLE => h_out_enable_controller,

      -- DATA
      X_IN => x_in_controller,
      R_IN => r_in_controller,

      H_OUT => h_out_controller
      );

  -- CONTROLLER OUTPUT VECTOR
  controller_output_vector : dnc_controller_output_vector
    generic map (
      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R,

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
      U_IN => u_in_controller_output_vector,
      H_IN => h_in_controller_output_vector,

      NU_OUT => nu_out_controller_output_vector
      );

  -- OUTPUT VECTOR
  output_vector_i : dnc_output_vector
    generic map (
      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R,

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
      K_IN => k_in_output_vector,
      R_IN => r_in_output_vector,

      NU_IN => nu_in_output_vector,

      Y_OUT => y_out_output_vector
      );

  -----------------------------------------------------------------------
  -- READ HEADS
  -----------------------------------------------------------------------

  -- FREE GATES
  free_gates : dnc_free_gates
    generic map (
      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R,

      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_free_gates,
      READY => ready_free_gates,

      F_IN_ENABLE => f_in_enable_free_gates,

      F_OUT_ENABLE => f_out_enable_free_gates,

      -- DATA
      F_IN => f_in_free_gates,

      F_OUT => f_out_free_gates
      );

  -- READ KEYS
  read_keys : dnc_read_keys
    generic map (
      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R,

      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_keys,
      READY => ready_read_keys,

      K_IN_I_ENABLE => k_in_i_enable_read_keys,
      K_IN_J_ENABLE => k_in_j_enable_read_keys,

      K_OUT_I_ENABLE => k_out_i_enable_read_keys,
      K_OUT_J_ENABLE => k_out_j_enable_read_keys,

      -- DATA
      K_IN => k_in_read_keys,

      K_OUT => k_out_read_keys
      );

  -- READ MODES
  read_modes : dnc_read_modes
    generic map (
      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R,

      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_modes,
      READY => ready_read_modes,

      PI_IN_I_ENABLE => pi_in_i_enable_read_modes,
      PI_IN_P_ENABLE => pi_in_p_enable_read_modes,

      PI_OUT_I_ENABLE => pi_out_i_enable_read_modes,
      PI_OUT_P_ENABLE => pi_out_p_enable_read_modes,

      -- DATA
      PI_IN => pi_in_read_modes,

      PI_OUT => pi_out_read_modes
      );

  -- READ STRENGTHS
  read_strengths : dnc_read_strengths
    generic map (
      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R,

      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_strengths,
      READY => ready_read_strengths,

      BETA_IN_ENABLE  => beta_in_enable_read_strengths,
      BETA_OUT_ENABLE => beta_out_enable_read_strengths,

      -- DATA
      BETA_IN => beta_in_read_strengths,

      BETA_OUT => beta_out_read_strengths
      );

  -- READ INTERFACE VECTOR
  read_interface_vector : dnc_read_interface_vector
    generic map (
      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,

      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_interface_vector,
      READY => ready_read_interface_vector,

      -- Read Key
      WK_IN_I_ENABLE => wk_in_i_enable_read_interface_vector,
      WK_IN_L_ENABLE => wk_in_l_enable_read_interface_vector,
      WK_IN_K_ENABLE => wk_in_k_enable_read_interface_vector,

      K_OUT_I_ENABLE => k_out_i_enable_read_interface_vector,
      K_OUT_K_ENABLE => k_out_k_enable_read_interface_vector,

      -- Read Strength
      WBETA_IN_I_ENABLE => wbeta_in_i_enable_read_interface_vector,
      WBETA_IN_L_ENABLE => wbeta_in_l_enable_read_interface_vector,

      BETA_OUT_ENABLE => beta_out_enable_read_interface_vector,

      -- Free Gate
      WF_IN_I_ENABLE => wf_in_i_enable_read_interface_vector,
      WF_IN_L_ENABLE => wf_in_l_enable_read_interface_vector,

      F_OUT_ENABLE => f_out_enable_read_interface_vector,

      -- Read Mode
      WPI_IN_I_ENABLE => wpi_in_i_enable_read_interface_vector,
      WPI_IN_L_ENABLE => wpi_in_l_enable_read_interface_vector,
      WPI_IN_P_ENABLE => wpi_in_p_enable_read_interface_vector,

      PI_OUT_I_ENABLE => pi_out_i_enable_read_interface_vector,
      PI_OUT_P_ENABLE => pi_out_p_enable_read_interface_vector,

      -- Hidden State
      H_IN_ENABLE => h_in_enable_read_interface_vector,

      -- DATA
      WK_IN    => wk_in_read_interface_vector,
      WBETA_IN => wbeta_in_read_interface_vector,
      WF_IN    => wf_in_read_interface_vector,
      WPI_IN   => wpi_in_read_interface_vector,

      H_IN => h_in_read_interface_vector,

      K_OUT    => k_out_read_interface_vector,
      BETA_OUT => beta_out_read_interface_vector,
      F_OUT    => f_out_read_interface_vector,
      PI_OUT   => pi_out_read_interface_vector
      );

  -----------------------------------------------------------------------
  -- WRITE HEADS
  -----------------------------------------------------------------------

  -- ALLOCATION GATE
  allocation_gate : dnc_allocation_gate
    generic map (
      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R,

      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_allocation_gate,
      READY => ready_allocation_gate,

      -- DATA
      GA_IN => ga_in_allocation_gate,

      GA_OUT => ga_out_allocation_gate
      );

  -- ERASE VECTOR
  erase_vector : dnc_erase_vector
    generic map (
      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R,

      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_erase_vector,
      READY => ready_erase_vector,

      E_IN_ENABLE => e_in_enable_erase_vector,

      E_OUT_ENABLE => e_out_enable_erase_vector,

      -- DATA
      E_IN => e_in_erase_vector,

      E_OUT => e_out_erase_vector
      );

  -- WRITE GATE
  write_gate : dnc_write_gate
    generic map (
      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R,

      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_gate,
      READY => ready_write_gate,

      -- DATA
      GW_IN => gw_in_write_gate,

      GW_OUT => gw_out_write_gate
      );

  -- WRITE KEY
  write_key : dnc_write_key
    generic map (
      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R,

      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_key,
      READY => ready_write_key,

      K_IN_ENABLE => k_in_enable_write_key,

      K_OUT_ENABLE => k_out_enable_write_key,

      -- DATA
      K_IN => k_in_write_key,

      K_OUT => k_out_write_key
      );

  -- WRITE STRENGTH
  write_strength : dnc_write_strength
    generic map (
      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R,

      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_strength,
      READY => ready_write_strength,

      -- DATA
      BETA_IN => beta_in_write_strength,

      BETA_OUT => beta_out_write_strength
      );

  -- WRITE VECTOR
  write_vector : dnc_write_vector
    generic map (
      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R,

      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_vector,
      READY => ready_write_vector,

      V_IN_ENABLE => v_in_enable_write_vector,

      V_OUT_ENABLE => v_out_enable_write_vector,

      -- DATA
      V_IN => v_in_write_vector,

      V_OUT => v_out_write_vector
      );

  -- WRITE INTERFACE VECTOR
  write_interface_vector : dnc_write_interface_vector
    generic map (
      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R,

      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_interface_vector,
      READY => ready_write_interface_vector,

      -- Write Key
      WK_IN_L_ENABLE => wk_in_l_enable_write_interface_vector,
      WK_IN_K_ENABLE => wk_in_k_enable_write_interface_vector,

      K_OUT_ENABLE => k_out_enable_write_interface_vector,

      -- Write Strength
      WBETA_IN_ENABLE => wbeta_in_enable_write_interface_vector,

      -- Erase Vector
      WE_IN_L_ENABLE => we_in_l_enable_write_interface_vector,
      WE_IN_K_ENABLE => we_in_k_enable_write_interface_vector,

      E_OUT_ENABLE => e_out_enable_write_interface_vector,

      -- Write Vector
      WV_IN_L_ENABLE => wv_in_l_enable_write_interface_vector,
      WV_IN_K_ENABLE => wv_in_k_enable_write_interface_vector,

      V_OUT_ENABLE => v_out_enable_write_interface_vector,

      -- Allocation Gate
      WGA_IN_ENABLE => wga_in_enable_write_interface_vector,

      -- Write Gate
      WGW_IN_ENABLE => wgw_in_enable_write_interface_vector,

      -- Hidden State
      H_IN_ENABLE => h_in_enable_write_interface_vector,

      -- DATA
      WK_IN    => wk_in_write_interface_vector,
      WBETA_IN => wbeta_in_write_interface_vector,
      WE_IN    => we_in_write_interface_vector,
      WV_IN    => wv_in_write_interface_vector,
      WGA_IN   => wga_in_write_interface_vector,
      WGW_IN   => wgw_in_write_interface_vector,

      H_IN => h_in_write_interface_vector,

      K_OUT    => k_out_write_interface_vector,
      BETA_OUT => beta_out_write_interface_vector,
      E_OUT    => e_out_write_interface_vector,
      V_OUT    => v_out_write_interface_vector,
      GA_OUT   => ga_out_write_interface_vector,
      GW_OUT   => gw_out_write_interface_vector
      );

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  addressing : dnc_addressing
    generic map (
      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,

      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_addressing,
      READY => ready_addressing,

      K_READ_IN_I_ENABLE => k_read_in_i_enable_addressing,
      K_READ_IN_K_ENABLE => k_read_in_k_enable_addressing,

      BETA_READ_IN_ENABLE => beta_read_in_enable_addressing,

      F_READ_IN_ENABLE => f_read_in_enable_addressing,

      PI_READ_IN_I_ENABLE => pi_read_in_i_enable_addressing,
      PI_READ_IN_P_ENABLE => pi_read_in_p_enable_addressing,

      K_WRITE_IN_K_ENABLE => k_write_in_k_enable_addressing,
      E_WRITE_IN_K_ENABLE => e_write_in_k_enable_addressing,
      V_WRITE_IN_K_ENABLE => v_write_in_k_enable_addressing,

      -- DATA
      K_READ_IN    => k_read_in_addressing,
      BETA_READ_IN => beta_read_in_addressing,
      F_READ_IN    => f_read_in_addressing,
      PI_READ_IN   => pi_read_in_addressing,

      K_WRITE_IN    => k_write_in_addressing,
      BETA_WRITE_IN => beta_write_in_addressing,
      E_WRITE_IN    => e_write_in_addressing,
      V_WRITE_IN    => v_write_in_addressing,
      GA_WRITE_IN   => ga_write_in_addressing,
      GW_WRITE_IN   => gw_write_in_addressing,

      R_OUT => r_out_addressing
      );

end architecture;
