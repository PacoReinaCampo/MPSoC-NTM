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

entity accelerator_scalar_fixed_adder is
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

    OPERATION : in std_logic;

    -- DATA
    DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
    OVERFLOW_OUT : out std_logic
    );
end accelerator_scalar_fixed_adder;

architecture accelerator_scalar_fixed_adder_architecture of accelerator_scalar_float_adder is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  type adder_ctrl_fsm is (
    STARTER_STATE,
    ALIGNMENT_STATE,
    ADDITION_STATE,
    NORMALIZATION_STATE
    );

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  constant MANTISSA_SIZE : integer := 52;
  constant EXPONENT_SIZE : integer := 11;

  constant ZERO_MANTISSA : std_logic_vector(MANTISSA_SIZE+1 downto 0) := std_logic_vector(to_unsigned(0, MANTISSA_SIZE+2));
  constant ONE_MANTISSA  : std_logic_vector(MANTISSA_SIZE+1 downto 0) := std_logic_vector(to_unsigned(1, MANTISSA_SIZE+2));

  constant ZERO_EXPONENT : std_logic_vector(EXPONENT_SIZE downto 0) := std_logic_vector(to_unsigned(0, EXPONENT_SIZE+1));
  constant ONE_EXPONENT  : std_logic_vector(EXPONENT_SIZE downto 0) := std_logic_vector(to_unsigned(1, EXPONENT_SIZE+1));

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal adder_ctrl_fsm_int : adder_ctrl_fsm;

  -- Data Internal
  signal data_a_in_mantissa_int : std_logic_vector(MANTISSA_SIZE+1 downto 0);
  signal data_b_in_mantissa_int : std_logic_vector(MANTISSA_SIZE+1 downto 0);

  signal data_a_in_exponent_int : std_logic_vector(EXPONENT_SIZE downto 0);
  signal data_b_in_exponent_int : std_logic_vector(EXPONENT_SIZE downto 0);

  signal data_a_in_sign_int : std_logic;
  signal data_b_in_sign_int : std_logic;

  signal data_out_mantissa_int : std_logic_vector(MANTISSA_SIZE+1 downto 0);

  signal data_out_exponent_int : std_logic_vector(EXPONENT_SIZE downto 0);

  signal data_out_sign_int : std_logic;

