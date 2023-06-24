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

use work.accelerator_arithmetic_pkg.all;

entity accelerator_scalar_fixed_multiplier is
  generic (
    DATA_SIZE    : integer := 64;
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
end accelerator_scalar_fixed_multiplier;

architecture accelerator_scalar_fixed_multiplier_architecture of accelerator_scalar_fixed_multiplier is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  type multiplier_ctrl_fsm is (
    STARTER_STATE,
    OPERATION_STATE,
    NORMALIZATION_STATE,
    ENDER_STATE
    );

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  constant MANTISSA_SIZE : integer := 52;
  constant EXPONENT_SIZE : integer := 11;

  constant ZERO_MANTISSA : std_logic_vector(MANTISSA_SIZE-2 downto 0) := std_logic_vector(to_unsigned(0, MANTISSA_SIZE-1));
  constant ONE_MANTISSA  : std_logic_vector(MANTISSA_SIZE-2 downto 0) := std_logic_vector(to_unsigned(1, MANTISSA_SIZE-1));

  constant ZERO_EXPONENT : std_logic_vector(EXPONENT_SIZE downto 0) := std_logic_vector(to_unsigned(0, EXPONENT_SIZE+1));
  constant ONE_EXPONENT  : std_logic_vector(EXPONENT_SIZE downto 0) := std_logic_vector(to_unsigned(1, EXPONENT_SIZE+1));

  constant MANTISSA_FULL  : std_logic_vector(MANTISSA_SIZE-1 downto 0) := (others => '1');
  constant MANTISSA_EMPTY : std_logic_vector(MANTISSA_SIZE-1 downto 0) := (others => '0');

  constant EXPONENT_FULL  : std_logic_vector(EXPONENT_SIZE-1 downto 0) := (others => '1');
  constant EXPONENT_EMPTY : std_logic_vector(EXPONENT_SIZE-1 downto 0) := (others => '0');

  constant ZERO_PRODUCT : std_logic_vector(2*MANTISSA_SIZE+1 downto 0) := std_logic_vector(to_unsigned(0, 2*MANTISSA_SIZE+2));

  constant ZERO_PADDING : std_logic_vector(MANTISSA_SIZE downto 0) := std_logic_vector(to_unsigned(0, MANTISSA_SIZE+1));

  constant BIAS_EXPONENT : std_logic_vector(EXPONENT_SIZE downto 0) := "001111111111";

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal multiplier_ctrl_fsm_int : multiplier_ctrl_fsm;

  -- Data Internal
  signal data_a_in_mantissa_int : std_logic_vector(MANTISSA_SIZE downto 0);
  signal data_b_in_mantissa_int : std_logic_vector(MANTISSA_SIZE downto 0);

  signal data_a_in_exponent_int : std_logic_vector(EXPONENT_SIZE-1 downto 0);
  signal data_b_in_exponent_int : std_logic_vector(EXPONENT_SIZE-1 downto 0);

  signal data_a_in_sign_int : std_logic;
  signal data_b_in_sign_int : std_logic;

  signal data_out_mantissa_int : std_logic_vector(MANTISSA_SIZE-1 downto 0);

  signal data_out_exponent_int : std_logic_vector(EXPONENT_SIZE-1 downto 0);

  signal data_out_sign_int : std_logic;

  signal data_mantissa_int : std_logic_vector(2*MANTISSA_SIZE+1 downto 0);
  signal data_product_int  : std_logic_vector(2*MANTISSA_SIZE+1 downto 0);

  signal data_exponent_int : std_logic_vector(EXPONENT_SIZE downto 0);

  signal data_sign_int : std_logic;

  -- Control Internal
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
      data_out_mantissa_int <= MANTISSA_EMPTY;

      data_out_exponent_int <= EXPONENT_EMPTY;

      data_out_sign_int <= '0';

      data_mantissa_int <= ZERO_PRODUCT;
      data_product_int  <= ZERO_PRODUCT;

      data_exponent_int <= ZERO_EXPONENT;

      data_sign_int <= '0';

    elsif rising_edge(CLK) then
      case multiplier_ctrl_fsm_int is
        when STARTER_STATE =>
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Data Internal
            data_product_int  <= ZERO_PADDING & data_a_in_mantissa_int;
            data_mantissa_int <= ZERO_PRODUCT;

            data_sign_int <= data_a_in_sign_int xor data_b_in_sign_int;

            -- Control Internal
            index_loop <= 0;

            -- FSM Control
            multiplier_ctrl_fsm_int <= OPERATION_STATE;
          end if;

        when OPERATION_STATE =>

          if (unsigned(data_a_in_exponent_int) = unsigned(EXPONENT_FULL) or unsigned(data_b_in_exponent_int) = unsigned(EXPONENT_FULL)) then
            -- Control Outputs
            READY <= '1';

            -- Data Internal
            data_out_exponent_int <= EXPONENT_FULL;
            data_out_mantissa_int <= MANTISSA_EMPTY;
            data_out_sign_int     <= data_sign_int;

            -- FSM Control
            multiplier_ctrl_fsm_int <= STARTER_STATE;
          elsif (unsigned(data_a_in_exponent_int) = unsigned(EXPONENT_EMPTY) or unsigned(data_b_in_exponent_int) = unsigned(EXPONENT_EMPTY)) then
            -- Control Outputs
            READY <= '1';

            -- Data Internal
            data_out_exponent_int <= EXPONENT_EMPTY;
            data_out_mantissa_int <= MANTISSA_EMPTY;
            data_out_sign_int     <= '0';

            -- FSM Control
            multiplier_ctrl_fsm_int <= STARTER_STATE;
          else
            -- Data Internal
            if data_b_in_mantissa_int(index_loop) = '1' then
              data_mantissa_int <= std_logic_vector(unsigned(data_mantissa_int)+unsigned(data_product_int));
            end if;

            data_product_int <= data_product_int(2*MANTISSA_SIZE downto 0) & '0';

            -- FSM Control
            multiplier_ctrl_fsm_int <= NORMALIZATION_STATE;
          end if;

        when NORMALIZATION_STATE =>

          -- Data Internal
          if (data_mantissa_int(2*MANTISSA_SIZE+1) = '1') then
            data_out_mantissa_int <= std_logic_vector(unsigned(data_mantissa_int(2*MANTISSA_SIZE downto MANTISSA_SIZE+1))+(unsigned(ZERO_MANTISSA) & data_mantissa_int(MANTISSA_SIZE)));

            data_exponent_int <= std_logic_vector(('0' & unsigned(data_a_in_exponent_int))+('0' & unsigned(data_b_in_exponent_int))+unsigned(ONE_EXPONENT)-unsigned(BIAS_EXPONENT));
          else
            data_out_mantissa_int <= std_logic_vector(unsigned(data_mantissa_int(2*MANTISSA_SIZE-1 downto MANTISSA_SIZE))+(unsigned(ZERO_MANTISSA) & data_mantissa_int(MANTISSA_SIZE-1)));

            data_exponent_int <= std_logic_vector(('0' & unsigned(data_a_in_exponent_int))+('0' & unsigned(data_b_in_exponent_int))-unsigned(BIAS_EXPONENT));
          end if;

          if (index_loop = MANTISSA_SIZE) then
            -- FSM Control
            multiplier_ctrl_fsm_int <= ENDER_STATE;
          else
            -- Control Internal
            index_loop <= index_loop+1;

            -- FSM Control
            multiplier_ctrl_fsm_int <= OPERATION_STATE;
          end if;

        when ENDER_STATE =>

          -- Data Internal
          if (data_exponent_int(EXPONENT_SIZE downto EXPONENT_SIZE-1) = "10") then
            -- Overflow
            data_out_exponent_int <= EXPONENT_FULL;
            data_out_mantissa_int <= MANTISSA_EMPTY;
            data_out_sign_int     <= data_sign_int;
          elsif (data_exponent_int(EXPONENT_SIZE downto EXPONENT_SIZE-1) = "11") then
            -- Underflow
            data_out_exponent_int <= EXPONENT_EMPTY;
            data_out_mantissa_int <= MANTISSA_EMPTY;
            data_out_sign_int     <= '0';
          else
            -- Normal
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
  DATA_OUT <= data_out_sign_int & data_out_exponent_int & data_out_mantissa_int;

end accelerator_scalar_fixed_multiplier_architecture;
