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

use work.ntm_arithmetic_pkg.all;

entity ntm_scalar_float_multiplier is
  generic (
    DATA_SIZE    : integer := 32;
    CONTROL_SIZE : integer := 64
    );
  port(
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    -- DATA
    DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
    OVERFLOW_OUT : out std_logic
    );
end ntm_scalar_float_multiplier;

architecture ntm_scalar_float_multiplier_architecture of ntm_scalar_float_multiplier is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type multiplier_ctrl_fsm is (
    STARTER_STATE,
    ASIGNATION_STATE,
    OPERATION_STATE,
    NORMALIZATION_STATE,
    ROUND_STATE,
    ENDER_STATE
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant MANTISSA_SIZE : integer := 23;
  constant EXPONENT_SIZE : integer := 8;

  constant ZERO_DATA : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE_DATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));

  constant ZERO_MANTISSA : std_logic_vector(MANTISSA_SIZE+1 downto 0) := std_logic_vector(to_unsigned(0, MANTISSA_SIZE+2));
  constant ONE_MANTISSA  : std_logic_vector(MANTISSA_SIZE+1 downto 0) := std_logic_vector(to_unsigned(1, MANTISSA_SIZE+2));

  constant ZERO_EXPONENT : std_logic_vector(EXPONENT_SIZE downto 0) := std_logic_vector(to_unsigned(0, EXPONENT_SIZE+1));
  constant ONE_EXPONENT  : std_logic_vector(EXPONENT_SIZE downto 0) := std_logic_vector(to_unsigned(1, EXPONENT_SIZE+1));

  constant ZERO_MANTISSA_REGISTER : std_logic_vector(MANTISSA_SIZE downto 0) := std_logic_vector(to_unsigned(0, MANTISSA_SIZE+1));
  constant ONE_MANTISSA_REGISTER  : std_logic_vector(MANTISSA_SIZE downto 0) := std_logic_vector(to_unsigned(1, MANTISSA_SIZE+1));

  constant ZERO_EXPONENT_REGISTER : std_logic_vector(EXPONENT_SIZE+1 downto 0) := std_logic_vector(to_unsigned(0, EXPONENT_SIZE+2));
  constant ONE_EXPONENT_REGISTER  : std_logic_vector(EXPONENT_SIZE+1 downto 0) := std_logic_vector(to_unsigned(1, EXPONENT_SIZE+2));

  constant LIMIT_MANTISSA : std_logic_vector(MANTISSA_SIZE downto 0) := X"800000";

  constant EXPONENT_FULL  : std_logic_vector(EXPONENT_SIZE-1 downto 0) := (others => '1');
  constant EXPONENT_EMPTY : std_logic_vector(EXPONENT_SIZE-1 downto 0) := (others => '0');

  constant BIAS_EXPONENT : std_logic_vector(EXPONENT_SIZE+1 downto 0) := "0001111111";

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal multiplier_ctrl_fsm_int : multiplier_ctrl_fsm;

  -- Data Internal
  signal data_a_in_mantissa_int : std_logic_vector(MANTISSA_SIZE downto 0);
  signal data_b_in_mantissa_int : std_logic_vector(MANTISSA_SIZE downto 0);

  signal data_a_in_exponent_int : std_logic_vector(EXPONENT_SIZE-1 downto 0);
  signal data_b_in_exponent_int : std_logic_vector(EXPONENT_SIZE-1 downto 0);

  signal data_a_in_sign_int : std_logic;
  signal data_b_in_sign_int : std_logic;

  signal data_out_mantissa_int : std_logic_vector(MANTISSA_SIZE downto 0);

  signal data_out_exponent_int : std_logic_vector(EXPONENT_SIZE-1 downto 0);

  signal data_out_sign_int : std_logic;

  signal data_mantissa_int : std_logic_vector(MANTISSA_SIZE+1 downto 0);

  signal data_exponent_int : std_logic_vector(EXPONENT_SIZE+1 downto 0);

  signal data_sign_int : std_logic;

  signal data_product_int : std_logic_vector(MANTISSA_SIZE+1 downto 0);

  signal index_loop : integer;