begin

  ctrl_fsm : process (CLK, RST)
  begin
    if(RST = '0') then
      -- Data Outputs
      OVERFLOW_OUT <= '0';

      -- Control Outputs
      READY <= '0';

      -- Data Internal
      data_a_in_mantissa_int <= ZERO_MANTISSA;
      data_b_in_mantissa_int <= ZERO_MANTISSA;

      data_a_in_exponent_int <= ZERO_EXPONENT;
      data_b_in_exponent_int <= ZERO_EXPONENT;

      data_a_in_sign_int <= '0';
      data_b_in_sign_int <= '0';

      data_out_mantissa_int <= ZERO_MANTISSA;

      data_out_exponent_int <= ZERO_EXPONENT;

      data_out_sign_int <= '0';

    elsif rising_edge(CLK) then

      case adder_ctrl_fsm_int is
        when STARTER_STATE =>
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Data Internal
            data_a_in_mantissa_int <= "01" & DATA_A_IN(MANTISSA_SIZE-1 downto 0);
            data_b_in_mantissa_int <= "01" & DATA_B_IN(MANTISSA_SIZE-1 downto 0);

            data_a_in_exponent_int <= '0' & DATA_A_IN(DATA_SIZE-2 downto MANTISSA_SIZE);
            data_b_in_exponent_int <= '0' & DATA_B_IN(DATA_SIZE-2 downto MANTISSA_SIZE);

            data_a_in_sign_int <= DATA_A_IN(DATA_SIZE-1);

            if (OPERATION = '1') then
              data_b_in_sign_int <= not DATA_B_IN(DATA_SIZE-1);
            else
              data_b_in_sign_int <= DATA_B_IN(DATA_SIZE-1);
            end if;

            -- FSM Control
            adder_ctrl_fsm_int <= ALIGNMENT_STATE;
          end if;

        when ALIGNMENT_STATE =>

          if (unsigned(data_a_in_exponent_int) > unsigned(data_b_in_exponent_int)) then
            if (signed(data_a_in_exponent_int)-signed(data_b_in_exponent_int) > to_signed(MANTISSA_SIZE, EXPONENT_SIZE+1)) then
              -- Data Internal
              data_out_mantissa_int <= data_a_in_mantissa_int;

              data_out_exponent_int <= data_a_in_exponent_int;

              data_out_sign_int <= data_a_in_sign_int;

              -- Control Outputs
              READY <= '1';

              -- FSM Control
              adder_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Data Internal
              data_b_in_mantissa_int(MANTISSA_SIZE+1-to_integer(signed(data_a_in_exponent_int)-signed(data_b_in_exponent_int)) downto 0) <= data_b_in_mantissa_int(MANTISSA_SIZE+1 downto to_integer(signed(data_a_in_exponent_int)-signed(data_b_in_exponent_int)));

              data_b_in_mantissa_int(MANTISSA_SIZE+1 downto MANTISSA_SIZE+2-to_integer(signed(data_a_in_exponent_int)-signed(data_b_in_exponent_int))) <= (others => '0');

              data_out_exponent_int <= data_a_in_exponent_int;

              -- FSM Control
              adder_ctrl_fsm_int <= ADDITION_STATE;
            end if;
          elsif (unsigned(data_a_in_exponent_int) < unsigned(data_b_in_exponent_int)) then
            if (signed(data_b_in_exponent_int)-signed(data_a_in_exponent_int) > to_signed(MANTISSA_SIZE, EXPONENT_SIZE+1)) then
              -- Data Internal
              data_out_mantissa_int <= data_b_in_mantissa_int;

              data_out_exponent_int <= data_b_in_exponent_int;

              data_out_sign_int <= data_b_in_sign_int;

              -- Control Outputs
              READY <= '1';

              -- FSM Control
              adder_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Data Internal
              data_a_in_mantissa_int(MANTISSA_SIZE+1-to_integer(signed(data_b_in_exponent_int)-signed(data_a_in_exponent_int)) downto 0) <= data_a_in_mantissa_int(MANTISSA_SIZE+1 downto to_integer(signed(data_b_in_exponent_int)-signed(data_a_in_exponent_int)));

              data_a_in_mantissa_int(MANTISSA_SIZE+1 downto MANTISSA_SIZE+2-to_integer(signed(data_b_in_exponent_int)-signed(data_a_in_exponent_int))) <= (others => '0');

              data_out_exponent_int <= data_b_in_exponent_int;

              -- FSM Control
              adder_ctrl_fsm_int <= ADDITION_STATE;
            end if;
          else
            -- Data Internal
            data_out_exponent_int <= data_a_in_exponent_int;

            -- FSM Control
            adder_ctrl_fsm_int <= ADDITION_STATE;
          end if;

        when ADDITION_STATE =>

          if ((data_a_in_sign_int xor data_b_in_sign_int) = '0') then
            -- Data Internal
            data_out_mantissa_int <= std_logic_vector((unsigned(data_a_in_mantissa_int)+unsigned(data_b_in_mantissa_int)));

            data_out_sign_int <= data_a_in_sign_int;
          elsif (unsigned(data_a_in_mantissa_int) < unsigned(data_b_in_mantissa_int)) then
            -- Data Internal
            data_out_mantissa_int <= std_logic_vector((unsigned(data_b_in_mantissa_int)-unsigned(data_a_in_mantissa_int)));

            data_out_sign_int <= data_b_in_sign_int;
          else
            -- Data Internal
            data_out_mantissa_int <= std_logic_vector((unsigned(data_a_in_mantissa_int)-unsigned(data_b_in_mantissa_int)));

            data_out_sign_int <= data_a_in_sign_int;
          end if;

          -- FSM Control
          adder_ctrl_fsm_int <= NORMALIZATION_STATE;

        when NORMALIZATION_STATE =>

          if unsigned(data_out_mantissa_int) = to_unsigned(0, MANTISSA_SIZE+2) then
            -- Data Internal
            data_out_mantissa_int <= ZERO_MANTISSA;
            data_out_exponent_int <= ZERO_EXPONENT;

            -- Control Outputs
            READY <= '1';

            -- FSM Control
            adder_ctrl_fsm_int <= STARTER_STATE;
          elsif(data_out_mantissa_int(MANTISSA_SIZE+1) = '1') then
            -- Data Internal
            data_out_mantissa_int <= '0' & data_out_mantissa_int(MANTISSA_SIZE+1 downto 1);
            data_out_exponent_int <= std_logic_vector(unsigned(data_out_exponent_int)+unsigned(ONE_EXPONENT));

            -- Control Outputs
            READY <= '1';

            -- FSM Control
            adder_ctrl_fsm_int <= STARTER_STATE;
          elsif(data_out_mantissa_int(MANTISSA_SIZE) = '0') then
            -- Data Internal
            data_out_mantissa_int <= data_out_mantissa_int(MANTISSA_SIZE downto 0) & '0';
            data_out_exponent_int <= std_logic_vector(unsigned(data_out_exponent_int)-unsigned(ONE_EXPONENT));
          else
            -- Control Outputs
            READY <= '1';

            -- FSM Control
            adder_ctrl_fsm_int <= STARTER_STATE;
          end if;

        when others =>
          -- FSM Control
          adder_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- Data Outputs
  DATA_OUT <= data_out_sign_int & data_out_exponent_int(EXPONENT_SIZE-1 downto 0) & data_out_mantissa_int(MANTISSA_SIZE-1 downto 0);

end accelerator_scalar_fixed_adder_architecture;
