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
-- out the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included out
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
use work.ntm_function_pkg.all;

entity ntm_function_stimulus is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 128;
    CONTROL_SIZE : integer := 64;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x out 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y out 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j out 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k out 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l out 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE))  -- i out 0 to R-1
    );
  port (
    -- GLOBAL
    CLK : out std_logic;
    RST : out std_logic;

    -----------------------------------------------------------------------
    -- STIMULUS SCALAR
    -----------------------------------------------------------------------

    -- SCALAR DIFFERENTIATION
    -- CONTROL
    SCALAR_DIFFERENTIATION_START : out std_logic;
    SCALAR_DIFFERENTIATION_READY : in  std_logic;

    SCALAR_DIFFERENTIATION_DATA_IN_ENABLE : out std_logic;

    SCALAR_DIFFERENTIATION_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    SCALAR_DIFFERENTIATION_PERIOD_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_DIFFERENTIATION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    SCALAR_DIFFERENTIATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_DIFFERENTIATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -----------------------------------------------------------------------
    -- STIMULUS VECTOR
    -----------------------------------------------------------------------

    -- VECTOR DIFFERENTIATION
    -- CONTROL
    VECTOR_DIFFERENTIATION_START : out std_logic;
    VECTOR_DIFFERENTIATION_READY : in  std_logic;

    VECTOR_DIFFERENTIATION_DATA_IN_VECTOR_ENABLE : out std_logic;
    VECTOR_DIFFERENTIATION_DATA_IN_SCALAR_ENABLE : out std_logic;

    VECTOR_DIFFERENTIATION_DATA_OUT_VECTOR_ENABLE : in std_logic;
    VECTOR_DIFFERENTIATION_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    VECTOR_DIFFERENTIATION_PERIOD_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_DIFFERENTIATION_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_DIFFERENTIATION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_DIFFERENTIATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_DIFFERENTIATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -----------------------------------------------------------------------
    -- STIMULUS MATRIX
    -----------------------------------------------------------------------

    -- MATRIX DIFFERENTIATION
    -- CONTROL
    MATRIX_DIFFERENTIATION_START : out std_logic;
    MATRIX_DIFFERENTIATION_READY : in  std_logic;

    MATRIX_DIFFERENTIATION_DATA_IN_MATRIX_ENABLE : out std_logic;
    MATRIX_DIFFERENTIATION_DATA_IN_VECTOR_ENABLE : out std_logic;
    MATRIX_DIFFERENTIATION_DATA_IN_SCALAR_ENABLE : out std_logic;

    MATRIX_DIFFERENTIATION_DATA_OUT_MATRIX_ENABLE : in std_logic;
    MATRIX_DIFFERENTIATION_DATA_OUT_VECTOR_ENABLE : in std_logic;
    MATRIX_DIFFERENTIATION_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    MATRIX_DIFFERENTIATION_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_DIFFERENTIATION_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_DIFFERENTIATION_PERIOD_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_DIFFERENTIATION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_DIFFERENTIATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_DIFFERENTIATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_function_stimulus_architecture of ntm_function_stimulus is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant PERIOD : time := 10 ns;

  constant WAITING : time := 50 ns;
  constant WORKING : time := 1 ms;

  constant ZERO_CONTROL  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, CONTROL_SIZE));
  constant ONE_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, CONTROL_SIZE));
  constant TWO_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, CONTROL_SIZE));
  constant THREE_CONTROL : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, CONTROL_SIZE));

  constant ZERO_DATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant TWO_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, DATA_SIZE));
  constant THREE_DATA : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, DATA_SIZE));

  constant FULL  : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '1');
  constant EMPTY : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  constant EULER : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- LOOP
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0) := ZERO_CONTROL;
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0) := ZERO_CONTROL;
  signal index_k_loop : std_logic_vector(CONTROL_SIZE-1 downto 0) := ZERO_CONTROL;

  -- GLOBAL
  signal clk_int : std_logic;
  signal rst_int : std_logic;

  -- CONTROL
  signal start_int : std_logic;

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- clk generation
  clk_process : process
  begin
    clk_int <= '1';
    wait for PERIOD/2;

    clk_int <= '0';
    wait for PERIOD/2;
  end process;

  CLK <= clk_int;

  -- rst generation
  rst_process : process
  begin
    rst_int <= '0';
    wait for WAITING;

    rst_int <= '1';
    wait for WORKING;
  end process;

  RST <= rst_int;

  -- start generation
  start_process : process
  begin
    start_int <= '0';
    wait for WAITING;

    start_int <= '1';
    wait for PERIOD;

    start_int <= '0';
    wait for WORKING;
  end process;

  -- SCALAR-FUNCTIONALITY
  SCALAR_DIFFERENTIATION_START   <= start_int;

  -- VECTOR-FUNCTIONALITY
  VECTOR_DIFFERENTIATION_START   <= start_int;

  -- MATRIX-FUNCTIONALITY
  MATRIX_DIFFERENTIATION_START   <= start_int;

  -----------------------------------------------------------------------
  -- STIMULUS
  -----------------------------------------------------------------------

  main_test : process
  begin

    -------------------------------------------------------------------
    -- SCALAR-FUNCTION
    -------------------------------------------------------------------

    if (STIMULUS_NTM_SCALAR_DIFFERENTIATION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_DIFFERENTIATION_TEST";
      -------------------------------------------------------------------

      -- DATA
      SCALAR_DIFFERENTIATION_PERIOD_IN <= ONE_DATA;
      SCALAR_DIFFERENTIATION_LENGTH_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_SCALAR_DIFFERENTIATION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_DIFFERENT_CASE 0    ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        SCALAR_DIFFERENTIATION_DATA_IN_ENABLE <= '1';

        -- DATA
        SCALAR_DIFFERENTIATION_DATA_IN <= ONE_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((SCALAR_DIFFERENTIATION_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(SCALAR_DIFFERENTIATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            SCALAR_DIFFERENTIATION_DATA_IN_ENABLE <= '1';

            -- DATA
            SCALAR_DIFFERENTIATION_DATA_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            SCALAR_DIFFERENTIATION_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit when SCALAR_DIFFERENTIATION_READY = '1';
        end loop;
      end if;

      if (STIMULUS_NTM_SCALAR_DIFFERENTIATION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_DIFFERENT_CASE 1    ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        SCALAR_DIFFERENTIATION_DATA_IN_ENABLE <= '1';

        -- DATA
        SCALAR_DIFFERENTIATION_DATA_IN <= TWO_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((SCALAR_DIFFERENTIATION_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(SCALAR_DIFFERENTIATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            SCALAR_DIFFERENTIATION_DATA_IN_ENABLE <= '1';

            -- DATA
            SCALAR_DIFFERENTIATION_DATA_IN <= TWO_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            SCALAR_DIFFERENTIATION_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit when SCALAR_DIFFERENTIATION_READY = '1';
        end loop;
      end if;

      wait for WORKING;

    end if;

    -------------------------------------------------------------------
    -- VECTOR-FUNCTION
    -------------------------------------------------------------------

    -------------------------------------------------------------------
    -- MATRIX-FUNCTION
    -------------------------------------------------------------------

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