begin

  -- Data Internal
  data_a_in_mantissa_int <= '1' & DATA_A_IN(MANTISSA_SIZE-1 downto 0);
  data_b_in_mantissa_int <= '1' & DATA_B_IN(MANTISSA_SIZE-1 downto 0);

  data_a_in_exponent_int <= DATA_A_IN(DATA_SIZE-2 downto MANTISSA_SIZE);
  data_b_in_exponent_int <= DATA_B_IN(DATA_SIZE-2 downto MANTISSA_SIZE);

  data_a_in_sign_int <= DATA_A_IN(DATA_SIZE-1);
  data_b_in_sign_int <= DATA_B_IN(DATA_SIZE-1);

  ctrl_fsm : process (CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      OVERFLOW_OUT <= '0';

      -- Control Outputs
      READY <= '0';

      -- Data Internal
      data_out_mantissa_int <= ZERO_MANTISSA_REGISTER;

      data_out_exponent_int <= (others => '0');

      data_out_sign_int <= '0';

      data_mantissa_int <= ZERO_MANTISSA;

      data_exponent_int <= ZERO_EXPONENT_REGISTER;

      data_sign_int <= '0';

      data_product_int <= ZERO_MANTISSA;

    elsif rising_edge(CLK) then
      case multiplier_ctrl_fsm_int is
        when STARTER_STATE =>
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- FSM Control
            multiplier_ctrl_fsm_int <= ASIGNATION_STATE;
          end if;

        when ASIGNATION_STATE =>

          -- Data Internal
          data_mantissa_int <= '0' & data_a_in_mantissa_int;

          data_exponent_int <= std_logic_vector(("00" & unsigned(data_a_in_exponent_int))-("00" & unsigned(data_b_in_exponent_int))+unsigned(BIAS_EXPONENT));

          data_sign_int <= data_a_in_sign_int xor data_b_in_sign_int;

          data_product_int <= ZERO_MANTISSA;

          -- Control Internal
          index_loop <= MANTISSA_SIZE+1;

          -- FSM Control
          multiplier_ctrl_fsm_int <= OPERATION_STATE;

        when OPERATION_STATE =>

          if (data_b_in_mantissa_int = LIMIT_MANTISSA and data_b_in_exponent_int = EXPONENT_EMPTY) then
            -- Data Outputs
            OVERFLOW_OUT <= '1';

            -- Control Outputs
            READY <= '1';

            -- Data Internal
            data_out_mantissa_int <= ZERO_MANTISSA_REGISTER;
            data_out_exponent_int <= (others => '1');
            data_out_sign_int     <= data_sign_int;

            -- FSM Control
            multiplier_ctrl_fsm_int <= STARTER_STATE;
          elsif (
            data_exponent_int(EXPONENT_SIZE+1) = '1' or
            data_exponent_int(EXPONENT_SIZE-1 downto 0) = EXPONENT_EMPTY or
            (data_a_in_exponent_int = EXPONENT_EMPTY and data_a_in_mantissa_int = ZERO_MANTISSA_REGISTER) or
            (data_b_in_exponent_int = EXPONENT_FULL and data_b_in_mantissa_int = ZERO_MANTISSA_REGISTER)) then

            -- Control Outputs
            READY <= '1';

            -- Data Internal
            data_out_mantissa_int <= ZERO_MANTISSA_REGISTER;
            data_out_exponent_int <= (others => '0');
            data_out_sign_int     <= data_sign_int;

            -- FSM Control
            multiplier_ctrl_fsm_int <= STARTER_STATE;
          else
            -- Data Internal
            data_mantissa_int <= std_logic_vector(unsigned(data_mantissa_int)-('1' & unsigned(data_b_in_mantissa_int)));

            -- FSM Control
            multiplier_ctrl_fsm_int <= NORMALIZATION_STATE;
          end if;

        when NORMALIZATION_STATE =>

          -- Data Internal
          if (data_mantissa_int(MANTISSA_SIZE+1) = '1') then
            data_product_int(0) <= '1';
          else
            data_mantissa_int    <= std_logic_vector(unsigned(data_mantissa_int)+('0' & unsigned(data_b_in_mantissa_int)));
            data_product_int(0) <= '0';
          end if;

          -- FSM Control
          multiplier_ctrl_fsm_int <= ROUND_STATE;

        when ROUND_STATE =>

          if (index_loop = 0) then
            -- Data Internal
            if (data_product_int(MANTISSA_SIZE+1) = '0') then
              data_exponent_int <= std_logic_vector(unsigned(data_exponent_int)-unsigned(ONE_EXPONENT_REGISTER));
              data_product_int <= data_product_int(MANTISSA_SIZE downto 0) & '0';
            end if;

            -- FSM Control
            multiplier_ctrl_fsm_int <= ENDER_STATE;
          else
            -- Data Internal
            data_mantissa_int <= data_mantissa_int(MANTISSA_SIZE downto 0) & data_product_int(MANTISSA_SIZE+1);
            data_product_int <= data_product_int(MANTISSA_SIZE downto 0) & '0';

            -- Control Internal
            index_loop <= index_loop-1;

            -- FSM Control
            multiplier_ctrl_fsm_int <= OPERATION_STATE;
          end if;

        when ENDER_STATE =>

          -- Data Internal
          if (data_exponent_int = ZERO_EXPONENT_REGISTER) then
            data_out_mantissa_int <= ZERO_MANTISSA_REGISTER;
            data_out_exponent_int <= (others => '0');
            data_out_sign_int     <= data_sign_int;
          elsif (data_exponent_int(EXPONENT_SIZE+1 downto EXPONENT_SIZE) = "01") then
            data_out_mantissa_int <= ZERO_MANTISSA_REGISTER;
            data_out_exponent_int <= (others => '1');
            data_out_sign_int     <= data_sign_int;
          else
            data_out_mantissa_int <= data_product_int(MANTISSA_SIZE+1 downto 1);
            data_out_exponent_int <= data_exponent_int(EXPONENT_SIZE-1 downto 0);
            data_out_sign_int     <= data_sign_int;
          end if;

          -- Control Outputs
          READY <= '1';

          -- FSM Control
          multiplier_ctrl_fsm_int <= STARTER_STATE;

        when others =>
          -- FSM Control
          multiplier_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- Data Outputs
  DATA_OUT <= data_out_sign_int & data_out_exponent_int & data_out_mantissa_int(MANTISSA_SIZE-1 downto 0);

end ntm_scalar_float_multiplier_architecture;
