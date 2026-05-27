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

-- Copyright (c) 2020-2021 by the author(m)
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
-- Author(m):
--   Paco Reina Campo <pacoreinacampo@queenfield.tech>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.model_arithmetic_vhdl_pkg.all;
use work.model_math_vhdl_pkg.all;

use work.model_ntm_core_vhdl_pkg.all;

entity model_interface_matrix is
  generic (
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 4
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    -- Weight
    U_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    U_IN_M_ENABLE : in std_logic;       -- for m in 0 to M-1
    U_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1

    U_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    U_OUT_M_ENABLE : out std_logic;     -- for m in 0 to M-1
    U_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1

    -- Hidden State
    H_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    H_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1

    H_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    H_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1

    -- Interface
    RHO_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
    RHO_OUT_M_ENABLE : out std_logic;   -- for m in 0 to M-1

    -- DATA
    SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    RHO_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_interface_matrix_architecture of model_interface_matrix is

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
  signal start_tensor_matrix_product : std_logic;
  signal ready_tensor_matrix_product : std_logic;

  signal data_a_in_i_enable_tensor_matrix_product : std_logic;
  signal data_a_in_j_enable_tensor_matrix_product : std_logic;
  signal data_a_in_k_enable_tensor_matrix_product : std_logic;
  signal data_b_in_i_enable_tensor_matrix_product : std_logic;
  signal data_b_in_j_enable_tensor_matrix_product : std_logic;

  signal data_i_enable_tensor_matrix_product : std_logic;
  signal data_j_enable_tensor_matrix_product : std_logic;
  signal data_k_enable_tensor_matrix_product : std_logic;

  signal data_out_i_enable_tensor_matrix_product : std_logic;
  signal data_out_j_enable_tensor_matrix_product : std_logic;

  -- DATA
  signal size_a_i_in_tensor_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_tensor_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_k_in_tensor_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_tensor_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_tensor_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_matrix_product    : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- rho(t;i;m) = U(i;m;l)·h(t;i;l)

  -- ASSIGNATIONS
  -- CONTROL
  start_tensor_matrix_product <= START;

  READY <= ready_tensor_matrix_product;

  data_a_in_i_enable_tensor_matrix_product <= U_IN_I_ENABLE;
  data_a_in_j_enable_tensor_matrix_product <= U_IN_M_ENABLE;
  data_a_in_k_enable_tensor_matrix_product <= U_IN_L_ENABLE;

  data_b_in_i_enable_tensor_matrix_product <= H_IN_I_ENABLE;
  data_b_in_j_enable_tensor_matrix_product <= H_IN_L_ENABLE;

  U_OUT_I_ENABLE <= data_i_enable_tensor_matrix_product;
  U_OUT_M_ENABLE <= data_j_enable_tensor_matrix_product;
  U_OUT_L_ENABLE <= data_k_enable_tensor_matrix_product;

  H_OUT_I_ENABLE <= data_i_enable_tensor_matrix_product;
  H_OUT_L_ENABLE <= data_j_enable_tensor_matrix_product;

  RHO_OUT_I_ENABLE <= data_out_i_enable_tensor_matrix_product;
  RHO_OUT_M_ENABLE <= data_out_j_enable_tensor_matrix_product;

  -- DATA
  size_a_i_in_tensor_matrix_product <= SIZE_R_IN;
  size_a_j_in_tensor_matrix_product <= SIZE_M_IN;
  size_a_k_in_tensor_matrix_product <= SIZE_L_IN;
  size_b_i_in_tensor_matrix_product <= SIZE_I_IN;
  size_b_j_in_tensor_matrix_product <= SIZE_L_IN;
  data_a_in_tensor_matrix_product   <= U_IN;
  data_b_in_tensor_matrix_product   <= H_IN;

  RHO_OUT <= data_out_tensor_matrix_product;

  -- TENSOR MATRIX PRODUCT
  tensor_matrix_product : model_tensor_matrix_product
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_tensor_matrix_product,
      READY => ready_tensor_matrix_product,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_matrix_product,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_matrix_product,
      DATA_A_IN_J_ENABLE => data_a_in_k_enable_tensor_matrix_product,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_matrix_product,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_matrix_product,

      DATA_I_ENABLE => data_i_enable_tensor_matrix_product,
      DATA_J_ENABLE => data_j_enable_tensor_matrix_product,
      DATA_K_ENABLE => data_k_enable_tensor_matrix_product,

      DATA_OUT_I_ENABLE => data_out_i_enable_tensor_matrix_product,
      DATA_OUT_J_ENABLE => data_out_j_enable_tensor_matrix_product,

      -- DATA
      SIZE_A_I_IN => size_a_i_in_tensor_matrix_product,
      SIZE_A_J_IN => size_a_j_in_tensor_matrix_product,
      SIZE_A_K_IN => size_a_k_in_tensor_matrix_product,
      SIZE_B_I_IN => size_b_i_in_tensor_matrix_product,
      SIZE_B_J_IN => size_b_j_in_tensor_matrix_product,
      DATA_A_IN   => data_a_in_tensor_matrix_product,
      DATA_B_IN   => data_b_in_tensor_matrix_product,
      DATA_OUT    => data_out_tensor_matrix_product
      );

end architecture;
