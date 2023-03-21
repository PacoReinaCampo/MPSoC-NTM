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

library osvvm;
use osvvm.RandomPkg.all;
use osvvm.CoveragePkg.all;

entity ntm_intro_checker is
end entity ntm_intro_checker;

architecture ntm_intro_checker_architecture of ntm_intro_checker is
begin
  Random_Stimulus : process

    variable RndOp : RandomPType;

    variable covPoint : covPType;

    variable A : std_logic_vector(7 downto 0);

  begin

    RndOp.InitSeed(RndOp'instance_name);

    RndOp.setRandomParm(NORMAL, 30.0, 10.0);

    covPoint.AddBins(GenBin(10, 25, 3));
    covPoint.AddBins(GenBin(26, 50, 8));

    Random_Generation : for i in 0 to 1000 loop
      A := RndOp.RandSlv(10, 50, (20, 21, 22, 23, 24, 25), 8);

      report "A = " & integer'image(to_integer(unsigned(A)));

      covPoint.ICover(to_integer(unsigned(A)));
    end loop;

    report "A Coverage : ";
    covPoint.WriteBin;

    wait;

  end process;

end architecture ntm_intro_checker_architecture;
