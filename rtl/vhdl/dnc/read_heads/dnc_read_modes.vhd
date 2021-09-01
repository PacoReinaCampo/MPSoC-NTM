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

entity dnc_read_modes is
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

    PI_IN_I_ENABLE : in std_logic; -- for i in 0 to R-1
    PI_IN_P_ENABLE : in std_logic; -- for p in 0 to 2

    PI_OUT_I_ENABLE : out std_logic; -- for i in 0 to R-1
    PI_OUT_P_ENABLE : out std_logic; -- for p in 0 to 2

    -- DATA
    PI_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    PI_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
  );
end entity;

architecture dnc_read_modes_architecture of dnc_read_modes is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- MATRIX SOFTMAX
  -- CONTROL
  signal start_matrix_softmax : std_logic;
  signal ready_matrix_softmax : std_logic;

  signal size_in_i_enable_matrix_softmax : std_logic;
  signal size_in_j_enable_matrix_softmax : std_logic;
  signal data_in_i_enable_matrix_softmax : std_logic;
  signal data_in_j_enable_matrix_softmax : std_logic;

  signal data_out_i_enable_matrix_softmax : std_logic;
  signal data_out_j_enable_matrix_softmax : std_logic;

  -- DATA
  signal modulo_matrix_softmax   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_matrix_softmax  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_matrix_softmax  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_softmax : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- pi(t;i;p) = softmax(pi^(t;i;p))

  ntm_matrix_softmax_function_i : ntm_matrix_softmax_function
    generic map (
      I => R,
      J => 3,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_softmax,
      READY => ready_matrix_softmax,

      SIZE_IN_I_ENABLE => size_in_i_enable_matrix_softmax,
      SIZE_IN_J_ENABLE => size_in_j_enable_matrix_softmax,
      DATA_IN_I_ENABLE => data_in_i_enable_matrix_softmax,
      DATA_IN_J_ENABLE => data_in_j_enable_matrix_softmax,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_softmax,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_softmax,

      -- DATA
      MODULO   => modulo_matrix_softmax,
      SIZE_IN  => size_in_matrix_softmax,
      DATA_IN  => data_in_matrix_softmax,
      DATA_OUT => data_out_matrix_softmax
    );

end architecture;
