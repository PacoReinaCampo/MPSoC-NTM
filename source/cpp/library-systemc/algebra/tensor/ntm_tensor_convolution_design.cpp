///////////////////////////////////////////////////////////////////////////////////
//                                            __ _      _     _                  //
//                                           / _(_)    | |   | |                 //
//                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 //
//               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 //
//              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 //
//               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 //
//                  | |                                                          //
//                  |_|                                                          //
//                                                                               //
//                                                                               //
//              Peripheral-NTM for MPSoC                                         //
//              Neural Turing Machine for MPSoC                                  //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
//                                                                               //
// Copyright (c) 2020-2024 by the author(s)                                      //
//                                                                               //
// Permission is hereby granted, free of charge, to any person obtaining a copy  //
// of this software and associated documentation files (the "Software"), to deal //
// in the Software without restriction, including without limitation the rights  //
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     //
// copies of the Software, and to permit persons to whom the Software is         //
// furnished to do so, subject to the following conditions:                      //
//                                                                               //
// The above copyright notice and this permission notice shall be included in    //
// all copies or substantial portions of the Software.                           //
//                                                                               //
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    //
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      //
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   //
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        //
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, //
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     //
// THE SOFTWARE.                                                                 //
//                                                                               //
// ============================================================================= //
// Author(s):                                                                    //
//   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////

#include "systemc.h"

#define SIZE_I_IN 4
#define SIZE_J_IN 4
#define SIZE_K_IN 4

SC_MODULE(tensor_convolution) {
  sc_in_clk clock;
  sc_in<sc_int<64>> data_a_in[SIZE_I_IN][SIZE_J_IN][SIZE_K_IN];
  sc_in<sc_int<64>> data_b_in[SIZE_I_IN][SIZE_J_IN][SIZE_K_IN];

  sc_out<sc_int<64>> data_out[SIZE_I_IN][SIZE_J_IN][SIZE_K_IN];

  SC_CTOR(tensor_convolution) {
    SC_METHOD(convolution);
    sensitive << clock.pos();
    for (int i = 0; i < SIZE_I_IN; i++) {
      for (int j = 0; j < SIZE_J_IN; j++) {
        for (int k = 0; k < SIZE_K_IN; k++) {
          sensitive << data_a_in[i][j][k];
          sensitive << data_b_in[i][j][k];
        }
      }
    }
  }

  void convolution() {
    for (int i = 0; i < SIZE_I_IN; i++) {
      for (int j = 0; j < SIZE_J_IN; j++) {
        for (int k = 0; k < SIZE_K_IN; k++) {
          int temporal = 0;

          for (int m = 0; m < i; m++) {
            for (int n = 0; n < j; n++) {
              for (int p = 0; p < k; p++) {
                temporal += data_a_in[m][n][p].read() * data_b_in[i - m][j - n][k - p].read();
              }
            }
          }

          data_out[i][j][k] = temporal;
        }
      }
    }
  }
};
