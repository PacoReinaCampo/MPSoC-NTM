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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ntm_math_pkg.all;

package ntm_lstm_controller_pkg is

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant W : integer := 64;
  constant H : integer := 64;

  -----------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------

  component ntm_input_gate_vector is
    generic (
      X : integer := 64;
      W : integer := 64;
      H : integer := 64;

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
      W_IN : in std_logic_arithmetic_vector_matrix(H-1 downto 0)(X-1 downto 0)(DATA_SIZE-1 downto 0);
      K_IN : in std_logic_arithmetic_vector_matrix(H-1 downto 0)(W-1 downto 0)(DATA_SIZE-1 downto 0);
      U_IN : in std_logic_arithmetic_vector_matrix(H-1 downto 0)(H-1 downto 0)(DATA_SIZE-1 downto 0);

      X_IN : in std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
      R_IN : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      H_IN : in std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

      B_IN : in std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
      I_OUT  : out std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  component ntm_output_gate_vector is
    generic (
      X : integer := 64;
      W : integer := 64;
      H : integer := 64;

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
      W_IN : in std_logic_arithmetic_vector_matrix(H-1 downto 0)(X-1 downto 0)(DATA_SIZE-1 downto 0);
      K_IN : in std_logic_arithmetic_vector_matrix(H-1 downto 0)(W-1 downto 0)(DATA_SIZE-1 downto 0);
      U_IN : in std_logic_arithmetic_vector_matrix(H-1 downto 0)(H-1 downto 0)(DATA_SIZE-1 downto 0);

      X_IN : in std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
      R_IN : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      H_IN : in std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

      B_IN : in std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
      O_OUT  : out std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  component ntm_forget_gate_vector is
    generic (
      X : integer := 64;
      W : integer := 64;
      H : integer := 64;

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
      W_IN : in std_logic_arithmetic_vector_matrix(H-1 downto 0)(X-1 downto 0)(DATA_SIZE-1 downto 0);
      K_IN : in std_logic_arithmetic_vector_matrix(H-1 downto 0)(W-1 downto 0)(DATA_SIZE-1 downto 0);
      U_IN : in std_logic_arithmetic_vector_matrix(H-1 downto 0)(H-1 downto 0)(DATA_SIZE-1 downto 0);

      X_IN : in std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
      R_IN : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      H_IN : in std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

      B_IN : in std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
      F_OUT  : out std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  component ntm_state_gate_vector is
    generic (
      X : integer := 64;
      W : integer := 64;
      H : integer := 64;

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
      W_IN : in std_logic_arithmetic_vector_matrix(H-1 downto 0)(X-1 downto 0)(DATA_SIZE-1 downto 0);
      K_IN : in std_logic_arithmetic_vector_matrix(H-1 downto 0)(W-1 downto 0)(DATA_SIZE-1 downto 0);
      U_IN : in std_logic_arithmetic_vector_matrix(H-1 downto 0)(H-1 downto 0)(DATA_SIZE-1 downto 0);

      X_IN : in std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
      R_IN : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      I_IN : in std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
      F_IN : in std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
      S_IN : in std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
      H_IN : in std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

      B_IN : in std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
      S_OUT  : out std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  component ntm_hidden_gate_vector is
    generic (
      H : integer := 64;

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
      S_IN : in std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
      O_IN : in std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
      H_OUT  : out std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  component ntm_controller_output_vector is
    generic (
      Y : integer := 64;
      W : integer := 64;

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
      R_IN  : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      NU_IN : in std_logic_arithmetic_vector_vector(Y-1 downto 0)(DATA_SIZE-1 downto 0);

      W_IN : in std_logic_arithmetic_vector_matrix(Y-1 downto 0)(W-1 downto 0)(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_arithmetic_vector_vector(Y-1 downto 0)(DATA_SIZE-1 downto 0);
      Y_OUT  : out std_logic_arithmetic_vector_vector(Y-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  component ntm_controller is
    generic (
      X : integer := 64;
      Y : integer := 64;
      W : integer := 64;
      H : integer := 64;

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
      R_IN : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_arithmetic_vector_vector(Y-1 downto 0)(DATA_SIZE-1 downto 0);
      Y_OUT  : out std_logic_arithmetic_vector_vector(Y-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

end ntm_lstm_controller_pkg;
