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
use work.ntm_math_pkg.all;

use work.ntm_transformer_controller_pkg.all;

entity ntm_controller is
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

    K_IN_H_ENABLE : in std_logic;       -- for h in 0 to H-1
    K_IN_D_ENABLE : in std_logic;       -- for d in 0 to D-1
    K_IN_K_ENABLE : in std_logic;       -- for k in 0 to K-1

    Q_IN_H_ENABLE : in std_logic;       -- for h in 0 to H-1
    Q_IN_D_ENABLE : in std_logic;       -- for d in 0 to D-1
    Q_IN_K_ENABLE : in std_logic;       -- for k in 0 to K-1

    V_IN_H_ENABLE : in std_logic;       -- for h in 0 to H-1
    V_IN_D_ENABLE : in std_logic;       -- for d in 0 to D-1
    V_IN_K_ENABLE : in std_logic;       -- for k in 0 to K-1

    Z_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    Z_OUT_N_ENABLE : out std_logic;     -- for n in 0 to N-1
    Z_OUT_D_ENABLE : out std_logic;     -- for d in 0 to D-1


    PE_OUT_L_ENABLE : out std_logic;    -- for l in 0 to L-1
    PE_OUT_N_ENABLE : out std_logic;    -- for n in 0 to N-1
    PE_OUT_D_ENABLE : out std_logic;    -- for d in 0 to D-1

    -- DATA
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_V_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_H_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_P_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    Q_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_OH_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W1_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    B1_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W2_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    B2_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_I_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    K_I_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    V_I_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    D_I_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    X_I_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
    R_I_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
    XI_I_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
    RHO_I_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_O_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    K_O_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    V_O_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    D_O_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    X_O_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
    R_O_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
    XI_O_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
    RHO_O_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    PE_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    Z_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_controller_architecture of ntm_controller is

end architecture;