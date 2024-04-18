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
## Copyright (c) 2022-2023 by the author(s)                                      ##
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

from lstm.activation import ntm_lstm_activation_b_trainer as lstm_activation_b_trainer
from lstm.activation import ntm_lstm_activation_d_trainer as lstm_activation_d_trainer
from lstm.activation import ntm_lstm_activation_k_trainer as lstm_activation_k_trainer
from lstm.activation import ntm_lstm_activation_u_trainer as lstm_activation_u_trainer
from lstm.activation import ntm_lstm_activation_v_trainer as lstm_activation_v_trainer
from lstm.activation import ntm_lstm_activation_w_trainer as lstm_activation_w_trainer
from lstm.activation import ntm_lstm_activation_trainer as lstm_activation_trainer
from lstm.forget import ntm_lstm_forget_b_trainer as lstm_forget_b_trainer
from lstm.forget import ntm_lstm_forget_d_trainer as lstm_forget_d_trainer
from lstm.forget import ntm_lstm_forget_k_trainer as lstm_forget_k_trainer
from lstm.forget import ntm_lstm_forget_u_trainer as lstm_forget_u_trainer
from lstm.forget import ntm_lstm_forget_v_trainer as lstm_forget_v_trainer
from lstm.forget import ntm_lstm_forget_w_trainer as lstm_forget_w_trainer
from lstm.forget import ntm_lstm_forget_trainer as lstm_forget_trainer
from lstm.input import ntm_lstm_input_b_trainer as lstm_input_b_trainer
from lstm.input import ntm_lstm_input_d_trainer as lstm_input_d_trainer
from lstm.input import ntm_lstm_input_k_trainer as lstm_input_k_trainer
from lstm.input import ntm_lstm_input_u_trainer as lstm_input_u_trainer
from lstm.input import ntm_lstm_input_v_trainer as lstm_input_v_trainer
from lstm.input import ntm_lstm_input_w_trainer as lstm_input_w_trainer
from lstm.input import ntm_lstm_input_trainer as lstm_input_trainer
from lstm.output import ntm_lstm_output_b_trainer as lstm_output_b_trainer
from lstm.output import ntm_lstm_output_d_trainer as lstm_output_d_trainer
from lstm.output import ntm_lstm_output_k_trainer as lstm_output_k_trainer
from lstm.output import ntm_lstm_output_u_trainer as lstm_output_u_trainer
from lstm.output import ntm_lstm_output_v_trainer as lstm_output_v_trainer
from lstm.output import ntm_lstm_output_w_trainer as lstm_output_w_trainer
from lstm.output import ntm_lstm_output_trainer as lstm_output_trainer

print('Hello, world!')
