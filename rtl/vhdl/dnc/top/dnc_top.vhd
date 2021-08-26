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

    DATA_SIZE : integer := 512
  );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    -- DATA
    X_IN : in std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);

    MODULO : in  std_logic_arithmetic_vector_vector(Y-1 downto 0)(DATA_SIZE-1 downto 0);
    Y_OUT  : out std_logic_arithmetic_vector_vector(Y-1 downto 0)(DATA_SIZE-1 downto 0)
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

  -- DATA
  signal x_in_controller : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal r_in_controller : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);

  signal modulo_controller : std_logic_arithmetic_vector_vector(L-1 downto 0)(DATA_SIZE-1 downto 0);
  signal h_out_controller  : std_logic_arithmetic_vector_vector(L-1 downto 0)(DATA_SIZE-1 downto 0);

  -- OUTPUT VECTOR
  -- CONTROL
  signal start_output_vector : std_logic;
  signal ready_output_vector : std_logic;

  -- DATA
  signal r_in_output_vector : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal nu_in_output_vector : std_logic_arithmetic_vector_vector(L-1 downto 0)(DATA_SIZE-1 downto 0);

  signal w_in_output_vector : std_logic_arithmetic_vector_matrix(Y-1 downto 0)(W-1 downto 0)(DATA_SIZE-1 downto 0);

  signal modulo_output_vector : std_logic_arithmetic_vector_vector(Y-1 downto 0)(DATA_SIZE-1 downto 0);
  signal y_out_output_vector  : std_logic_arithmetic_vector_vector(Y-1 downto 0)(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- READ HEADS
  -----------------------------------------------------------------------

  -- FREE GATES
  -- CONTROL
  signal start_free_gates : std_logic;
  signal ready_free_gates : std_logic;

  -- DATA
  signal f_in_free_gates   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal modulo_free_gates : std_logic_vector(DATA_SIZE-1 downto 0);
  signal f_out_free_gates  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- READ KEYS
  -- CONTROL
  signal start_read_keys : std_logic;
  signal ready_read_keys : std_logic;

  -- DATA
  signal k_in_read_keys   : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal modulo_read_keys : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal k_out_read_keys  : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);

  -- READ MODES
  -- CONTROL
  signal start_read_modes : std_logic;
  signal ready_read_modes : std_logic;

  -- DATA
  signal pi_in_read_modes  : std_logic_arithmetic_vector_vector(2 downto 0)(DATA_SIZE-1 downto 0);
  signal modulo_read_modes : std_logic_arithmetic_vector_vector(2 downto 0)(DATA_SIZE-1 downto 0);
  signal pi_out_read_modes : std_logic_arithmetic_vector_vector(2 downto 0)(DATA_SIZE-1 downto 0);

  -- READ STRENGTHS
  -- CONTROL
  signal start_read_strengths : std_logic;
  signal ready_read_strengths : std_logic;

  -- DATA
  signal beta_in_read_strengths  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal modulo_read_strengths   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_out_read_strengths : std_logic_vector(DATA_SIZE-1 downto 0);

  -- READ INTERFACE VECTOR
  -- CONTROL
  signal start_read_interface_vector : std_logic;
  signal ready_read_interface_vector : std_logic;

  signal wk_in_read_interface_vector    : std_logic_arithmetic_vector_matrix(L-1 downto 0)(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal wbeta_in_read_interface_vector : std_logic_arithmetic_vector_vector(L-1 downto 0)(DATA_SIZE-1 downto 0);
  signal wf_in_read_interface_vector    : std_logic_arithmetic_vector_vector(L-1 downto 0)(DATA_SIZE-1 downto 0);
  signal wpi_in_read_interface_vector   : std_logic_arithmetic_vector_matrix(L-1 downto 0)(2 downto 0)(DATA_SIZE-1 downto 0);

  signal h_in_read_interface_vector : std_logic_arithmetic_vector_vector(L-1 downto 0)(DATA_SIZE-1 downto 0);

  signal k_out_read_interface_vector    : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal beta_out_read_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal f_out_read_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal pi_out_read_interface_vector   : std_logic_arithmetic_vector_vector(2 downto 0)(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- WRITE HEADS
  -----------------------------------------------------------------------

  -- ALLOCATION GATE
  -- CONTROL
  signal start_allocation_gate : std_logic;
  signal ready_allocation_gate : std_logic;

  -- DATA
  signal ga_in_allocation_gate  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal modulo_allocation_gate : std_logic_vector(DATA_SIZE-1 downto 0);
  signal ga_out_allocation_gate : std_logic_vector(DATA_SIZE-1 downto 0);

  -- ERASE VECTOR
  -- CONTROL
  signal start_erase_vector : std_logic;
  signal ready_erase_vector : std_logic;

  -- DATA
  signal e_in_erase_vector   : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal modulo_erase_vector : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal e_out_erase_vector  : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);

  -- WRITE GATE
  -- CONTROL
  signal start_write_gate : std_logic;
  signal ready_write_gate : std_logic;

  -- DATA
  signal gw_in_write_gate  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal modulo_write_gate : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gw_out_write_gate : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE KEY
  -- CONTROL
  signal start_write_key : std_logic;
  signal ready_write_key : std_logic;

  -- DATA
  signal k_in_write_key   : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal modulo_write_key : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal k_out_write_key  : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);

  -- WRITE STRENGHT
  -- CONTROL
  signal start_write_strength : std_logic;
  signal ready_write_strength : std_logic;

  -- DATA
  signal beta_in_write_strength  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal modulo_write_strength   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_out_write_strength : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE VECTOR
  -- CONTROL
  signal start_write_vector : std_logic;
  signal ready_write_vector : std_logic;

  -- DATA
  signal v_in_write_vector   : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal modulo_write_vector : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal v_out_write_vector  : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);

  -- WRITE INTERFACE VECTOR
  -- CONTROL
  signal start_write_interface_vector : std_logic;
  signal ready_write_interface_vector : std_logic;

  -- DATA
  signal wk_in_write_interface_vector    : std_logic_arithmetic_vector_matrix(L-1 downto 0)(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal wbeta_in_write_interface_vector : std_logic_arithmetic_vector_vector(L-1 downto 0)(DATA_SIZE-1 downto 0);
  signal we_in_write_interface_vector    : std_logic_arithmetic_vector_matrix(L-1 downto 0)(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal wv_in_write_interface_vector    : std_logic_arithmetic_vector_matrix(L-1 downto 0)(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal wga_in_write_interface_vector   : std_logic_arithmetic_vector_vector(L-1 downto 0)(DATA_SIZE-1 downto 0);
  signal wgw_in_write_interface_vector   : std_logic_arithmetic_vector_vector(L-1 downto 0)(DATA_SIZE-1 downto 0);

  signal h_in_write_interface_vector : std_logic_arithmetic_vector_vector(L-1 downto 0)(DATA_SIZE-1 downto 0);

  signal k_out_write_interface_vector    : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal beta_out_write_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal e_out_write_interface_vector    : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal v_out_write_interface_vector    : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal ga_out_write_interface_vector   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gw_out_write_interface_vector   : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  -- CONTROL
  signal start_addressing : std_logic;
  signal ready_addressing : std_logic;

    -- DATA
  signal k_read_in_addressing    : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal beta_read_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal f_read_in_addressing    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal pi_read_in_addressing   : std_logic_arithmetic_vector_vector(2 downto 0)(DATA_SIZE-1 downto 0);

  signal k_write_in_addressing    : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal beta_write_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal e_write_in_addressing    : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal v_write_in_addressing    : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal ga_write_in_addressing   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gw_write_in_addressing   : std_logic_vector(DATA_SIZE-1 downto 0);

  signal modulo_addressing : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal r_out_addressing  : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);

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

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_controller,
      READY => ready_controller,

      -- DATA
      X_IN => x_in_controller,
      R_IN => r_in_controller,

      MODULO => modulo_controller,
      H_OUT  => h_out_controller
    );

  -- OUTPUT VECTOR
  output_vector_i : dnc_output_vector
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
      START => start_output_vector,
      READY => ready_output_vector,

      -- DATA
      R_IN  => r_in_output_vector,
      NU_IN => nu_in_output_vector,

      W_IN => w_in_output_vector,

      MODULO => modulo_output_vector,
      Y_OUT  => y_out_output_vector
    );

  -----------------------------------------------------------------------
  -- READ HEADS
  -----------------------------------------------------------------------

  -- FREE GATES
  free_gates : dnc_free_gates
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_free_gates,
      READY => ready_free_gates,

      -- DATA
      F_IN => f_in_free_gates,

      MODULO => modulo_free_gates,
      F_OUT  => f_out_free_gates
    );

  -- READ KEYS
  read_keys : dnc_read_keys
    generic map (
      W => W,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_keys,
      READY => ready_read_keys,

      -- DATA
      K_IN => k_in_read_keys,

      MODULO => modulo_read_keys,
      K_OUT  => k_out_read_keys
    );

  -- READ MODES
  read_modes : dnc_read_modes
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_modes,
      READY => ready_read_modes,

      -- DATA
      PI_IN => pi_in_read_modes,

      MODULO => modulo_read_modes,
      PI_OUT => pi_out_read_modes
    );

  -- READ STRENGTHS
  read_strengths : dnc_read_strengths
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_strengths,
      READY => ready_read_strengths,

      -- DATA
      BETA_IN => beta_in_read_strengths,

      MODULO   => modulo_read_strengths,
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

      MODULO => modulo_allocation_gate,
      GA_OUT => ga_out_allocation_gate
    );

  -- ERASE VECTOR
  erase_vector : dnc_erase_vector
    generic map (
      W => W,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_erase_vector,
      READY => ready_erase_vector,

      -- DATA
      E_IN => e_in_erase_vector,

      MODULO => modulo_erase_vector,
      E_OUT  => e_out_erase_vector
    );

  -- WRITE GATE
  write_gate : dnc_write_gate
    generic map (
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

      MODULO => modulo_write_gate,
      GW_OUT => gw_out_write_gate
    );

  -- WRITE KEY
  write_key : dnc_write_key
    generic map (
      W => W,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_key,
      READY => ready_write_key,

      -- DATA
      K_IN => k_in_write_key,

      MODULO => modulo_write_key,
      K_OUT  => k_out_write_key
    );

  -- WRITE STRENGTH
  write_strength : dnc_write_strength
    generic map (
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

      MODULO   => modulo_write_strength,
      BETA_OUT => beta_out_write_strength
    );

  -- WRITE VECTOR
  write_vector : dnc_write_vector
    generic map (
      W => W,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_vector,
      READY => ready_write_vector,

      -- DATA
      V_IN => v_in_write_vector,

      MODULO => modulo_write_vector,
      V_OUT  => v_out_write_vector
    );

  -- WRITE INTERFACE VECTOR
  write_interface_vector : dnc_write_interface_vector
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
      START => start_write_interface_vector,
      READY => ready_write_interface_vector,

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

  dnc_addressing_i : dnc_addressing
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

      MODULO => modulo_addressing,
      R_OUT  => r_out_addressing
    );

end architecture;
