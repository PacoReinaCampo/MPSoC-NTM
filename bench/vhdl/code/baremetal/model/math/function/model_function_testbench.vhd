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

use work.model_arithmetic_pkg.all;
use work.model_math_pkg.all;
use work.model_function_pkg.all;

entity model_function_testbench is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 4;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

    -- SCALAR-FUNCTIONALITY
    ENABLE_NTM_SCALAR_LOGISTIC_TEST : boolean := false;
    ENABLE_NTM_SCALAR_ONEPLUS_TEST  : boolean := false;

    ENABLE_NTM_SCALAR_LOGISTIC_CASE_0 : boolean := false;
    ENABLE_NTM_SCALAR_ONEPLUS_CASE_0  : boolean := false;

    ENABLE_NTM_SCALAR_LOGISTIC_CASE_1 : boolean := false;
    ENABLE_NTM_SCALAR_ONEPLUS_CASE_1  : boolean := false;

    -- VECTOR-FUNCTIONALITY
    ENABLE_NTM_VECTOR_LOGISTIC_TEST : boolean := false;
    ENABLE_NTM_VECTOR_ONEPLUS_TEST  : boolean := false;

    ENABLE_NTM_VECTOR_LOGISTIC_CASE_0 : boolean := false;
    ENABLE_NTM_VECTOR_ONEPLUS_CASE_0  : boolean := false;

    ENABLE_NTM_VECTOR_LOGISTIC_CASE_1 : boolean := false;
    ENABLE_NTM_VECTOR_ONEPLUS_CASE_1  : boolean := false;

    -- MATRIX-FUNCTIONALITY
    ENABLE_NTM_MATRIX_LOGISTIC_TEST : boolean := false;
    ENABLE_NTM_MATRIX_ONEPLUS_TEST  : boolean := false;

    ENABLE_NTM_MATRIX_LOGISTIC_CASE_0 : boolean := false;
    ENABLE_NTM_MATRIX_ONEPLUS_CASE_0  : boolean := false;

    ENABLE_NTM_MATRIX_LOGISTIC_CASE_1 : boolean := false;
    ENABLE_NTM_MATRIX_ONEPLUS_CASE_1  : boolean := false
    );
end model_function_testbench;

