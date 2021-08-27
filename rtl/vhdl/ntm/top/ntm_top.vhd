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

  -- CONTROLLER
  -- CONTROL
  signal start_controller : std_logic;
  signal ready_controller : std_logic;

  -- DATA
  signal x_in_controller : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal r_in_controller : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);

  signal modulo_controller : std_logic_arithmetic_vector_vector(L-1 downto 0)(DATA_SIZE-1 downto 0);
  signal h_out_controller  : std_logic_arithmetic_vector_vector(L-1 downto 0)(DATA_SIZE-1 downto 0);

  -- READ HEADS
  -- CONTROL
  signal start_reading : std_logic;
  signal ready_reading : std_logic;

  -- DATA
  signal modulo_reading : std_logic_arithmetic_vector_vector(Y-1 downto 0)(DATA_SIZE-1 downto 0);
  signal w_in_reading   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal m_in_reading   : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);
  signal r_out_reading  : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);

  -- WRITE HEADS
  -- CONTROL
  signal start_writing : std_logic;
  signal ready_writing : std_logic;

  -- DATA
  signal modulo_writing : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);
  signal m_in_writing   : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);
  signal e_in_writing   : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);
  signal w_in_writing   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal m_out_writing  : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);

  -- MEMORY
  -- CONTROL
  signal start_addressing : std_logic;
  signal ready_addressing : std_logic;

  -- DATA
  signal modulo_addressing : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);
  signal w_in_addressing   : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);
  signal m_in_addressing   : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);
  signal w_out_addressing  : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);

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

  -----------------------------------------------------------------------
  -- READ HEADS
  -----------------------------------------------------------------------

  ntm_reading_i : ntm_reading
    generic map (
      N => N,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_reading,
      READY => ready_reading,

      -- DATA
      MODULO => modulo_reading,
      W_IN   => w_in_reading,
      M_IN   => m_in_reading,
      R_OUT  => r_out_reading
    );

  -----------------------------------------------------------------------
  -- WRITE HEADS
  -----------------------------------------------------------------------

  ntm_writing_i : ntm_writing
    generic map (
      N => N,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_writing,
      READY => ready_writing,

      -- DATA
      MODULO => modulo_writing,
      M_IN   => m_in_writing,
      E_IN   => e_in_writing,
      W_IN   => w_in_writing,
      M_OUT  => m_out_writing
    );

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  ntm_addressing_i : ntm_addressing
    generic map (
      N => N,

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
      MODULO  => modulo_addressing,
      W_IN    => w_in_addressing,
      M_IN    => m_in_addressing,
      W_OUT   => w_out_addressing
    );

end architecture;
