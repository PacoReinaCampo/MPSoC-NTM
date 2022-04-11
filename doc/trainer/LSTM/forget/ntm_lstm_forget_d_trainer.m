%{
###################################################################################
##                                            __ _      _     _                  ##
##                                           / _(_)    | |   | |                 ##
##                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 ##
##               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 ##
##              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 ##
##               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 ##
##                  | |                                                          ##
##                  |_|                                                          ##
##                                                                               ##
##                                                                               ##
##              Peripheral-NTM for MPSoC                                         ##
##              Neural Turing Machine for MPSoC                                  ##
##                                                                               ##
###################################################################################

###################################################################################
##                                                                               ##
## Copyright (c) 2020-2024 by the author(s)                                      ##
##                                                                               ##
## Permission is hereby granted, free of charge, to any person obtaining a copy  ##
## of this software and associated documentation files (the "Software"), to deal ##
## in the Software without restriction, including without limitation the rights  ##
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     ##
## copies of the Software, and to permit persons to whom the Software is         ##
## furnished to do so, subject to the following conditions:                      ##
##                                                                               ##
## The above copyright notice and this permission notice shall be included in    ##
## all copies or substantial portions of the Software.                           ##
##                                                                               ##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    ##
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      ##
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   ##
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        ##
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, ##
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     ##
## THE SOFTWARE.                                                                 ##
##                                                                               ##
## ============================================================================= ##
## Author(s):                                                                    ##
##   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           ##
##                                                                               ##
###################################################################################
%}

function D_OUT = ntm_lstm_forget_d_trainer(RHO_IN, F_IN, S_IN, LENGTH_IN)
  % Package
  addpath(genpath('../differentiation'));

  % Constants
  [SIZE_T_IN, SIZE_R_IN, SIZE_M_IN] = size(RHO_IN);

  [~, SIZE_L_IN] = size(F_IN);

  % Output Signals
  D_OUT = zeros(SIZE_L_IN, SIZE_R_IN, SIZE_M_IN);

  % Body
  % df(t;l) = ds(t;l) o s(t-1;l) o f(t;l) o (1 - f(t;l))
  vector_ds_int = ntm_vector_controller_differentiation(S_IN, LENGTH_IN);

  vector_df_int = vector_ds_int.*S_IN.*F_IN.*(1-F_IN);

  % dD(l;i;m) = summation(df(t;l) · rho(t;i;m))[t in 0 to T-1]
  vector_dh_int = ntm_vector_controller_differentiation(vector_df_int, LENGTH_IN);

  for t = 1:SIZE_T_IN
    for l = 1:SIZE_L_IN
      for i = 1:SIZE_R_IN
        for m = 1:SIZE_M_IN
          scalar_operation_int = vector_dh_int(t, l)*RHO_IN(t, i, m);

          D_OUT(l, i, m) = D_OUT(l, i, m) + scalar_operation_int;
        end
      end
    end
  end
end