architecture model_function_testbench_architecture of model_function_testbench is

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  ------------------------------------------------------------------------------
  -- SCALAR
  ------------------------------------------------------------------------------

  -- SCALAR LOGISTIC
  -- CONTROL
  signal start_scalar_logistic : std_logic;
  signal ready_scalar_logistic : std_logic;

  -- DATA
  signal data_in_scalar_logistic  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_logistic : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR ONEPLUS
  -- CONTROL
  signal start_scalar_oneplus : std_logic;
  signal ready_scalar_oneplus : std_logic;

  -- DATA
  signal data_in_scalar_oneplus  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_oneplus : std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- VECTOR
  ------------------------------------------------------------------------------

  -- VECTOR LOGISTIC
  -- CONTROL
  signal start_vector_logistic : std_logic;
  signal ready_vector_logistic : std_logic;

  signal data_in_enable_vector_logistic : std_logic;

  signal data_out_enable_vector_logistic : std_logic;

  -- DATA
  signal size_in_vector_logistic  : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_logistic  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_logistic : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR ONEPLUS
  -- CONTROL
  signal start_vector_oneplus : std_logic;
  signal ready_vector_oneplus : std_logic;

  signal data_in_enable_vector_oneplus : std_logic;

  signal data_out_enable_vector_oneplus : std_logic;

  -- DATA
  signal size_in_vector_oneplus  : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_oneplus  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_oneplus : std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- MATRIX
  ------------------------------------------------------------------------------

  -- MATRIX LOGISTIC
  -- CONTROL
  signal start_matrix_logistic : std_logic;
  signal ready_matrix_logistic : std_logic;

  signal data_in_i_enable_matrix_logistic : std_logic;
  signal data_in_j_enable_matrix_logistic : std_logic;

  signal data_out_i_enable_matrix_logistic : std_logic;
  signal data_out_j_enable_matrix_logistic : std_logic;

  -- DATA
  signal size_i_in_matrix_logistic : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_logistic : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_logistic   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_logistic  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX ONEPLUS
  -- CONTROL
  signal start_matrix_oneplus : std_logic;
  signal ready_matrix_oneplus : std_logic;

  signal data_in_i_enable_matrix_oneplus : std_logic;
  signal data_in_j_enable_matrix_oneplus : std_logic;

  signal data_out_i_enable_matrix_oneplus : std_logic;
  signal data_out_j_enable_matrix_oneplus : std_logic;

  -- DATA
  signal size_i_in_matrix_oneplus : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_oneplus : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_oneplus   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_oneplus  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  function_stimulus : model_function_stimulus
    generic map (
      -- SYSTEM-SIZE
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE,

      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      ------------------------------------------------------------------------------
      -- STIMULUS SCALAR
      ------------------------------------------------------------------------------

      -- SCALAR LOGISTIC
      -- CONTROL
      SCALAR_LOGISTIC_START => start_scalar_logistic,
      SCALAR_LOGISTIC_READY => ready_scalar_logistic,

      -- DATA
      SCALAR_LOGISTIC_DATA_IN  => data_in_scalar_logistic,
      SCALAR_LOGISTIC_DATA_OUT => data_out_scalar_logistic,

      -- SCALAR ONEPLUS
      -- CONTROL
      SCALAR_ONEPLUS_START => start_scalar_oneplus,
      SCALAR_ONEPLUS_READY => ready_scalar_oneplus,

      -- DATA
      SCALAR_ONEPLUS_DATA_IN  => data_in_scalar_oneplus,
      SCALAR_ONEPLUS_DATA_OUT => data_out_scalar_oneplus,

      ------------------------------------------------------------------------------
      -- STIMULUS VECTOR
      ------------------------------------------------------------------------------

      -- VECTOR LOGISTIC
      -- CONTROL
      VECTOR_LOGISTIC_START => start_vector_logistic,
      VECTOR_LOGISTIC_READY => ready_vector_logistic,

      VECTOR_LOGISTIC_DATA_IN_ENABLE => data_in_enable_vector_logistic,

      VECTOR_LOGISTIC_DATA_OUT_ENABLE => data_out_enable_vector_logistic,

      -- DATA
      VECTOR_LOGISTIC_SIZE_IN  => size_in_vector_logistic,
      VECTOR_LOGISTIC_DATA_IN  => data_in_vector_logistic,
      VECTOR_LOGISTIC_DATA_OUT => data_out_vector_logistic,

      -- VECTOR ONEPLUS
      -- CONTROL
      VECTOR_ONEPLUS_START => start_vector_oneplus,
      VECTOR_ONEPLUS_READY => ready_vector_oneplus,

      VECTOR_ONEPLUS_DATA_IN_ENABLE => data_in_enable_vector_oneplus,

      VECTOR_ONEPLUS_DATA_OUT_ENABLE => data_out_enable_vector_oneplus,

      -- DATA
      VECTOR_ONEPLUS_SIZE_IN  => size_in_vector_oneplus,
      VECTOR_ONEPLUS_DATA_IN  => data_in_vector_oneplus,
      VECTOR_ONEPLUS_DATA_OUT => data_out_vector_oneplus,

      ------------------------------------------------------------------------------
      -- STIMULUS MATRIX
      ------------------------------------------------------------------------------

      -- MATRIX LOGISTIC
      -- CONTROL
      MATRIX_LOGISTIC_START => start_matrix_logistic,
      MATRIX_LOGISTIC_READY => ready_matrix_logistic,

      MATRIX_LOGISTIC_DATA_IN_I_ENABLE => data_in_i_enable_matrix_logistic,
      MATRIX_LOGISTIC_DATA_IN_J_ENABLE => data_in_j_enable_matrix_logistic,

      MATRIX_LOGISTIC_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_logistic,
      MATRIX_LOGISTIC_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_logistic,

      -- DATA
      MATRIX_LOGISTIC_SIZE_I_IN => size_i_in_matrix_logistic,
      MATRIX_LOGISTIC_SIZE_J_IN => size_j_in_matrix_logistic,
      MATRIX_LOGISTIC_DATA_IN   => data_in_matrix_logistic,
      MATRIX_LOGISTIC_DATA_OUT  => data_out_matrix_logistic,

      -- MATRIX ONEPLUS
      -- CONTROL
      MATRIX_ONEPLUS_START => start_matrix_oneplus,
      MATRIX_ONEPLUS_READY => ready_matrix_oneplus,

      MATRIX_ONEPLUS_DATA_IN_I_ENABLE => data_in_i_enable_matrix_oneplus,
      MATRIX_ONEPLUS_DATA_IN_J_ENABLE => data_in_j_enable_matrix_oneplus,

      MATRIX_ONEPLUS_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_oneplus,
      MATRIX_ONEPLUS_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_oneplus,

      -- DATA
      MATRIX_ONEPLUS_SIZE_I_IN => size_i_in_matrix_oneplus,
      MATRIX_ONEPLUS_SIZE_J_IN => size_j_in_matrix_oneplus,
      MATRIX_ONEPLUS_DATA_IN   => data_in_matrix_oneplus,
      MATRIX_ONEPLUS_DATA_OUT  => data_out_matrix_oneplus
      );

  ------------------------------------------------------------------------------
  -- SCALAR
  ------------------------------------------------------------------------------

  -- SCALAR LOGISTIC
  model_scalar_logistic_function_test : if (ENABLE_NTM_SCALAR_LOGISTIC_TEST) generate
    scalar_logistic_function : model_scalar_logistic_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_logistic,
        READY => ready_scalar_logistic,

        -- DATA
        DATA_IN  => data_in_scalar_logistic,
        DATA_OUT => data_out_scalar_logistic
        );
  end generate model_scalar_logistic_function_test;

  -- SCALAR ONEPLUS
  model_scalar_oneplus_function_test : if (ENABLE_NTM_SCALAR_ONEPLUS_TEST) generate
    scalar_oneplus_function : model_scalar_oneplus_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_oneplus,
        READY => ready_scalar_oneplus,

        -- DATA
        DATA_IN  => data_in_scalar_oneplus,
        DATA_OUT => data_out_scalar_oneplus
        );
  end generate model_scalar_oneplus_function_test;

  scalar_assertion : process (CLK, RST)
  begin
    if rising_edge(CLK) then
      if (ready_scalar_logistic = '1') then
        assert data_out_scalar_logistic = function_scalar_logistic(data_in_scalar_logistic)
          report "SCALAR LOGISTIC: CALCULATED = " & to_string(data_out_scalar_logistic) & "; CORRECT = " & to_string(function_scalar_logistic(data_in_scalar_logistic))
          severity error;
      end if;

      if (ready_scalar_oneplus = '1') then
        assert data_out_scalar_oneplus = function_scalar_oneplus(data_in_scalar_oneplus)
          report "SCALAR ONEPLUS: CALCULATED = " & to_string(data_out_scalar_oneplus) & "; CORRECT = " & to_string(function_scalar_oneplus(data_in_scalar_oneplus))
          severity error;
      end if;
    end if;
  end process scalar_assertion;

  ------------------------------------------------------------------------------
  -- VECTOR
  ------------------------------------------------------------------------------

  -- VECTOR LOGISTIC
  model_vector_logistic_function_test : if (ENABLE_NTM_VECTOR_LOGISTIC_TEST) generate
    vector_logistic_function : model_vector_logistic_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_logistic,
        READY => ready_vector_logistic,

        DATA_IN_ENABLE => data_in_enable_vector_logistic,

        DATA_OUT_ENABLE => data_out_enable_vector_logistic,

        -- DATA
        SIZE_IN  => size_in_vector_logistic,
        DATA_IN  => data_in_vector_logistic,
        DATA_OUT => data_out_vector_logistic
        );
  end generate model_vector_logistic_function_test;

  -- VECTOR ONEPLUS
  model_vector_oneplus_function_test : if (ENABLE_NTM_VECTOR_ONEPLUS_TEST) generate
    vector_oneplus_function : model_vector_oneplus_function
      generic map (

        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_oneplus,
        READY => ready_vector_oneplus,

        DATA_IN_ENABLE => data_in_enable_vector_oneplus,

        DATA_OUT_ENABLE => data_out_enable_vector_oneplus,

        -- DATA
        SIZE_IN  => size_in_vector_oneplus,
        DATA_IN  => data_in_vector_oneplus,
        DATA_OUT => data_out_vector_oneplus
        );
  end generate model_vector_oneplus_function_test;

  vector_assertion : process (CLK, RST)
  begin
    if rising_edge(CLK) then
      if (ready_vector_logistic = '1' and data_out_enable_vector_logistic = '1') then
        assert data_out_vector_logistic = function_scalar_logistic(data_in_vector_logistic)
          report "VECTOR LOGISTIC: CALCULATED = " & to_string(data_out_vector_logistic) & "; CORRECT = " & to_string(function_scalar_logistic(data_in_vector_logistic))
          severity error;
      elsif (data_out_enable_vector_logistic = '1' and not data_out_vector_logistic = ZERO_DATA) then
        assert data_out_vector_logistic = function_scalar_logistic(data_in_vector_logistic)
          report "VECTOR LOGISTIC: CALCULATED = " & to_string(data_out_vector_logistic) & "; CORRECT = " & to_string(function_scalar_logistic(data_in_vector_logistic))
          severity error;
      end if;

      if (ready_vector_oneplus = '1' and data_out_enable_vector_oneplus = '1') then
        assert data_out_vector_oneplus = function_scalar_oneplus(data_in_vector_oneplus)
          report "VECTOR ONEPLUS: CALCULATED = " & to_string(data_out_vector_oneplus) & "; CORRECT = " & to_string(function_scalar_oneplus(data_in_vector_oneplus))
          severity error;
      elsif (data_out_enable_vector_oneplus = '1' and not data_out_vector_oneplus = ZERO_DATA) then
        assert data_out_vector_oneplus = function_scalar_oneplus(data_in_vector_oneplus)
          report "VECTOR ONEPLUS: CALCULATED = " & to_string(data_out_vector_oneplus) & "; CORRECT = " & to_string(function_scalar_oneplus(data_in_vector_oneplus))
          severity error;
      end if;
    end if;
  end process vector_assertion;

  ------------------------------------------------------------------------------
  -- MATRIX
  ------------------------------------------------------------------------------

  -- MATRIX LOGISTIC
  model_matrix_logistic_function_test : if (ENABLE_NTM_MATRIX_LOGISTIC_TEST) generate
    matrix_logistic_function : model_matrix_logistic_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_logistic,
        READY => ready_matrix_logistic,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_logistic,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_logistic,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_logistic,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_logistic,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_logistic,
        SIZE_J_IN => size_j_in_matrix_logistic,
        DATA_IN   => data_in_matrix_logistic,
        DATA_OUT  => data_out_matrix_logistic
        );
  end generate model_matrix_logistic_function_test;

  -- MATRIX ONEPLUS
  model_matrix_oneplus_function_test : if (ENABLE_NTM_MATRIX_ONEPLUS_TEST) generate
    matrix_oneplus_function : model_matrix_oneplus_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_oneplus,
        READY => ready_matrix_oneplus,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_oneplus,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_oneplus,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_oneplus,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_oneplus,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_oneplus,
        SIZE_J_IN => size_j_in_matrix_oneplus,
        DATA_IN   => data_in_matrix_oneplus,
        DATA_OUT  => data_out_matrix_oneplus
        );
  end generate model_matrix_oneplus_function_test;

  matrix_assertion : process (CLK, RST)
  begin
    if rising_edge(CLK) then
      if (ready_matrix_logistic = '1' and data_out_i_enable_matrix_logistic = '1' and data_out_j_enable_matrix_logistic = '1') then
        assert data_out_matrix_logistic = function_scalar_logistic(data_in_matrix_logistic)
          report "MATRIX LOGISTIC: CALCULATED = " & to_string(data_out_matrix_logistic) & "; CORRECT = " & to_string(function_scalar_logistic(data_in_matrix_logistic))
          severity error;
      elsif (data_out_i_enable_matrix_logistic = '1' and data_out_j_enable_matrix_logistic = '1' and not data_out_matrix_logistic = ZERO_DATA) then
        assert data_out_matrix_logistic = function_scalar_logistic(data_in_matrix_logistic)
          report "MATRIX LOGISTIC: CALCULATED = " & to_string(data_out_matrix_logistic) & "; CORRECT = " & to_string(function_scalar_logistic(data_in_matrix_logistic))
          severity error;
      elsif (data_out_j_enable_matrix_logistic = '1' and not data_out_matrix_logistic = ZERO_DATA) then
        assert data_out_matrix_logistic = function_scalar_logistic(data_in_matrix_logistic)
          report "MATRIX LOGISTIC: CALCULATED = " & to_string(data_out_matrix_logistic) & "; CORRECT = " & to_string(function_scalar_logistic(data_in_matrix_logistic))
          severity error;
      end if;

      if (ready_matrix_oneplus = '1' and data_out_i_enable_matrix_oneplus = '1' and data_out_j_enable_matrix_oneplus = '1') then
        assert data_out_matrix_oneplus = function_scalar_oneplus(data_in_matrix_oneplus)
          report "MATRIX ONEPLUS: CALCULATED = " & to_string(data_out_matrix_oneplus) & "; CORRECT = " & to_string(function_scalar_oneplus(data_in_matrix_oneplus))
          severity error;
      elsif (data_out_i_enable_matrix_oneplus = '1' and data_out_j_enable_matrix_oneplus = '1' and not data_out_matrix_oneplus = ZERO_DATA) then
        assert data_out_matrix_oneplus = function_scalar_oneplus(data_in_matrix_oneplus)
          report "MATRIX ONEPLUS: CALCULATED = " & to_string(data_out_matrix_oneplus) & "; CORRECT = " & to_string(function_scalar_oneplus(data_in_matrix_oneplus))
          severity error;
      elsif (data_out_j_enable_matrix_oneplus = '1' and not data_out_matrix_oneplus = ZERO_DATA) then
        assert data_out_matrix_oneplus = function_scalar_oneplus(data_in_matrix_oneplus)
          report "MATRIX ONEPLUS: CALCULATED = " & to_string(data_out_matrix_oneplus) & "; CORRECT = " & to_string(function_scalar_oneplus(data_in_matrix_oneplus))
          severity error;
      end if;
    end if;
  end process matrix_assertion;

end model_function_testbench_architecture;
