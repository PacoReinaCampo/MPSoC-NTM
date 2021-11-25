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
use work.ntm_algebra_pkg.all;

entity ntm_algebra_stimulus is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE : integer := 512;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE))   -- i in 0 to R-1
    );
  port (
    -- GLOBAL
    CLK : out std_logic;
    RST : out std_logic;

    -- MATRIX DETERMINANT
    -- CONTROL
    MATRIX_DETERMINANT_START : out std_logic;
    MATRIX_DETERMINANT_READY : in  std_logic;

    MATRIX_DETERMINANT_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_DETERMINANT_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_DETERMINANT_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_DETERMINANT_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_DETERMINANT_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_DETERMINANT_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_DETERMINANT_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_DETERMINANT_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_DETERMINANT_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX INVERSION
    -- CONTROL
    MATRIX_INVERSION_START : out std_logic;
    MATRIX_INVERSION_READY : in  std_logic;

    MATRIX_INVERSION_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_INVERSION_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_INVERSION_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_INVERSION_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_INVERSION_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_INVERSION_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_INVERSION_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_INVERSION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_INVERSION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX PRODUCT
    -- CONTROL
    MATRIX_PRODUCT_START : out std_logic;
    MATRIX_PRODUCT_READY : in  std_logic;

    MATRIX_PRODUCT_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_PRODUCT_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_PRODUCT_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_PRODUCT_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_PRODUCT_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_PRODUCT_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_PRODUCT_MODULO_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_PRODUCT_SIZE_A_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_PRODUCT_SIZE_A_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_PRODUCT_SIZE_B_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_PRODUCT_SIZE_B_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_PRODUCT_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_PRODUCT_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_PRODUCT_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX RANK
    -- CONTROL
    MATRIX_RANK_START : out std_logic;
    MATRIX_RANK_READY : in  std_logic;

    MATRIX_RANK_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_RANK_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_RANK_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_RANK_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_RANK_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_RANK_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_RANK_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_RANK_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_RANK_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX TRANSPOSE
    -- CONTROL
    MATRIX_TRANSPOSE_START : out std_logic;
    MATRIX_TRANSPOSE_READY : in  std_logic;

    MATRIX_TRANSPOSE_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_TRANSPOSE_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_TRANSPOSE_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_TRANSPOSE_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_TRANSPOSE_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_TRANSPOSE_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_TRANSPOSE_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_TRANSPOSE_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_TRANSPOSE_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR PRODUCT
    -- CONTROL
    SCALAR_PRODUCT_START : out std_logic;
    SCALAR_PRODUCT_READY : in  std_logic;

    SCALAR_PRODUCT_DATA_A_IN_ENABLE : out std_logic;
    SCALAR_PRODUCT_DATA_B_IN_ENABLE : out std_logic;

    SCALAR_PRODUCT_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    SCALAR_PRODUCT_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_PRODUCT_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_PRODUCT_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_PRODUCT_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_PRODUCT_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- TENSOR PRODUCT
    -- CONTROL
    TENSOR_PRODUCT_START : out std_logic;
    TENSOR_PRODUCT_READY : in  std_logic;

    TENSOR_PRODUCT_DATA_A_IN_I_ENABLE : out std_logic;
    TENSOR_PRODUCT_DATA_A_IN_J_ENABLE : out std_logic;
    TENSOR_PRODUCT_DATA_A_IN_K_ENABLE : out std_logic;
    TENSOR_PRODUCT_DATA_B_IN_I_ENABLE : out std_logic;
    TENSOR_PRODUCT_DATA_B_IN_J_ENABLE : out std_logic;
    TENSOR_PRODUCT_DATA_B_IN_K_ENABLE : out std_logic;

    TENSOR_PRODUCT_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_PRODUCT_DATA_OUT_J_ENABLE : in std_logic;
    TENSOR_PRODUCT_DATA_OUT_K_ENABLE : in std_logic;

    -- DATA
    TENSOR_PRODUCT_MODULO_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_PRODUCT_SIZE_A_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_PRODUCT_SIZE_A_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_PRODUCT_SIZE_A_K_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_PRODUCT_SIZE_B_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_PRODUCT_SIZE_B_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_PRODUCT_SIZE_B_K_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_PRODUCT_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_PRODUCT_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_PRODUCT_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_algebra_stimulus_architecture of ntm_algebra_stimulus is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant PERIOD : time := 10 ns;

  constant WAITING : time := 50 ns;
  constant WORKING : time := 1000 ms;

  constant ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, DATA_SIZE));
  constant THREE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, DATA_SIZE));

  constant EMPTY : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');
  constant FULL  : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '1');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- LOOP
  signal index_i_loop : std_logic_vector(DATA_SIZE-1 downto 0) := ONE;
  signal index_j_loop : std_logic_vector(DATA_SIZE-1 downto 0) := ONE;
  signal index_k_loop : std_logic_vector(DATA_SIZE-1 downto 0) := ONE;

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

  -- FUNCTIONALITY
  MATRIX_DETERMINANT_START <= start_int;
  MATRIX_INVERSION_START   <= start_int;
  MATRIX_PRODUCT_START     <= start_int;
  MATRIX_RANK_START        <= start_int;
  MATRIX_TRANSPOSE_START   <= start_int;
  SCALAR_PRODUCT_START     <= start_int;
  TENSOR_PRODUCT_START     <= start_int;

  -----------------------------------------------------------------------
  -- STIMULUS
  -----------------------------------------------------------------------

  main_test : process
  begin

    if (STIMULUS_NTM_MATRIX_DETERMINANT_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_DETERMINANT_TEST    ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_DETERMINANT_MODULO_IN <= FULL;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_DETERMINANT_CASE 0  ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_DETERMINANT_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_DETERMINANT_DATA_IN_I_ENABLE <= '0';
        MATRIX_DETERMINANT_DATA_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_DETERMINANT_DATA_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_DETERMINANT_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(SIZE_I)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_DETERMINANT_DATA_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_DETERMINANT_DATA_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_DETERMINANT_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(SIZE_J)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_DETERMINANT_DATA_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_DETERMINANT_DATA_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_DETERMINANT_DATA_IN_I_ENABLE <= '0';
            MATRIX_DETERMINANT_DATA_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_DETERMINANT_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_DETERMINANT_CASE 1  ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_DETERMINANT_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_DETERMINANT_DATA_IN_I_ENABLE <= '0';
        MATRIX_DETERMINANT_DATA_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_DETERMINANT_DATA_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_DETERMINANT_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(SIZE_I)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_DETERMINANT_DATA_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_DETERMINANT_DATA_IN <= TWO;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_DETERMINANT_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(SIZE_J)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_DETERMINANT_DATA_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_DETERMINANT_DATA_IN <= TWO;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_DETERMINANT_DATA_IN_I_ENABLE <= '0';
            MATRIX_DETERMINANT_DATA_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_DETERMINANT_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_INVERSION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_INVERSION_TEST      ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_INVERSION_MODULO_IN <= FULL;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_INVERSION_CASE 0    ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_INVERSION_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_INVERSION_DATA_IN_I_ENABLE <= '0';
        MATRIX_INVERSION_DATA_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_INVERSION_DATA_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_INVERSION_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(SIZE_I)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_INVERSION_DATA_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_INVERSION_DATA_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_INVERSION_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(SIZE_J)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_INVERSION_DATA_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_INVERSION_DATA_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_INVERSION_DATA_IN_I_ENABLE <= '0';
            MATRIX_INVERSION_DATA_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_INVERSION_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_INVERSION_CASE 1    ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_INVERSION_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_INVERSION_DATA_IN_I_ENABLE <= '0';
        MATRIX_INVERSION_DATA_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_INVERSION_DATA_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_INVERSION_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(SIZE_I)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_INVERSION_DATA_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_INVERSION_DATA_IN <= TWO;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_INVERSION_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(SIZE_J)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_INVERSION_DATA_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_INVERSION_DATA_IN <= TWO;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_INVERSION_DATA_IN_I_ENABLE <= '0';
            MATRIX_INVERSION_DATA_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_INVERSION_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_PRODUCT_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_PRODUCT_TEST        ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_PRODUCT_MODULO_IN <= FULL;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_PRODUCT_CASE 0      ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_PRODUCT_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '0';
        MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '0';
        MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_PRODUCT_DATA_A_IN <= ONE;
        MATRIX_PRODUCT_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_PRODUCT_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(SIZE_I)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_PRODUCT_DATA_A_IN <= ONE;
            MATRIX_PRODUCT_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_PRODUCT_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(SIZE_J)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_PRODUCT_DATA_A_IN <= ONE;
            MATRIX_PRODUCT_DATA_B_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_PRODUCT_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_PRODUCT_CASE 1      ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_PRODUCT_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '0';
        MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '0';
        MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_PRODUCT_DATA_A_IN <= TWO;
        MATRIX_PRODUCT_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_PRODUCT_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(SIZE_I)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_PRODUCT_DATA_A_IN <= TWO;
            MATRIX_PRODUCT_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_PRODUCT_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(SIZE_J)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_PRODUCT_DATA_A_IN <= TWO;
            MATRIX_PRODUCT_DATA_B_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_PRODUCT_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_RANK_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_RANK_TEST           ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_RANK_MODULO_IN <= FULL;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_RANK_CASE 0         ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_RANK_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_RANK_DATA_IN_I_ENABLE <= '0';
        MATRIX_RANK_DATA_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_RANK_DATA_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_RANK_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(SIZE_I)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_RANK_DATA_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_RANK_DATA_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_RANK_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(SIZE_J)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_RANK_DATA_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_RANK_DATA_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_RANK_DATA_IN_I_ENABLE <= '0';
            MATRIX_RANK_DATA_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_RANK_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_RANK_CASE 1         ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_RANK_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_RANK_DATA_IN_I_ENABLE <= '0';
        MATRIX_RANK_DATA_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_RANK_DATA_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_RANK_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(SIZE_I)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_RANK_DATA_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_RANK_DATA_IN <= TWO;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_RANK_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(SIZE_J)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_RANK_DATA_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_RANK_DATA_IN <= TWO;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_RANK_DATA_IN_I_ENABLE <= '0';
            MATRIX_RANK_DATA_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_RANK_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_TRANSPOSE_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_TRANSPOSE_TEST      ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_TRANSPOSE_MODULO_IN <= FULL;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_TRANSPOSE_CASE 0    ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_TRANSPOSE_DATA_IN_I_ENABLE <= '0';
        MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_TRANSPOSE_DATA_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_TRANSPOSE_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(SIZE_I)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_TRANSPOSE_DATA_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_TRANSPOSE_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(SIZE_J)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_TRANSPOSE_DATA_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_I_ENABLE <= '0';
            MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_TRANSPOSE_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_TRANSPOSE_CASE 1    ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_TRANSPOSE_DATA_IN_I_ENABLE <= '0';
        MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_TRANSPOSE_DATA_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_TRANSPOSE_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(SIZE_I)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_TRANSPOSE_DATA_IN <= TWO;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_TRANSPOSE_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(SIZE_J)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_TRANSPOSE_DATA_IN <= TWO;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_I_ENABLE <= '0';
            MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_TRANSPOSE_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_PRODUCT_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_PRODUCT_TEST        ";
      -------------------------------------------------------------------

      -- DATA
      SCALAR_PRODUCT_MODULO_IN <= FULL;
      SCALAR_PRODUCT_LENGTH_IN <= THREE;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_SCALAR_PRODUCT_CASE 0      ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_PRODUCT_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        SCALAR_PRODUCT_DATA_A_IN_ENABLE <= '1';
        SCALAR_PRODUCT_DATA_B_IN_ENABLE <= '1';

        -- DATA
        SCALAR_PRODUCT_DATA_A_IN <= ONE;
        SCALAR_PRODUCT_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));

        loop
          if ((SCALAR_PRODUCT_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(SCALAR_PRODUCT_LENGTH_IN)-unsigned(ONE))) then
            -- CONTROL
            SCALAR_PRODUCT_DATA_A_IN_ENABLE <= '1';
            SCALAR_PRODUCT_DATA_B_IN_ENABLE <= '1';

            -- DATA
            SCALAR_PRODUCT_DATA_A_IN <= TWO;
            SCALAR_PRODUCT_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
          else
            -- CONTROL
            SCALAR_PRODUCT_DATA_A_IN_ENABLE <= '0';
            SCALAR_PRODUCT_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when SCALAR_PRODUCT_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_SCALAR_PRODUCT_CASE 1      ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_PRODUCT_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        SCALAR_PRODUCT_DATA_A_IN_ENABLE <= '1';
        SCALAR_PRODUCT_DATA_B_IN_ENABLE <= '1';

        -- DATA
        SCALAR_PRODUCT_DATA_A_IN <= TWO;
        SCALAR_PRODUCT_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));

        loop
          if ((SCALAR_PRODUCT_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(SCALAR_PRODUCT_LENGTH_IN)-unsigned(ONE))) then
            -- CONTROL
            SCALAR_PRODUCT_DATA_A_IN_ENABLE <= '1';
            SCALAR_PRODUCT_DATA_B_IN_ENABLE <= '1';

            -- DATA
            SCALAR_PRODUCT_DATA_B_IN <= TWO;
            SCALAR_PRODUCT_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
          else
            -- CONTROL
            SCALAR_PRODUCT_DATA_A_IN_ENABLE <= '0';
            SCALAR_PRODUCT_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when SCALAR_PRODUCT_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_TENSOR_PRODUCT_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_TENSOR_PRODUCT_TEST        ";
      -------------------------------------------------------------------

      -- DATA
      TENSOR_PRODUCT_MODULO_IN <= FULL;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_TENSOR_PRODUCT_CASE 0      ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_TENSOR_PRODUCT_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        TENSOR_PRODUCT_DATA_A_IN_I_ENABLE <= '0';
        TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '0';
        TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
        TENSOR_PRODUCT_DATA_B_IN_I_ENABLE <= '0';
        TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '0';
        TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '1';

        -- DATA
        TENSOR_PRODUCT_DATA_A_IN <= TWO;
        TENSOR_PRODUCT_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
        index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE));

        loop
          if ((TENSOR_PRODUCT_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(SIZE_I)-unsigned(ONE))) then
            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_I_ENABLE <= '1';

            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TWO;
            TENSOR_PRODUCT_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
            index_k_loop <= ZERO;
          elsif ((TENSOR_PRODUCT_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(SIZE_J)-unsigned(ONE))) then
            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TWO;
            TENSOR_PRODUCT_DATA_B_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
            index_k_loop <= ZERO;
          elsif ((TENSOR_PRODUCT_DATA_OUT_K_ENABLE = '1') and (unsigned(index_k_loop) > unsigned(ONE)) and (unsigned(index_k_loop) < unsigned(SIZE_K)-unsigned(ONE))) then
            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '1';

            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TWO;
            TENSOR_PRODUCT_DATA_B_IN <= ONE;

            -- LOOP
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE));
          else
            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when TENSOR_PRODUCT_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_TENSOR_PRODUCT_CASE 1      ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_TENSOR_PRODUCT_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        TENSOR_PRODUCT_DATA_A_IN_I_ENABLE <= '0';
        TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '0';
        TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
        TENSOR_PRODUCT_DATA_B_IN_I_ENABLE <= '0';
        TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '0';
        TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '1';

        -- DATA
        TENSOR_PRODUCT_DATA_A_IN <= TWO;
        TENSOR_PRODUCT_DATA_B_IN <= TWO;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
        index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE));

        loop
          if ((TENSOR_PRODUCT_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(SIZE_I)-unsigned(ONE))) then
            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_I_ENABLE <= '1';

            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TWO;
            TENSOR_PRODUCT_DATA_B_IN <= TWO;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
            index_k_loop <= ZERO;
          elsif ((TENSOR_PRODUCT_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(SIZE_J)-unsigned(ONE))) then
            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TWO;
            TENSOR_PRODUCT_DATA_B_IN <= TWO;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
            index_k_loop <= ZERO;
          elsif ((TENSOR_PRODUCT_DATA_OUT_K_ENABLE = '1') and (unsigned(index_k_loop) > unsigned(ONE)) and (unsigned(index_k_loop) < unsigned(SIZE_K)-unsigned(ONE))) then
            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '1';

            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TWO;
            TENSOR_PRODUCT_DATA_B_IN <= TWO;

            -- LOOP
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE));
          else
            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when TENSOR_PRODUCT_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
