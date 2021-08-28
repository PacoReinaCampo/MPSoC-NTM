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

entity ntm_output_gate_vector is
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

    W_IN_L_ENABLE : in std_logic; -- for l in 0 to L-1
    W_IN_I_ENABLE : in std_logic; -- for i in 0 to X-1
    X_IN_ENABLE   : in std_logic; -- for i in 0 to X-1

    K_IN_I_ENABLE : in std_logic; -- for i in 0 to R-1 (read heads flow)
    K_IN_L_ENABLE : in std_logic; -- for l in 0 to L-1
    K_IN_J_ENABLE : in std_logic; -- for j in 0 to W-1
    R_IN_I_ENABLE : in std_logic; -- for i in 0 to R-1 (read heads flow)
    R_IN_J_ENABLE : in std_logic; -- for j in 0 to W-1

    U_IN_ENABLE : in std_logic; -- for l in 0 to L-1 (square matrix)
    H_IN_ENABLE : in std_logic; -- for l in 0 to L-1

    B_IN_ENABLE : in std_logic; -- for l in 0 to L-1

    O_OUT_ENABLE : out std_logic; -- for l in 0 to L-1

    -- DATA
    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    O_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
  );
end entity;

architecture ntm_output_gate_vector_architecture of ntm_output_gate_vector is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- SCALAR LOGISTIC FUNCTION
  -- CONTROL
  signal start_scalar_logistic_function : std_logic;
  signal ready_scalar_logistic_function : std_logic;

  -- DATA
  signal modulo_scalar_logistic_function   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_scalar_logistic_function  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_logistic_function : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- o(t;l) = sigmoid(W(t;l)*x(t;l) + K(t;l)*r(t;l) + U(t-1;l)*h(t-1;l) + U(t;l-1)*h(t;l-1) + b(t;l))

  ntm_scalar_logistic_function_i : ntm_scalar_logistic_function
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_logistic_function,
      READY => ready_scalar_logistic_function,

      -- DATA
      MODULO   => modulo_scalar_logistic_function,
      DATA_IN  => data_in_scalar_logistic_function,
      DATA_OUT => data_out_scalar_logistic_function
    );

end architecture;
