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

use work.model_arithmetic_pkg.all;
use work.model_math_pkg.all;

use work.model_lstm_controller_pkg.all;
use work.model_dnc_core_pkg.all;

entity model_interface_vector is
  generic (
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 64
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    -- Weight
    U_IN_S_ENABLE : in std_logic;       -- for s in 0 to S-1
    U_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1

    U_OUT_S_ENABLE : out std_logic;     -- for s in 0 to S-1
    U_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1

    -- Hidden State
    H_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    H_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    -- Interface
    XI_OUT_ENABLE : out std_logic;      -- for s in 0 to S-1

    -- DATA
    SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    XI_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_interface_vector_architecture of model_interface_vector is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- MATRIX PRODUCT
  -- CONTROL
  signal start_matrix_vector_product : std_logic;
  signal ready_matrix_vector_product : std_logic;

  signal data_a_in_i_enable_matrix_vector_product : std_logic;
  signal data_a_in_j_enable_matrix_vector_product : std_logic;
  signal data_b_in_enable_matrix_vector_product   : std_logic;

  signal data_i_enable_matrix_vector_product : std_logic;
  signal data_j_enable_matrix_vector_product : std_logic;

  signal data_out_enable_matrix_vector_product : std_logic;

  -- DATA
  signal size_a_i_in_matrix_vector_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_matrix_vector_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_in_matrix_vector_product   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_vector_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_vector_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_vector_product    : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- xi(t;s) = U(s;l)·h(t;l)

  -- ASSIGNATIONS
  -- CONTROL
  start_matrix_vector_product <= START;

  READY <= ready_matrix_vector_product;

  data_a_in_i_enable_matrix_vector_product <= U_IN_S_ENABLE;
  data_a_in_j_enable_matrix_vector_product <= U_IN_L_ENABLE;

  data_b_in_enable_matrix_vector_product <= H_IN_ENABLE;

  U_OUT_S_ENABLE <= data_i_enable_matrix_vector_product;
  U_OUT_L_ENABLE <= data_j_enable_matrix_vector_product;

  H_OUT_ENABLE <= data_i_enable_matrix_vector_product;

  XI_OUT_ENABLE <= data_out_enable_matrix_vector_product;

  -- DATA
  size_a_i_in_matrix_vector_product <= SIZE_S_IN;
  size_a_j_in_matrix_vector_product <= SIZE_L_IN;
  size_b_in_matrix_vector_product   <= SIZE_L_IN;
  data_a_in_matrix_vector_product   <= U_IN;
  data_b_in_matrix_vector_product   <= H_IN;

  XI_OUT <= data_out_matrix_vector_product;

  -- MATRIX VECTOR PRODUCT
  matrix_vector_product : model_matrix_vector_product
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_vector_product,
      READY => ready_matrix_vector_product,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_vector_product,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_vector_product,
      DATA_B_IN_ENABLE   => data_b_in_enable_matrix_vector_product,

      DATA_I_ENABLE => data_i_enable_matrix_vector_product,
      DATA_J_ENABLE => data_j_enable_matrix_vector_product,

      DATA_OUT_ENABLE => data_out_enable_matrix_vector_product,

      -- DATA
      SIZE_A_I_IN => size_a_i_in_matrix_vector_product,
      SIZE_A_J_IN => size_a_j_in_matrix_vector_product,
      SIZE_B_IN   => size_b_in_matrix_vector_product,
      DATA_A_IN   => data_a_in_matrix_vector_product,
      DATA_B_IN   => data_b_in_matrix_vector_product,
      DATA_OUT    => data_out_matrix_vector_product
      );

end architecture;
