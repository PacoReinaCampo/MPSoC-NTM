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

import numpy as np

def ntm_encoder(K_IN, Q_IN, V_IN, W_OH_IN, W1_IN, B1_IN, W2_IN, B2_IN, X_IN)
  # Constants
  SIZE_L_IN, SIZE_N_IN, SIZE_D_IN = X_IN.shape

  # Internal Signals
  GAMMA_IN = np.rand(SIZE_N_IN, SIZE_D_IN)
  BETA_IN = np.rand(SIZE_N_IN, SIZE_D_IN)

  x_int = np.zeros(SIZE_N_IN, SIZE_D_IN)

  # Output Signals
  Z_OUT = np.zeros(SIZE_L_IN, SIZE_N_IN, SIZE_D_IN) 

  # Body
  for l in range(len(SIZE_L_IN)):
    for n in range(len(SIZE_N_IN)):
      for d in range(len(SIZE_D_IN)):
        x_int([n][d]) = X_IN([l][n][d])
          
    y_int = ntm_multi_head_attention(K_IN, Q_IN, V_IN, W_OH_IN, x_int)

    z_int = x_int + y_int

    x_int = ntm_layer_norm(z_int, GAMMA_IN, BETA_IN)

    y_int = ntm_fnn(W1_IN, B1_IN, W2_IN, B2_IN, y_int)

    z_int = x_int + y_int

    Z_OUT[l, :, :] = ntm_layer_norm(z_int, GAMMA_IN, BETA_IN)

  return Z_OUT
