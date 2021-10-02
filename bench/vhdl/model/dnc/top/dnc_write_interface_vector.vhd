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

entity dnc_write_interface_vector is
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

    -- Write Key
    WK_IN_L_ENABLE : in std_logic;      -- for l in 0 to L-1
    WK_IN_K_ENABLE : in std_logic;      -- for k in 0 to W-1

    K_OUT_ENABLE : out std_logic;       -- for k in 0 to W-1

    -- Write Strength
    WBETA_IN_ENABLE : in std_logic;     -- for l in 0 to L-1

    -- Erase Vector
    WE_IN_L_ENABLE : in std_logic;      -- for l in 0 to L-1
    WE_IN_K_ENABLE : in std_logic;      -- for k in 0 to W-1

    E_OUT_ENABLE : out std_logic;       -- for k in 0 to W-1

    -- Write Vector
    WV_IN_L_ENABLE : in std_logic;      -- for l in 0 to L-1
    WV_IN_K_ENABLE : in std_logic;      -- for k in 0 to W-1

    V_OUT_ENABLE : out std_logic;       -- for k in 0 to W-1

    -- Allocation Gate
    WGA_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

    -- Write Gate
    WGW_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

    -- Hidden State
    H_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    -- DATA
    SIZE_W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    WK_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    WBETA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    WE_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    WV_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    WGA_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
    WGW_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

    H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    K_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0);
    BETA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    E_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0);
    V_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0);
    GA_OUT   : out std_logic_vector(DATA_SIZE-1 downto 0);
    GW_OUT   : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_write_interface_vector_architecture of dnc_write_interface_vector is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- MATRIX PRODUCT
  -- CONTROL
  signal start_matrix_product : std_logic;
  signal ready_matrix_product : std_logic;

  signal data_a_in_i_enable_matrix_product : std_logic;
  signal data_a_in_j_enable_matrix_product : std_logic;
  signal data_b_in_i_enable_matrix_product : std_logic;
  signal data_b_in_j_enable_matrix_product : std_logic;

  signal data_out_i_enable_matrix_product : std_logic;
  signal data_out_j_enable_matrix_product : std_logic;

  -- DATA
  signal modulo_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_a_i_in_matrix_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_a_j_in_matrix_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_b_i_in_matrix_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_b_j_in_matrix_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_product    : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- xi(t;?) = U(t;?;l)·h(t;l)

  -- MATRIX PRODUCT
  matrix_product : ntm_matrix_product
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_product,
      READY => ready_matrix_product,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_product,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_product,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_product,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_product,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_product,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_product,

      -- DATA
      MODULO_IN   => modulo_in_matrix_product,
      SIZE_A_I_IN => size_a_i_in_matrix_product,
      SIZE_A_J_IN => size_a_j_in_matrix_product,
      SIZE_B_I_IN => size_b_i_in_matrix_product,
      SIZE_B_J_IN => size_b_j_in_matrix_product,
      DATA_A_IN   => data_a_in_matrix_product,
      DATA_B_IN   => data_b_in_matrix_product,
      DATA_OUT    => data_out_matrix_product
      );

end architecture;
